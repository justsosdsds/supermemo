"""Launch the rebuilt skeleton, drive the Learn menu via keyboard, and capture
the scheduling dialog to prove the engine is reachable from the UI."""
import ctypes, ctypes.wintypes as w, subprocess, time, os

user32 = ctypes.WinDLL('user32', use_last_error=True)
ULONG_PTR = ctypes.c_ulonglong


class KEYBDINPUT(ctypes.Structure):
    _fields_ = [('wVk', w.WORD), ('wScan', w.WORD), ('dwFlags', w.DWORD),
                ('time', w.DWORD), ('dwExtraInfo', ULONG_PTR)]


class _U(ctypes.Union):
    _fields_ = [('ki', KEYBDINPUT)]


class INPUT(ctypes.Structure):
    _anonymous_ = ('u',)
    _fields_ = [('type', w.DWORD), ('u', _U)]


def key(vk, up=False):
    inp = INPUT(type=1, u=_U(ki=KEYBDINPUT(vk, 0, 2 if up else 0, 0, 0)))
    user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))
    time.sleep(0.12)


def tap(vk):
    key(vk)
    key(vk, up=True)


def enum_windows():
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


def main():
    p = subprocess.Popen([r'F:\Projects\逆向\sm19src\sm19.exe'],
                         cwd=r'F:\Projects\逆向\sm19src')
    time.sleep(9)
    wins = enum_windows()
    main = [x for x in wins if x[2] == 'SuperMemo']
    print('main window:', main[:1])
    if main:
        user32.SetForegroundWindow(main[0][0])
        time.sleep(0.8)
        tap(0x12)          # Alt
        time.sleep(0.3)
        tap(0x4C)          # L -> Learn menu
        time.sleep(1.0)
        tap(0x0D)          # Enter
        time.sleep(2.0)
    wins = enum_windows()
    print('after Learn:')
    for h, c, t in wins:
        if c.startswith('T') or 'SuperMemo' in t:
            print('  %-22s %s' % (c, t[:60]))

    # screenshot
    import subprocess as sp
    sp.run(['powershell', '-NoProfile', '-Command',
            "Add-Type -AssemblyName System.Windows.Forms,System.Drawing;"
            "$b=[System.Windows.Forms.SystemInformation]::VirtualScreen;"
            "$bmp=New-Object System.Drawing.Bitmap $b.Width,$b.Height;"
            "$g=[System.Drawing.Graphics]::FromImage($bmp);"
            "$g.CopyFromScreen($b.Location,[System.Drawing.Point]::Empty,$b.Size);"
            "$bmp.Save('F:\\Projects\\逆向\\work\\learn_dialog.png',"
            "[System.Drawing.Imaging.ImageFormat]::Png)"], check=False)
    print('screenshot saved')
    time.sleep(1)
    p.terminate()


if __name__ == '__main__':
    main()
