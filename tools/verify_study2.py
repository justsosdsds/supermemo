"""Locate the real Learn menu command, fire it, grade the element and capture
both dialogs of the study step."""
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
    b = ctypes.create_unicode_buffer(2048)
    user32.GetWindowTextW(h, b, 2048)
    return b.value


def mtext(hm, i):
    b = ctypes.create_unicode_buffer(256)
    user32.GetMenuStringW(hm, i, b, 256, 0x400)
    return b.value


def dump_menu(hm, depth=0, prefix=''):
    rows = []
    for i in range(user32.GetMenuItemCount(hm)):
        t = mtext(hm, i)
        cid = user32.GetMenuItemID(hm, i)
        sub = user32.GetSubMenu(hm, i)
        rows.append((depth, t, cid, bool(sub)))
        if sub and depth < 1:
            rows.extend(dump_menu(sub, depth + 1, prefix + t))
    return rows


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
    print('no main window')
    p.terminate()
    raise SystemExit(1)
h = main[0][0]
hm = user32.GetMenu(h)
rows = dump_menu(hm)
print('=== menu (depth<=1, Learn/Search/View report) ===')
for d, t, cid, sub in rows:
    clean = t.replace('&', '')
    if any(k in clean.lower() for k in ('learn', 'search', 'report')):
        print('%s%-40r id=%-5d submenu=%s' % ('  ' * d, clean, cid, sub))

cand = [cid for d, t, cid, sub in rows if not sub and cid > 0 and t.replace('&', '').strip().lower().startswith('learn')]
print('candidate ids:', cand)

for cid in cand:
    user32.PostMessageW(h, 0x0111, cid, 0)
    time.sleep(2.5)
    dl = [x for x in wins() if ('Grade' in x[2] or 'Study' in x[2] or 'element' in x[2].lower())]
    print('after id', cid, '->', [(c, t[:60]) for _, c, t in dl][:5])
    if dl:
        break

d = [x for x in wins() if 'Grade' in x[2] or 'Study' in x[2] or 'engine' in x[2]]
print('study dialogs:', d)
shot('study_step_1')
if d:
    dlg = d[0][0]
    kids = [(ch, cls_of(ch), text_of(ch)) for ch in children(dlg)]
    print('children:', kids[:6])
    edit = [ch for ch, c, t in kids if c == 'TEdit']
    if edit:
        user32.SetWindowTextW(edit[0], '4')
        time.sleep(0.3)
    user32.SetForegroundWindow(dlg)
    time.sleep(0.3)
    user32.keybd_event(0x0D, 0, 0, 0)
    user32.keybd_event(0x0D, 0, 2, 0)
    time.sleep(3)
    shot('study_step_2')
    res = [x for x in wins() if 'Study step' in x[2]]
    print('result dialog:', [(c, t[:100]) for _, c, t in res])
    if res:
        kids2 = [(ch, cls_of(ch), text_of(ch)) for ch in children(res[0][0])]
        for k in kids2:
            if k[2] and len(k[2]) > 10:
                print('   text:', k[2][:400])
time.sleep(1)
p.terminate()
print('done')
