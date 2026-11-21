"""Look at the element window's File menu: open it with Alt+F and screenshot so
the item positions become visible (the menu is owner-drawn, so text cannot be
read through GetMenuString)."""
import ctypes, ctypes.wintypes as w, subprocess, time

user32 = ctypes.WinDLL('user32', use_last_error=True)
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


def shot(name):
    subprocess.run(['powershell', '-NoProfile', '-Command',
                    SHOT.replace('{name}', name)], check=False)


def tap(vk):
    user32.keybd_event(vk, 0, 0, 0)
    time.sleep(0.08)
    user32.keybd_event(vk, 0, 2, 0)
    time.sleep(0.12)


p = subprocess.Popen([r'F:\Projects\逆向\run\SuperMemo19.exe'],
                     cwd=r'F:\Projects\逆向\run')
for _ in range(12):
    time.sleep(1.4)
    boxes = [x for x in wins() if x[1] == 'TMsgDialog']
    if boxes:
        user32.SetForegroundWindow(boxes[0][0])
        time.sleep(0.3)
        tap(0x0D)
        continue
    el = [x for x in wins() if x[1] == 'TElWind']
    if el:
        break

el = [x for x in wins() if x[1] == 'TElWind']
if not el:
    print('no element window')
    p.terminate()
    raise SystemExit(1)
h = el[0][0]
user32.SetForegroundWindow(h)
time.sleep(0.6)
tap(0x12)   # Alt
time.sleep(0.2)
tap(0x46)   # F
time.sleep(1.2)
shot('elwind_file_menu')
print('menu opened, screenshot saved')

# walk down and capture each highlighted item
for i in range(1, 10):
    tap(0x28)   # Down
    time.sleep(0.5)
    shot('elwind_file_menu_%d' % i)
print('captured %d positions' % 9)
tap(0x1B)
time.sleep(0.5)
p.terminate()
print('done')
