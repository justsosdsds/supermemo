"""Compare the live control tree of the original binary against the rebuilt
skeleton: launch each, dump every window/child control with class+text, and
aggregate class histograms so runtime-created controls become visible."""
import ctypes, ctypes.wintypes as w, json, sys, time, subprocess, os, collections

user32 = ctypes.WinDLL('user32', use_last_error=True)
WNDENUMPROC = ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)


class RECT(ctypes.Structure):
    _fields_ = [('left', ctypes.c_long), ('top', ctypes.c_long),
                ('right', ctypes.c_long), ('bottom', ctypes.c_long)]


def gtext(h):
    b = ctypes.create_unicode_buffer(512)
    user32.GetWindowTextW(h, b, 512)
    return b.value


def gcls(h):
    b = ctypes.create_unicode_buffer(256)
    user32.GetClassNameW(h, b, 256)
    return b.value


def grect(h):
    r = RECT()
    user32.GetWindowRect(h, ctypes.byref(r))
    return (r.left, r.top, r.right - r.left, r.bottom - r.top)


def subtree(h):
    items = []

    def cb(ch, _):
        items.append(ch)
        return True
    user32.EnumChildWindows(h, WNDENUMPROC(cb), 0)
    return [dict(cls=gcls(c), text=gtext(c)[:40], rect=grect(c),
                 visible=bool(user32.IsWindowVisible(c))) for c in items]


def collect(pid):
    wins = []

    def cb(h, _):
        p = w.DWORD()
        user32.GetWindowThreadProcessId(h, ctypes.byref(p))
        if p.value == pid:
            wins.append(h)
        return True
    user32.EnumWindows(WNDENUMPROC(cb), 0)
    out = []
    for h in wins:
        out.append(dict(cls=gcls(h), text=gtext(h), rect=grect(h),
                        visible=bool(user32.IsWindowVisible(h)),
                        children=subtree(h)))
    return out


def run(exe, wait, tag, workdir):
    p = subprocess.Popen([exe], cwd=workdir)
    time.sleep(wait)
    tree = collect(p.pid)
    json.dump(tree, open(os.path.join(r'F:\Projects\逆向\work', 'tree_%s.json' % tag),
                         'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    hist = collections.Counter()
    total = 0
    for wnd in tree:
        hist[wnd['cls']] += 1
        for c in wnd['children']:
            hist[c['cls']] += 1
            total += 1
    print('\n=== %s ===' % tag)
    print('top windows:')
    for wnd in sorted(tree, key=lambda x: -len(x['children']))[:6]:
        print('  %-24s %-34s visible=%-5s children=%d' % (
            wnd['cls'], wnd['text'][:34], wnd['visible'], len(wnd['children'])))
    print('child controls total:', total)
    for k, v in hist.most_common(22):
        print('  %-26s %d' % (k, v))
    p.terminate()
    time.sleep(1)
    try:
        p.kill()
    except Exception:
        pass
    return tree


if __name__ == '__main__':
    run(r'F:\Projects\逆向\run\SuperMemo19.exe', 14, 'original', r'F:\Projects\逆向\run')
    run(r'F:\Projects\逆向\sm19src\sm19.exe', 10, 'skeleton', r'F:\Projects\逆向\sm19src')
