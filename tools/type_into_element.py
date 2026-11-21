"""Create an element and type real text into it, then diff the files.

Tries, in order: click the element content area (TScrollBox), F9 edit mode,
and typing. Reports which text pool / component records changed."""
import ctypes, ctypes.wintypes as w, subprocess, time, os, sys, struct

user32 = ctypes.WinDLL('user32', use_last_error=True)
C = r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19'
ULONG_PTR = ctypes.c_ulonglong


class KEYBDINPUT(ctypes.Structure):
    _fields_ = [('wVk', w.WORD), ('wScan', w.WORD), ('dwFlags', w.DWORD),
                ('time', w.DWORD), ('dwExtraInfo', ULONG_PTR)]


class _U(ctypes.Union):
    _fields_ = [('ki', KEYBDINPUT)]


class INPUT(ctypes.Structure):
    _anonymous_ = ('u',)
    _fields_ = [('type', w.DWORD), ('u', _U)]


def type_text(text):
    for ch in text:
        for flags in (4, 4 | 2):
            inp = INPUT(type=1, u=_U(ki=KEYBDINPUT(0, ord(ch), flags, 0, 0)))
            user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))
            time.sleep(0.012)
        time.sleep(0.01)


def key(vk, up=False):
    inp = INPUT(type=1, u=_U(ki=KEYBDINPUT(vk, 0, 2 if up else 0, 0, 0)))
    user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))
    time.sleep(0.08)


def tap(vk):
    key(vk)
    key(vk, up=True)


def click(x, y):
    user32.SetCursorPos(x, y)
    time.sleep(0.2)
    user32.mouse_event(0x0002, 0, 0, 0, 0)
    time.sleep(0.06)
    user32.mouse_event(0x0004, 0, 0, 0, 0)
    time.sleep(0.4)


def rect(h):
    r = w.RECT()
    user32.GetWindowRect(h, ctypes.byref(r))
    return r.left, r.top, r.right - r.left, r.bottom - r.top


def all_windows():
    out = []

    def cb(h, _):
        b = ctypes.create_unicode_buffer(256)
        user32.GetClassNameW(h, b, 256)
        t = ctypes.create_unicode_buffer(512)
        user32.GetWindowTextW(h, t, 512)
        out.append((h, b.value, t.value, bool(user32.IsWindowVisible(h))))
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
    b = ctypes.create_unicode_buffer(512)
    user32.GetWindowTextW(h, b, 512)
    return b.value


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


def main():
    before = snap()
    p = subprocess.Popen([r'F:\Projects\逆向\run\SuperMemo19.exe'], cwd=r'F:\Projects\逆向\run')
    el = None
    for attempt in range(16):
        time.sleep(1.5)
        wins = all_windows()
        boxes = [x for x in wins if x[1] == 'TMsgDialog' and x[3]]
        if boxes:
            user32.SetForegroundWindow(boxes[0][0])
            time.sleep(0.3)
            tap(0x0D)
            time.sleep(1.0)
            continue
        els = [x for x in wins if x[1] == 'TElWind' and x[3]]
        if els:
            el = els
            break
    if not el:
        print('no element window')
        p.terminate()
        return 1
    h = el[0][0]
    user32.SetForegroundWindow(h)
    time.sleep(0.6)

    # click "Add new" to create a fresh element we can write into
    for ch in children(h):
        if cls_of(ch) == 'TBitBtn' and 'add' in text_of(ch).lower():
            user32.SendMessageW(ch, 0x00F5, 0, 0)
            print('clicked Add new')
            break
    time.sleep(2.5)

    # find the scroll box (content area) and click inside it
    box = None
    for ch in children(h):
        if cls_of(ch) == 'TScrollBox':
            box = ch
            break
    if box:
        x, y, wd, ht = rect(box)
        print('scroll box', (x, y, wd, ht))
        cx, cy = x + wd // 2, y + ht // 3
        click(cx, cy)
        time.sleep(0.6)
        # try entering edit mode then typing
        for mode in ('direct', 'f9', 'enter'):
            if mode == 'f9':
                tap(0x78)      # F9
                time.sleep(0.6)
            elif mode == 'enter':
                click(cx, cy)
                time.sleep(0.3)
                tap(0x0D)
                time.sleep(0.4)
            type_text('Capital of France is Paris')
            time.sleep(0.8)
            tap(0x1B)          # Esc to commit
            time.sleep(0.8)
            print('typed in mode', mode)

    # save
    user32.keybd_event(0x11, 0, 0, 0)
    user32.keybd_event(0x53, 0, 0, 0)
    user32.keybd_event(0x53, 0, 2, 0)
    user32.keybd_event(0x11, 0, 2, 0)
    time.sleep(3)
    user32.PostMessageW(h, 0x0010, 0, 0)
    time.sleep(3)
    p.terminate()

    after = snap()
    print('\nchanged:')
    for k in sorted(set(before) | set(after)):
        if before.get(k) != after.get(k):
            print('  %-42s %s -> %s' % (k, before.get(k), after.get(k)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
