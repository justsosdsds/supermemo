"""Verify the full study-step chain in the rebuilt app:
   Learn menu -> element text shown -> grade entered -> interval computed."""

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
    b = ctypes.create_unicode_buffer(1024)
    user32.GetWindowTextW(h, b, 1024)
    return b.value


def menu_text(hm, i):
    b = ctypes.create_unicode_buffer(256)
    user32.GetMenuStringW(hm, i, b, 256, 0x400)
    return b.value


def find_cmd(hm, want, depth=0):
    for i in range(user32.GetMenuItemCount(hm)):
        txt = menu_text(hm, i).replace('&', '').split('\t')[0].strip().lower()
        sub = user32.GetSubMenu(hm, i)
        if txt.startswith(want.lower()):
            if sub:
                return find_cmd(sub, want, depth + 1) if depth < 2 else None
            cid = user32.GetMenuItemID(hm, i)
            if cid > 0:
                return cid
        if sub and depth < 2:
            r = find_cmd(sub, want, depth + 1)
            if r:
                return r
    return None


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
print('main:', main[:1])
if not main:
    p.terminate()
    raise SystemExit(1)
h = main[0][0]
hm = user32.GetMenu(h)

cid = find_cmd(hm, 'Learn')
print('Learn command id:', cid)
user32.PostMessageW(h, 0x0111, cid, 0)
time.sleep(3)

dlgs = [x for x in wins() if x[1] not in ('Window',) and x[2].startswith(('Grade', 'Study'))]
print('dialogs:', [(c, t[:50]) for _, c, t in dlgs])
shot('study_step_1')

if dlgs:
    d = dlgs[0][0]
    kids = [(ch, cls_of(ch), text_of(ch)) for ch in children(d)]
    print('dialog children:', kids[:8])
    edit = [ch for ch, c, t in kids if c == 'TEdit']
    print('edit:', edit)
    if edit:
        user32.SetWindowTextW(edit[0], '4')
        time.sleep(0.4)
    user32.SetForegroundWindow(d)
    time.sleep(0.3)
    user32.keybd_event(0x0D, 0, 0, 0)
    user32.keybd_event(0x0D, 0, 2, 0)
    time.sleep(3)

after = [(c, t[:90]) for _, c, t in wins() if c in ('TMsgDialog', 'Window') and t]
print('after grading:', after[:6])
shot('study_step_2')
time.sleep(1)
p.terminate()
print('done')
