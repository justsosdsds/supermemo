"""Launch the original program on the imported collection and screenshot the
error dialog so the message text can be read."""
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


p = subprocess.Popen([r'F:\Projects\逆向\run\SuperMemo19.exe'],
                     cwd=r'F:\Projects\逆向\run')
seen = set()
shot_index = 0
for i in range(12):
    time.sleep(1.4)
    boxes = [x for x in wins() if x[1] == 'TMsgDialog']
    if boxes:
        shot_index += 1
        name = 'import_error_%d' % shot_index
        shot(name)
        print('captured dialog as', name)
        user32.SetForegroundWindow(boxes[0][0])
        time.sleep(0.3)
        user32.keybd_event(0x0D, 0, 0, 0)
        user32.keybd_event(0x0D, 0, 2, 0)
        time.sleep(1.2)
    else:
        el = [x for x in wins() if x[1] == 'TElWind']
        if el:
            print('element window reached after %d dialogs' % shot_index)
            shot('import_ok')
            break
time.sleep(0.5)
p.terminate()
print('done, dialogs:', shot_index)
