"""Trigger the Learn menu item through the native HMENU and capture the dialog."""
import ctypes, ctypes.wintypes as w, subprocess, time

user32 = ctypes.WinDLL('user32', use_last_error=True)


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


def menu_text(hmenu, idx):
    buf = ctypes.create_unicode_buffer(256)
    user32.GetMenuStringW(hmenu, idx, buf, 256, 0x00000400)  # MF_BYPOSITION
    return buf.value


def find_item(hmenu, wanted, depth=0):
    n = user32.GetMenuItemCount(hmenu)
    for i in range(n):
        txt = menu_text(hmenu, i)
        clean = txt.replace('&', '').strip()
        if clean.lower().startswith(wanted.lower()):
            sub = user32.GetSubMenu(hmenu, i)
            if sub:
                return find_item(sub, wanted, depth + 1) if depth < 1 else None
            return (hmenu, i, user32.GetMenuItemID(hmenu, i), txt)
        sub = user32.GetSubMenu(hmenu, i)
        if sub and depth < 1:
            r = find_item(sub, wanted, depth + 1)
            if r:
                return r
    return None


p = subprocess.Popen([r'F:\Projects\逆向\sm19src\sm19.exe'],
                     cwd=r'F:\Projects\逆向\sm19src')
time.sleep(9)
wins = enum_windows()
main = [x for x in wins if x[2] == 'SuperMemo']
print('main:', main[:1])
if not main:
    p.terminate()
    raise SystemExit(1)

hwnd = main[0][0]
hmenu = user32.GetMenu(hwnd)
print('menu handle:', hmenu, 'items:', user32.GetMenuItemCount(hmenu) if hmenu else -1)

hit = find_item(hmenu, 'Learn')
print('found Learn:', hit)
if hit:
    hmenu_sub, idx, cmd, txt = hit
    print('posting WM_COMMAND id=%d (%s)' % (cmd, txt))
    user32.PostMessageW(hwnd, 0x0111, cmd, 0)
    time.sleep(2.5)

wins = enum_windows()
print('\nwindows after command:')
for h, c, t in wins:
    if not c.startswith(('Chrome', 'Applic', 'Windows.UI', 'Dummy', 'Edge', 'Pseudo', 'Thumb', 'Shell', 'Tao', 'FLUTTER', 'Qt')):
        print('  %-22s %s' % (c, t[:70]))

subprocess.run(['powershell', '-NoProfile', '-Command',
                "Add-Type -AssemblyName System.Windows.Forms,System.Drawing;"
                "$b=[System.Windows.Forms.SystemInformation]::VirtualScreen;"
                "$bmp=New-Object System.Drawing.Bitmap $b.Width,$b.Height;"
                "$g=[System.Drawing.Graphics]::FromImage($bmp);"
                "$g.CopyFromScreen($b.Location,[System.Drawing.Point]::Empty,$b.Size);"
                "$bmp.Save('F:\\Projects\\逆向\\work\\learn_dialog2.png',"
                "[System.Drawing.Imaging.ImageFormat]::Png)"], check=False)
print('screenshot saved')
time.sleep(1)
p.terminate()
