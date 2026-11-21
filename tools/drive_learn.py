"""Drive the original program's Learn button and grade a few cards so its
algorithm tables (FirstInterval.dat, Recall.dat) get real data."""
import ctypes, ctypes.wintypes as w, subprocess, time, os

user32 = ctypes.WinDLL('user32', use_last_error=True)
C = r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19'
SHOT = (
    "Add-Type -AssemblyName System.Windows.Forms,System.Drawing;"
    "$b=[System.Windows.Forms.SystemInformation]::VirtualScreen;"
    "$bmp=New-Object System.Drawing.Bitmap $b.Width,$b.Height;"
    "$g=[System.Drawing.Graphics]::FromImage($bmp);"
    "$g.CopyFromScreen($b.Location,[System.Drawing.Point]::Empty,$b.Size);"
    "$bmp.Save('F:\\Projects\\逆向\\work\\{name}.png',"
    "[System.Drawing.Imaging.ImageFormat]::Png)"
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
    b = ctypes.create_unicode_buffer(512)
    user32.GetWindowTextW(h, b, 512)
    return b.value


def shot(name):
    subprocess.run(['powershell', '-NoProfile', '-Command',
                    SHOT.replace('{name}', name)], check=False)


def tap(vk):
    user32.keybd_event(vk, 0, 0, 0)
    time.sleep(0.07)
    user32.keybd_event(vk, 0, 2, 0)
    time.sleep(0.12)


def snap():
    out = {}
    for root, dirs, files in os.walk(C):
        for f in files:
            p = os.path.join(root, f)
            try:
                out[os.path.relpath(p, C)] = os.path.getsize(p)
            except OSError:
                pass
    return out


before = snap()
p = subprocess.Popen([r'F:\Projects\逆向\run\SuperMemo19.exe'],
                     cwd=r'F:\Projects\逆向\run')
el = None
for _ in range(16):
    time.sleep(1.3)
    boxes = [x for x in wins() if x[1] == 'TMsgDialog']
    if boxes:
        user32.SetForegroundWindow(boxes[0][0])
        time.sleep(0.3)
        tap(0x0D)
        continue
    els = [x for x in wins() if x[1] == 'TElWind']
    if els:
        el = els[0]
        break
if not el:
    print('no element window')
    p.terminate()
    raise SystemExit(1)

h = el[0]
user32.SetForegroundWindow(h)
time.sleep(0.8)
print('element window:', el[2])

# click the Learn button
learn = None
for ch in kids(h):
    if cls_of(ch) == 'TBitBtn' and 'learn' in text_of(ch).lower():
        learn = ch
        break
print('learn button:', learn)
if learn:
    user32.SendMessageW(learn, 0x00F5, 0, 0)
    time.sleep(3)
    shot('learn_state')
    print('after Learn, windows:', [t for _, c, t in wins()
                                if t and t not in ('SuperMemo', 'Element Window')][:5])

    # try to grade: space (show answer) then a number key
    for attempt in range(8):
        user32.SetForegroundWindow(h)
        time.sleep(0.6)
        tap(0x20)   # space: show answer
        time.sleep(1.4)
        grade_key = 0x35 if attempt % 3 == 0 else 0x31   # alternate 5 / 1
        tap(grade_key)
        time.sleep(1.4)
        print('graded attempt', attempt + 1, 'key', hex(grade_key))
    shot('learn_after_grades')

user32.keybd_event(0x11, 0, 0, 0)
tap(0x53)
user32.keybd_event(0x11, 0, 2, 0)
time.sleep(3)
user32.PostMessageW(h, 0x0010, 0, 0)
time.sleep(3)
p.terminate()

after = snap()
print('\nchanged files:')
for k in sorted(set(before) | set(after)):
    if before.get(k) != after.get(k):
        print('  %-42s %s -> %s' % (k, before.get(k), after.get(k)))
