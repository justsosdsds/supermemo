"""Put real RTF into the clipboard and paste it into an element, so that the
rich-text body is stored somewhere and can be reverse engineered."""

import ctypes, ctypes.wintypes as w, subprocess, time, os, sys

user32 = ctypes.WinDLL('user32', use_last_error=True)
kernel32 = ctypes.WinDLL('kernel32', use_last_error=True)
C = r'F:\SMCollections\ABC'

kernel32.GlobalAlloc.argtypes = [w.UINT, ctypes.c_size_t]
kernel32.GlobalAlloc.restype = w.HGLOBAL
kernel32.GlobalLock.argtypes = [w.HGLOBAL]
kernel32.GlobalLock.restype = ctypes.c_void_p
kernel32.GlobalUnlock.argtypes = [w.HGLOBAL]
user32.SetClipboardData.argtypes = [w.UINT, w.HANDLE]
user32.SetClipboardData.restype = w.HANDLE

RTF_BODY = (r"{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil Arial;}}"
            r"\viewkind4\uc1\pard\f0\fs24 Hello \b RTF\b0  world.\par"
            r"This line was pasted as rich text.\par}")


def set_rtf_clipboard(rtf_text):
    fmt = user32.RegisterClipboardFormatW('Rich Text Format')
    data = rtf_text.encode('ascii') + b'\x00'
    h = kernel32.GlobalAlloc(0x0002, len(data))
    p = kernel32.GlobalLock(h)
    ctypes.memmove(p, data, len(data))
    kernel32.GlobalUnlock(h)
    if not user32.OpenClipboard(None):
        return False
    try:
        user32.EmptyClipboard()
        user32.SetClipboardData(fmt, h)
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
    time.sleep(0.06)
    user32.keybd_event(vk, 0, 2, 0)
    time.sleep(0.1)


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
    p = subprocess.Popen([r'F:\Projects\逆向\run\SuperMemo19.exe'],
                         cwd=r'F:\Projects\逆向\run')
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
    user32.SetForegroundWindow(h)
    time.sleep(0.6)

    for ch in children(h):
        if cls_of(ch) == 'TBitBtn' and 'add' in text_of(ch).lower():
            user32.SendMessageW(ch, 0x00F5, 0, 0)
            print('Add new clicked')
            break
    time.sleep(2.5)

    ok = set_rtf_clipboard(RTF_BODY)
    print('rtf clipboard set:', ok)

    box = None
    for ch in children(h):
        if cls_of(ch) == 'TScrollBox':
            box = ch
            break
    if box:
        x, y, wd, ht = rect(box)
        click(x + wd // 2, y + ht // 3)
        time.sleep(0.6)

    user32.SetForegroundWindow(h)
    time.sleep(0.3)
    user32.keybd_event(0x11, 0, 0, 0)
    tap(0x56)
    user32.keybd_event(0x11, 0, 2, 0)
    time.sleep(2)

    user32.keybd_event(0x11, 0, 0, 0)
    tap(0x53)
    user32.keybd_event(0x11, 0, 2, 0)
    time.sleep(3)
    user32.PostMessageW(h, 0x0010, 0, 0)
    time.sleep(3)
    p.terminate()

    after = snap()
    print('\nchanges:')
    for k in sorted(set(before) | set(after)):
        if before.get(k) != after.get(k):
            print('  %-40s %s -> %s' % (k, before.get(k), after.get(k)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
