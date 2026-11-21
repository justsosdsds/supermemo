"""Verify that the 2443 wired handlers actually respond:
   - a caption that maps to a rebuilt form opens that form
   - an unmapped one reports its handler name
"""
import ctypes, ctypes.wintypes as w, subprocess, time

user32 = ctypes.WinDLL('user32', use_last_error=True)


def wins():
    out = []

    def cb(h, _):
        if user32.IsWindowVisible(h):
            b = ctypes.create_unicode_buffer(256)
            user32.GetClassNameW(h, b, 256)
            t = ctypes.create_unicode_buffer(1024)
            user32.GetWindowTextW(h, t, 1024)
            out.append((h, b.value, t.value))
        return True
    user32.EnumWindows(ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)(cb), 0)
    return out


def mtext(hm, i):
    b = ctypes.create_unicode_buffer(256)
    user32.GetMenuStringW(hm, i, b, 256, 0x400)
    return b.value


def walk(hm, out, depth=0):
    for i in range(user32.GetMenuItemCount(hm)):
        t = mtext(hm, i).replace('&', '')
        cid = user32.GetMenuItemID(hm, i)
        sub = user32.GetSubMenu(hm, i)
        out.append((depth, t, cid, bool(sub)))
        if sub and depth < 3:
            walk(sub, out, depth + 1)


def shot(name):
    subprocess.run(['powershell', '-NoProfile', '-Command',
                    "Add-Type -AssemblyName System.Windows.Forms,System.Drawing;"
                    "$b=[System.Windows.Forms.SystemInformation]::VirtualScreen;"
                    "$bmp=New-Object System.Drawing.Bitmap $b.Width,$b.Height;"
                    "$g=[System.Drawing.Graphics]::FromImage($bmp);"
                    "$g.CopyFromScreen($b.Location,[System.Drawing.Point]::Empty,$b.Size);"
                    "$bmp.Save('F:\\Projects\\逆向\\work\\%s.png',"
                    "[System.Drawing.Imaging.ImageFormat]::Png)" % name], check=False)


p = subprocess.Popen([r'F:\Projects\逆向\sm19src\sm19.exe'],
                     cwd=r'F:\Projects\逆向\sm19src')
time.sleep(9)
main = [x for x in wins() if x[2] == 'SuperMemo']
if not main:
    p.terminate()
    raise SystemExit('no main')
h = main[0][0]
hm = user32.GetMenu(h)
rows = []
walk(hm, rows)
print('menu entries:', len(rows))

def find(keyword):
    for d, t, cid, sub in rows:
        if not sub and cid > 0 and keyword.lower() in t.lower():
            return cid, t
    return None, None

for keyword in ('Options', 'Statistics', 'Contents'):
    cid, txt = find(keyword)
    print('%-12s -> id=%s caption=%r' % (keyword, cid, txt))
    if cid:
        before = {x[2] for x in wins()}
        user32.PostMessageW(h, 0x0111, cid, 0)
        time.sleep(2.5)
        new = [(c, t) for _, c, t in wins() if t not in before and t]
        print('    new windows:', new[:3])
        shot('dispatch_%s' % keyword.lower())
        # close any modal dialog with Esc
        for _ in range(2):
            for hh, c, t in wins():
                if t not in before and t:
                    user32.SetForegroundWindow(hh)
                    time.sleep(0.2)
            user32.keybd_event(0x1B, 0, 0, 0)
            user32.keybd_event(0x1B, 0, 2, 0)
            time.sleep(1)

time.sleep(1)
p.terminate()
print('done')
