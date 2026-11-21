"""Enumerate the live window/control tree of a running process (Win32 API),
so runtime-created controls can be compared with the reconstructed DFM tree."""
import ctypes, ctypes.wintypes as w, json, sys, time, subprocess, os

user32 = ctypes.WinDLL('user32', use_last_error=True)
EnumWindows = user32.EnumWindows
EnumChildWindows = user32.EnumChildWindows
GetWindowTextW = user32.GetWindowTextW
GetClassNameW = user32.GetClassNameW
GetWindowThreadProcessId = user32.GetWindowThreadProcessId
IsWindowVisible = user32.IsWindowVisible
GetWindowRect = user32.GetWindowRect

WNDENUMPROC = ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)


class RECT(ctypes.Structure):
    _fields_ = [('left', ctypes.c_long), ('top', ctypes.c_long),
                ('right', ctypes.c_long), ('bottom', ctypes.c_long)]


def text(h):
    buf = ctypes.create_unicode_buffer(512)
    GetWindowTextW(h, buf, 512)
    return buf.value


def cls(h):
    buf = ctypes.create_unicode_buffer(256)
    GetClassNameW(h, buf, 256)
    return buf.value


def rect(h):
    r = RECT()
    GetWindowRect(h, ctypes.byref(r))
    return (r.left, r.top, r.right - r.left, r.bottom - r.top)


def children(h, depth=0, out=None):
    if out is None:
        out = []
    items = []

    def cb(ch, _):
        items.append(ch)
        return True
    EnumChildWindows(h, WNDENUMPROC(cb), 0)
    # EnumChildWindows is recursive; keep only direct children by comparing parents
    direct = [c for c in items if user32.GetParent(c) == h]
    for c in direct:
        rec = dict(cls=cls(c), text=text(c), rect=rect(c),
                   visible=bool(IsWindowVisible(c)), children=[])
        rec['children'] = children(c, depth + 1)
        out.append(rec)
    return out


def main(pid):
    found = []

    def cb(h, _):
        p = w.DWORD()
        GetWindowThreadProcessId(h, ctypes.byref(p))
        if p.value == pid:
            found.append(h)
        return True
    EnumWindows(WNDENUMPROC(cb), 0)
    tree = []
    for h in found:
        tree.append(dict(hwnd=h, cls=cls(h), text=text(h), rect=rect(h),
                         visible=bool(IsWindowVisible(h)),
                         children=children(h)))
    return tree


if __name__ == '__main__':
    exe = sys.argv[1]
    wait = int(sys.argv[2]) if len(sys.argv) > 2 else 10
    outp = sys.argv[3] if len(sys.argv) > 3 else 'tree.json'
    p = subprocess.Popen([exe], cwd=os.path.dirname(exe))
    time.sleep(wait)
    t = main(p.pid)
    json.dump(t, open(outp, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('process', p.pid, 'windows:', len(t))
    for wnd in t:
        n = count = 0

        def cnt(node):
            global count
            count += 1
            for c in node['children']:
                cnt(c)
        cnt(wnd)
        print('  %-28s %-40s rect=%s visible=%s nodes=%d' % (
            wnd['cls'], wnd['text'][:40], wnd['rect'], wnd['visible'], count))
    p.terminate()
    print('saved', outp)
