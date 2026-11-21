import ctypes, ctypes.wintypes as w, subprocess, time, sys

user32 = ctypes.WinDLL('user32', use_last_error=True)
SHOT_PS = (
    "Add-Type -AssemblyName System.Windows.Forms,System.Drawing;"
    "$b=[System.Windows.Forms.SystemInformation]::VirtualScreen;"
    "$bmp=New-Object System.Drawing.Bitmap $b.Width,$b.Height;"
    "$g=[System.Drawing.Graphics]::FromImage($bmp);"
    "$g.CopyFromScreen($b.Location,[System.Drawing.Point]::Empty,$b.Size);"
    "$bmp.Save('{path}',[System.Drawing.Imaging.ImageFormat]::Png)"
)


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


def shot(path):
    subprocess.run(['powershell', '-NoProfile', '-Command',
                    SHOT_PS.replace('{path}', path.replace('\\', '\\\\'))], check=False)


def main():
    target = sys.argv[1] if len(sys.argv) > 1 else 'Contents'
    out = sys.argv[2] if len(sys.argv) > 2 else r'F:\Projects\逆向\work\contents_tree.png'
    p = subprocess.Popen([r'F:\Projects\逆向\sm19src\sm19.exe'],
                         cwd=r'F:\Projects\逆向\sm19src')
    time.sleep(9)
    main_w = [x[0] for x in wins() if x[2] == 'SuperMemo']
    if not main_w:
        p.terminate()
        print('no main window')
        return 1
    h = main_w[0]
    rows = []
    walk(user32.GetMenu(h), rows)
    cands = [(t, c) for t, c, s in rows if not s and c > 0 and target.lower() in t.strip().lower()]
    print('candidates for %s: %s' % (target, cands))
    if not cands:
        p.terminate()
        return 1
    user32.PostMessageW(h, 0x0111, cands[0][1], 0)
    time.sleep(3)
    print('windows now:', [x[2] for x in wins() if x[2]][:8])
    shot(out)
    print('shot:', out)
    time.sleep(1)
    p.terminate()
    return 0


if __name__ == '__main__':
    sys.exit(main())
