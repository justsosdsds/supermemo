"""Drive the original SuperMemo 19 through the Win32 API to create real content:
open the sample collection, click into the element window, type text, save.
This produces a non-empty .kno collection to reverse the format against."""
import ctypes, ctypes.wintypes as w, subprocess, time, os, sys, json

user32 = ctypes.WinDLL('user32', use_last_error=True)
kernel32 = ctypes.WinDLL('kernel32', use_last_error=True)

INPUT_MOUSE = 0
INPUT_KEYBOARD = 1
KEYEVENTF_UNICODE = 0x0004
KEYEVENTF_KEYUP = 0x0002

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
        for flags in (KEYEVENTF_UNICODE, KEYEVENTF_UNICODE | KEYEVENTF_KEYUP):
            inp = INPUT(type=INPUT_KEYBOARD,
                        u=INPUT._U(ki=KEYBDINPUT(0, ord(ch), flags, 0, 0)))
            user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))
            time.sleep(0.01)


def press(vk, up=False):
    inp = INPUT(type=INPUT_KEYBOARD, u=INPUT._U(ki=KEYBDINPUT(vk, 0, 2 if up else 0, 0, 0)))
    user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))


def click(x, y):
    user32.SetCursorPos(x, y)
    time.sleep(0.2)
    user32.mouse_event(0x0002, 0, 0, 0, 0)   # LEFTDOWN
    time.sleep(0.05)
    user32.mouse_event(0x0004, 0, 0, 0, 0)   # LEFTUP
    time.sleep(0.3)


def find_window(cls, title_contains=None):
    found = []

    def cb(h, _):
        b = ctypes.create_unicode_buffer(256)
        user32.GetClassNameW(h, b, 256)
        if b.value == cls:
            if title_contains is None:
                found.append(h)
            else:
                t = ctypes.create_unicode_buffer(512)
                user32.GetWindowTextW(h, t, 512)
                if title_contains in t.value:
                    found.append(h)
        return True
    user32.EnumWindows(ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)(cb), 0)
    return found


def rect(h):
    r = w.RECT()
    user32.GetWindowRect(h, ctypes.byref(r))
    return (r.left, r.top, r.right - r.left, r.bottom - r.top)


if __name__ == '__main__':
    run_dir = r'F:\Projects\逆向\run'
    exe = os.path.join(run_dir, 'SuperMemo19.exe')
    p = subprocess.Popen([exe], cwd=run_dir)
    time.sleep(12)

    els = find_window('TElWind')
    print('TElWind windows:', [(h, rect(h)) for h in els])
    if not els:
        print('element window not found')
        p.terminate()
        sys.exit(1)

    h = els[0]
    x, y, wd, ht = rect(h)
    user32.SetForegroundWindow(h)
    time.sleep(0.5)

    # click into the content area (centre of the element window, below the toolbar)
    cx, cy = x + wd // 2, y + ht // 2
    print('clicking', cx, cy)
    click(cx, cy)
    time.sleep(0.5)
    send_unicode('What is the capital of France?')
    time.sleep(0.5)
    # Ctrl+S
    press(0x11)
    press(0x53)
    press(0x53, up=True)
    press(0x11, up=True)
    time.sleep(2.0)

    # close the window politely
    user32.PostMessageW(h, 0x0010, 0, 0)   # WM_CLOSE
    time.sleep(3)
    try:
        p.terminate()
        time.sleep(1)
    except Exception:
        pass
    print('done, process alive:', p.poll() is None)
