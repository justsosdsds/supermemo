"""Verify stage 1: Browser/Statistics show real data, Options persists to INI."""
import ctypes, ctypes.wintypes as w, subprocess, time, os

user32 = ctypes.WinDLL('user32', use_last_error=True)
INI = r'F:\Projects\逆向\sm19src\sm19settings.ini'


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


def kids(h):
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
    b = ctypes.create_unicode_buffer(1024)
    user32.GetWindowTextW(h, b, 1024)
    return b.value


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
    ps = ("Add-Type -AssemblyName System.Windows.Forms,System.Drawing;"
          "$b=[System.Windows.Forms.SystemInformation]::VirtualScreen;"
          "$bmp=New-Object System.Drawing.Bitmap $b.Width,$b.Height;"
          "$g=[System.Drawing.Graphics]::FromImage($bmp);"
          "$g.CopyFromScreen($b.Location,[System.Drawing.Point]::Empty,$b.Size);"
          "$bmp.Save('F:\\Projects\\逆向\\work\\" + name +
          ".png',[System.Drawing.Imaging.ImageFormat]::Png)")
    subprocess.run(['powershell', '-NoProfile', '-Command', ps], check=False)


if os.path.exists(INI):
    os.remove(INI)

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

# --- Browser: should show a filled grid ---
cid = [c for t, c, s in rows if not s and c > 0 and 'browser' in t.lower()]
if cid:
    user32.PostMessageW(h, 0x0111, cid[0], 0)
    time.sleep(3)
    shot('stage1_browser')
    print('browser opened')
    user32.keybd_event(0x1B, 0, 0, 0)
    user32.keybd_event(0x1B, 0, 2, 0)
    time.sleep(1.5)

# --- Statistics ---
cid = [c for t, c, s in rows if not s and c > 0 and 'statistic' in t.lower()]
if cid:
    user32.PostMessageW(h, 0x0111, cid[0], 0)
    time.sleep(3)
    shot('stage1_stats')
    print('statistics opened')
    user32.keybd_event(0x1B, 0, 0, 0)
    user32.keybd_event(0x1B, 0, 2, 0)
    time.sleep(1.5)

# --- Options: press OK and check the INI appears ---
cid = [c for t, c, s in rows if not s and c > 0 and 'options' in t.lower()]
if cid:
    user32.PostMessageW(h, 0x0111, cid[0], 0)
    time.sleep(3)
    dlg = [x[0] for x in wins() if x[2] == 'Options']
    print('options dialog:', dlg)
    if dlg:
        okbtn = None
        for ch in kids(dlg[0]):
            if cls_of(ch) in ('TButton', 'TBitBtn') and text_of(ch).replace('&', '').strip().upper() == 'OK':
                okbtn = ch
                break
        print('OK button:', okbtn)
        if okbtn:
            user32.SendMessageW(okbtn, 0x00F5, 0, 0)   # BM_CLICK
            time.sleep(3)
    shot('stage1_options')

time.sleep(1)
p.terminate()
print('ini exists:', os.path.exists(INI))
if os.path.exists(INI):
    txt = open(INI, encoding='utf-8', errors='replace').read()
    print('ini lines:', len(txt.splitlines()))
    print(txt[:500])
