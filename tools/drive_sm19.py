"""Robust driver: start SM19, dismiss any modal message box with Enter, then
type into the element window and save."""
import ctypes, ctypes.wintypes as w, subprocess, time, os, sys

user32 = ctypes.WinDLL('user32', use_last_error=True)
ULONG_PTR = ctypes.c_ulonglong if ctypes.sizeof(ctypes.c_void_p) == 8 else ctypes.c_ulong


class KEYBDINPUT(ctypes.Structure):
    _fields_ = [('wVk', w.WORD), ('wScan', w.WORD), ('dwFlags', w.DWORD),
                ('time', w.DWORD), ('dwExtraInfo', ULONG_PTR)]


class MOUSEINPUT(ctypes.Structure):
    _fields_ = [('dx', w.LONG), ('dy', w.LONG), ('mouseData', w.DWORD),
                ('dwFlags', w.DWORD), ('time', w.DWORD), ('dwExtraInfo', ULONG_PTR)]


class INPUT(ctypes.Structure):
    class _U(ctypes.Union):
        _fields_ = [('ki', KEYBDINPUT), ('mi', MOUSEINPUT)]
    _anonymous_ = ('u',)
    _fields_ = [('type', w.DWORD), ('u', _U)]


def send_unicode(text):
    for ch in text:
        for flags in (4, 4 | 2):
            inp = INPUT(type=1, u=INPUT._U(ki=KEYBDINPUT(0, ord(ch), flags, 0, 0)))
            user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))
            time.sleep(0.008)


def key(vk, up=False):
    inp = INPUT(type=1, u=INPUT._U(ki=KEYBDINPUT(vk, 0, 2 if up else 0, 0, 0)))
    user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))
    time.sleep(0.05)


def click(x, y):
    user32.SetCursorPos(x, y)
    time.sleep(0.15)
    user32.mouse_event(0x0002, 0, 0, 0, 0)
    time.sleep(0.05)
    user32.mouse_event(0x0004, 0, 0, 0, 0)
    time.sleep(0.25)


def enum_windows():
    out = []

    def cb(h, _):
        if not user32.IsWindowVisible(h):
            return True
        b = ctypes.create_unicode_buffer(256)
        user32.GetClassNameW(h, b, 256)
        t = ctypes.create_unicode_buffer(512)
        user32.GetWindowTextW(h, t, 512)
        r = w.RECT()
        user32.GetWindowRect(h, ctypes.byref(r))
        out.append((h, b.value, t.value, (r.left, r.top, r.right - r.left, r.bottom - r.top)))
        return True
    user32.EnumWindows(ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)(cb), 0)
    return out


def main():
    run_dir = r'F:\Projects\逆向\run'
    p = subprocess.Popen([os.path.join(run_dir, 'SuperMemo19.exe')], cwd=run_dir)
    el = None
    for attempt in range(20):
        time.sleep(2)
        wins = enum_windows()
        classes = [c for _, c, _, _ in wins]
        print('t=%2ds windows: %s' % (attempt * 2, classes))
        if 'TMsgDialog' in classes:
            for h, c, t, r in wins:
                if c == 'TMsgDialog':
                    user32.SetForegroundWindow(h)
                    time.sleep(0.3)
            key(0x0D)  # Enter
            key(0x0D, up=True)
            time.sleep(2)
        if 'TElWind' in classes:
            for h, c, t, r in wins:
                if c == 'TElWind':
                    el = (h, r)
                    break
            break
    if not el:
        print('element window never appeared')
        p.terminate()
        return 1

    h, (x, y, wd, ht) = el
    print('element window:', h, rect_ := (x, y, wd, ht))
    user32.SetForegroundWindow(h)
    time.sleep(0.6)
    cx, cy = x + wd // 2, y + ht // 2
    print('click', cx, cy)
    click(cx, cy)
    time.sleep(0.4)
    send_unicode('What is the capital of France?')
    time.sleep(0.6)
    key(0x11); key(0x53); key(0x53, up=True); key(0x11, up=True)
    time.sleep(2.5)
    user32.PostMessageW(h, 0x0010, 0, 0)
    time.sleep(3)
    p.terminate()
    print('finished')
    return 0


if __name__ == '__main__':
    sys.exit(main())
