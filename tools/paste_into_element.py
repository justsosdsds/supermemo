"""Get real text into a SuperMemo element by using the clipboard + Ctrl+V,
which goes through the application's own paste handler instead of trying to
emulate its custom-drawn editor keystroke by keystroke."""
import ctypes, ctypes.wintypes as w, subprocess, time, os, sys, struct

user32 = ctypes.WinDLL('user32', use_last_error=True)
kernel32 = ctypes.WinDLL('kernel32', use_last_error=True)
C = r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19'

CF_UNICODETEXT = 13
GMEM_MOVEABLE = 0x0002

user32.OpenClipboard.argtypes = [w.HWND]
user32.SetClipboardData.argtypes = [w.UINT, w.HANDLE]
user32.SetClipboardData.restype = w.HANDLE
kernel32.GlobalAlloc.argtypes = [w.UINT, ctypes.c_size_t]
kernel32.GlobalAlloc.restype = w.HGLOBAL
kernel32.GlobalLock.argtypes = [w.HGLOBAL]
kernel32.GlobalLock.restype = ctypes.c_void_p
kernel32.GlobalUnlock.argtypes = [w.HGLOBAL]


def set_clipboard(text):
    data = text.encode('utf-16le') + b'\x00\x00'
    h = kernel32.GlobalAlloc(GMEM_MOVEABLE, len(data))
    p = kernel32.GlobalLock(h)
    ctypes.memmove(p, data, len(data))
    kernel32.GlobalUnlock(h)
    if not user32.OpenClipboard(None):
        return False
    try:
        user32.EmptyClipboard()
        user32.SetClipboardData(CF_UNICODETEXT, h)
    finally:
        user32.CloseClipboard()
    return True


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


def rect(h):
    r = w.RECT()
    user32.GetWindowRect(h, ctypes.byref(r))
    return r.left, r.top, r.right - r.left, r.bottom - r.top


def tap(vk):
    user32.keybd_event(vk, 0, 0, 0)
    time.sleep(0.05)
    user32.keybd_event(vk, 0, 2, 0)
    time.sleep(0.12)


def click(x, y):
    user32.SetCursorPos(x, y)
    time.sleep(0.2)
    user32.mouse_event(0x0002, 0, 0, 0, 0)
    time.sleep(0.06)
    user32.mouse_event(0x0004, 0, 0, 0, 0)
    time.sleep(0.4)


def snap():
    out = {}
    for root, dirs, files in os.walk(C):
        for f in files:
            p = os.path.join(root, f)
            try:
                out[os.path.relpath(p, C)] = os.path.getsize(p)
            except OSError:
                pass
    return out


def main():
    before = snap()
    p = subprocess.Popen([r'F:\Projects\逆向\run\SuperMemo19.exe'], cwd=r'F:\Projects\逆向\run')
    el = None
    for _ in range(16):
        time.sleep(1.5)
        wins = all_windows()
        boxes = [x for x in wins if x[1] == 'TMsgDialog' and x[3]]
        if boxes:
            user32.SetForegroundWindow(boxes[0][0])
            time.sleep(0.3)
            tap(0x0D)
            time.sleep(1.0)
            continue
        els = [x for x in wins if x[1] == 'TElWind' and x[3]]
        if els:
            el = els[0]
            break
    if not el:
        print('no element window')
        p.terminate()
        return 1
    h = el[0]
    print('element window:', h, repr(el[2]))
    user32.SetForegroundWindow(h)
    time.sleep(0.6)

    # create an element
    for ch in children(h):
        if cls_of(ch) == 'TBitBtn' and 'add' in text_of(ch).lower():
            user32.SendMessageW(ch, 0x00F5, 0, 0)
            print('Add new clicked')
            break
    time.sleep(2.5)

    ok = set_clipboard('Capital of France is Paris. The capital of Japan is Tokyo.')
    print('clipboard set:', ok)

    box = None
    for ch in children(h):
        if cls_of(ch) == 'TScrollBox':
            box = ch
            break
    tried = []
    targets = []
    if box:
        x, y, wd, ht = rect(box)
        targets.append((box, x + wd // 2, y + ht // 3, 'scrollbox'))
    x, y, wd, ht = rect(h)
    targets.append((h, x + wd // 2, y + ht // 2, 'element window'))

    for hwnd, cx, cy, tag in targets:
        click(cx, cy)
        time.sleep(0.8)
        # try paste directly and after entering edit mode
        for mode in ('plain', 'f9'):
            if mode == 'f9':
                tap(0x78)
                time.sleep(0.6)
            user32.SetForegroundWindow(h)
            time.sleep(0.3)
            user32.keybd_event(0x11, 0, 0, 0)
            tap(0x56)                     # Ctrl+V
            user32.keybd_event(0x11, 0, 2, 0)
            time.sleep(1.2)
            tried.append('%s/%s' % (tag, mode))
            print('paste attempt:', tag, mode)

    # save
    user32.SetForegroundWindow(h)
    time.sleep(0.5)
    user32.keybd_event(0x11, 0, 0, 0)
    tap(0x53)
    user32.keybd_event(0x11, 0, 2, 0)
    time.sleep(2.5)
    user32.PostMessageW(h, 0x0010, 0, 0)
    time.sleep(3)
    p.terminate()

    after = snap()
    print('\nchanges:')
    changed = False
    for k in sorted(set(before) | set(after)):
        if before.get(k) != after.get(k):
            changed = True
            print('  %-42s %s -> %s' % (k, before.get(k), after.get(k)))
    if not changed:
        print('  none')
    return 0


if __name__ == '__main__':
    sys.exit(main())
