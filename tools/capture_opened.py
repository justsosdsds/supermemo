import ctypes, ctypes.wintypes as w, subprocess, time

user32 = ctypes.WinDLL('user32', use_last_error=True)


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


def shot(name):
    ps = (
        "Add-Type -AssemblyName System.Windows.Forms,System.Drawing;"
        "$b=[System.Windows.Forms.SystemInformation]::VirtualScreen;"
        "$bmp=New-Object System.Drawing.Bitmap $b.Width,$b.Height;"
        "$g=[System.Drawing.Graphics]::FromImage($bmp);"
        "$g.CopyFromScreen($b.Location,[System.Drawing.Point]::Empty,$b.Size);"
        "$bmp.Save('F:\\Projects\\逆向\\work\\"
        + name +
        ".png',[System.Drawing.Imaging.ImageFormat]::Png)"
    )
    subprocess.run(['powershell', '-NoProfile', '-Command', ps], check=False)


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

for kw in ('Options', 'Browser', 'Statistics'):
    cids = [c for t, c, s in rows if not s and c > 0 and kw.lower() in t.lower()]
    if not cids:
        print('no command for', kw)
        continue
    user32.PostMessageW(h, 0x0111, cids[0], 0)
    time.sleep(3)
    opened = [t for _, _, t in wins() if kw.lower() in t.lower()]
    print('opened', kw, '->', opened[:3])
    shot('opened_%s' % kw.lower())
    user32.keybd_event(0x1B, 0, 0, 0)
    user32.keybd_event(0x1B, 0, 2, 0)
    time.sleep(1.5)

p.terminate()
print('done')
