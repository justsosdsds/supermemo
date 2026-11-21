"""Create elements in the original program by clicking its real TBitBtn controls,
then diff the collection files to learn the element record format."""
import ctypes, ctypes.wintypes as w, subprocess, time, os, struct, sys

user32 = ctypes.WinDLL('user32', use_last_error=True)
C = r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19'


def all_windows():
    out = []

    def cb(h, _):
        b = ctypes.create_unicode_buffer(256)
        user32.GetClassNameW(h, b, 256)
        t = ctypes.create_unicode_buffer(512)
        user32.GetWindowTextW(h, t, 512)
        out.append((h, b.value, t.value, bool(user32.IsWindowVisible(h))))
        return True
    user32.EnumWindows(ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)(cb), 0)
    return out


def children(h):
    items = []

    def cb(ch, _):
        items.append(ch)
        return True
    user32.EnumChildWindows(h, ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)(cb), 0)
    return [c for c in items if user32.GetParent(c) == h]


def cls_of(h):
    b = ctypes.create_unicode_buffer(256)
    user32.GetClassNameW(h, b, 256)
    return b.value


def text_of(h):
    b = ctypes.create_unicode_buffer(512)
    user32.GetWindowTextW(h, b, 512)
    return b.value


def snapshot():
    out = {}
    for root, dirs, files in os.walk(C):
        for f in files:
            p = os.path.join(root, f)
            try:
                out[os.path.relpath(p, C)] = (os.path.getsize(p), os.path.getmtime(p))
            except OSError:
                pass
    return out


def enter():
    user32.keybd_event(0x0D, 0, 0, 0)
    user32.keybd_event(0x0D, 0, 2, 0)


def main():
    before = snapshot()
    p = subprocess.Popen([r'F:\Projects\逆向\run\SuperMemo19.exe'], cwd=r'F:\Projects\逆向\run')
    time.sleep(12)
    for _ in range(4):
        boxes = [x for x in all_windows() if x[1] == 'TMsgDialog' and x[3]]
        if not boxes:
            break
        user32.SetForegroundWindow(boxes[0][0])
        time.sleep(0.3)
        enter()
        time.sleep(2)

    el = [x for x in all_windows() if x[1] == 'TElWind' and x[3]]
    if not el:
        print('no element window')
        p.terminate()
        return 1
    h = el[0][0]
    btns = [(ch, cls_of(ch), text_of(ch)) for ch in children(h)]
    print('element window controls:')
    for b in btns:
        print('   %-9d %-14s %r' % b)

    add = [ch for ch, c, t in btns if c == 'TBitBtn' and 'add' in t.lower()]
    print('add buttons:', add)
    for i in range(3):
        if not add:
            break
        user32.SendMessageW(add[0], 0x00F5, 0, 0)   # BM_CLICK
        print('clicked Add new (#%d)' % (i + 1))
        time.sleep(2.5)

    user32.SetForegroundWindow(h)
    time.sleep(0.5)
    user32.keybd_event(0x11, 0, 0, 0)
    user32.keybd_event(0x53, 0, 0, 0)
    user32.keybd_event(0x53, 0, 2, 0)
    user32.keybd_event(0x11, 0, 2, 0)
    time.sleep(3)
    user32.PostMessageW(h, 0x0010, 0, 0)
    time.sleep(3)
    p.terminate()

    after = snapshot()
    print('\nchanged files:')
    for k in sorted(set(before) | set(after)):
        b = before.get(k)
        a = after.get(k)
        if b != a:
            print('  %-42s %s -> %s' % (k, b[0] if b else '-', a[0] if a else '-'))
    return 0


if __name__ == '__main__':
    sys.exit(main())
