"""Drive the rebuilt app's GUI import end to end: open the file dialog,
type the Q&A path, confirm, and capture the result dialog."""
import ctypes, ctypes.wintypes as w, subprocess, time, os

user32 = ctypes.WinDLL('user32', use_last_error=True)
QAFILE = r'F:\SMImport\import_qa.txt'


def wins():
    out = []

    def cb(h, _):
        if user32.IsWindowVisible(h):
            b = ctypes.create_unicode_buffer(256)
            user32.GetClassNameW(h, b, 256)
            t = ctypes.create_unicode_buffer(512)
            user32.GetWindowTextW(h, t, 512)
            out.append((h, b.value, t.value))
        return True
    user32.EnumWindows(ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)(cb), 0)
    return out


def kids(h, deep=True):
    items = []

    def cb(ch, _):
        items.append(ch)
        return True
    if deep:
        user32.EnumChildWindows(h, ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)(cb), 0)
    else:
        user32.EnumChildWindows(h, ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)(cb), 0)
        items = [c for c in items if user32.GetParent(c) == h]
    return items


def cls_of(h):
    b = ctypes.create_unicode_buffer(256)
    user32.GetClassNameW(h, b, 256)
    return b.value


def text_of(h):
    b = ctypes.create_unicode_buffer(1024)
    user32.GetWindowTextW(h, b, 1024)
    return b.value


def mtext(hm, i):
    b = ctypes.create_unicode_buffer(256)
    user32.GetMenuStringW(hm, i, b, 256, 0x400)
    return b.value


def walk(hm, out, d=0):
    for i in range(user32.GetMenuItemCount(hm)):
        t = mtext(hm, i).replace('&', '')
        cid = user32.GetMenuItemID(hm, i)
        sub = user32.GetSubMenu(hm, i)
        out.append((t, cid, bool(sub)))
        if sub and d < 3:
            walk(sub, out, d + 1)


def tap(vk):
    user32.keybd_event(vk, 0, 0, 0)
    time.sleep(0.06)
    user32.keybd_event(vk, 0, 2, 0)
    time.sleep(0.1)


p = subprocess.Popen([r'F:\Projects\逆向\sm19src\sm19.exe'],
                     cwd=r'F:\Projects\逆向\sm19src')
time.sleep(9)
main = [x[0] for x in wins() if x[2] == 'SuperMemo']
if not main:
    p.terminate()
    raise SystemExit('no main window')
h = main[0]
rows = []
walk(user32.GetMenu(h), rows)
cid = [c for t, c, s in rows if not s and c > 0 and 'source code' in t.lower()][0]
user32.PostMessageW(h, 0x0111, cid, 0)
time.sleep(3)

dlg = [x for x in wins() if 'Import Q&A' in x[2]]
print('dialog:', [(x[1], x[2]) for x in dlg])
if not dlg:
    p.terminate()
    raise SystemExit('dialog did not open')

dh = dlg[0][0]
children = [(c, cls_of(c), text_of(c)) for c in kids(dh)]
print('children:')
for c, cl, tx in children[:20]:
    print('   %-22s %r' % (cl, tx[:60]))

edit = [c for c, cl, tx in children if cl in ('Edit', 'TEdit')]
print('edit controls:', edit)
buttons = [(c, tx) for c, cl, tx in children if cl == 'Button']
print('buttons:', buttons[:6])
if edit:
    user32.SetWindowTextW(edit[0], QAFILE)
    time.sleep(0.6)
    user32.SetForegroundWindow(dh)
    time.sleep(0.3)
    opened = [c for c, tx in buttons if '打开' in tx or 'Open' in tx]
    if opened:
        user32.SendMessageW(opened[0], 0x00F5, 0, 0)
        print('clicked Open button')
    else:
        tap(0x0D)
    time.sleep(5)

after = [(x[1], x[2]) for x in wins()
         if x[2] and x[2] not in ('SuperMemo', 'Element Window', 'SuperMemo 19')]
print('after confirm:', after[:6])
time.sleep(1)
p.terminate()

print('\n=== collection now ===')
os.system(r'F:\Projects\逆向\sm19alg\bin\smcli.exe list F:\SMCollections\ABC')
