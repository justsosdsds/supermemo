"""Patch gen_skeleton.py: track the event KIND per handler (OnClick vs OnCreate)
so only interactive handlers get wired to DispatchAction."""
import re, io, os

P = r'F:\Projects\逆向\tools\gen_skeleton.py'
src = open(P, encoding='utf-8').read()

# --- 1. collect_events now records params AND event kinds ---
old_fun = '''def collect_events(root):
    """event name -> set of (param list) plus owner info"""
    ev = {}
    for node in walk(root):
        for k, (t, v) in node['props']:
            if t == 'ident' and k.startswith('On') and v and v not in ('nil',):
                ev.setdefault(v, set()).add(safe_sig(EVENT_SIG.get(k, 'Sender: TObject')))
    return ev'''

new_fun = '''def collect_events(root):
    """handler name -> dict(params=set of signatures, kinds=set of event names)"""
    ev = {}
    for node in walk(root):
        for k, (t, v) in node['props']:
            if t == 'ident' and k.startswith('On') and v and v not in ('nil',):
                d = ev.setdefault(v, dict(params=set(), kinds=set()))
                d['params'].add(safe_sig(EVENT_SIG.get(k, 'Sender: TObject')))
                d['kinds'].add(k)
    return ev'''

assert old_fun in src, 'collect_events not found'
src = src.replace(old_fun, new_fun)

# --- 2. gen_unit: adapt to the new structure ---
src = src.replace(
    "    conflicts = {n: s for n, s in events.items() if len(s) > 1}",
    "    conflicts = {n: d['params'] for n, d in events.items() if len(d['params']) > 1}")
src = src.replace(
    "            buf.write('    procedure %s(%s);\\n' % (pident(ev), list(events[ev])[0]))\n        buf.write('  end;\\n')",
    "            buf.write('    procedure %s(%s);\\n' % (pident(ev), list(events[ev]['params'])[0]))\n        buf.write('  end;\\n')")
src = src.replace(
    "            buf.write('    procedure %s(%s);\\n' % (pident(ev), list(events[ev])[0]))",
    "            buf.write('    procedure %s(%s);\\n' % (pident(ev), list(events[ev]['params'])[0]))")
src = src.replace(
    "    for ev in sorted(events):\n        if ev in INTERACTIVE_EVENTS:",
    "    for ev in sorted(events):\n        if events[ev]['kinds'] & INTERACTIVE_EVENTS:")
src = src.replace(
    "                cls, pident(ev), list(events[ev])[0], pident(ev)))",
    "                cls, pident(ev), list(events[ev]['params'])[0], pident(ev)))")
src = src.replace(
    "                cls, pident(ev), list(events[ev])[0]))",
    "                cls, pident(ev), list(events[ev]['params'])[0]))")

open(P, 'w', encoding='utf-8', newline='\n').write(src)
print('gen_skeleton patched')

# sanity
for key in ("d['params']", "events[ev]['kinds']"):
    print(key, 'occurrences:', src.count(key))
