"""Show the hidden TSMMain (which owns the full menu), then drive
File -> Import -> Q&A text to feed real cards into the collection."""
import ctypes, ctypes.wintypes as w, subprocess, time, os, sys

user32 = ctypes.WinDLL('user32', use_last_error=True)
QAFILE = r'F:\SMImport\sample_qa.txt'


def all_windows():
    out = []

    def cb(h, _):
        b = ctypes.create_unicode_buffer(256)
        user32.GetClassNameW(h, b, 256)
        t = ctypes.create_unicode_buffer(512)
        user32.GetWindowTextW(h, t, 512)
        out.append((h, b.value, t.value, bool(user32.IsWindowVisible(h)), user32.GetMenu(h)))
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


def menu_text(hmenu, idx):
    b = ctypes.create_unicode_buffer(256)
    user32.GetMenuStringW(hmenu, idx, b, 256, 0x00000400)
    return b.value


def find_cmd(hmenu, wanted, depth=0):
    n = user32.GetMenuItemCount(hmenu)
    for i in range(n):
        txt = menu_text(hmenu, i)
        clean = txt.replace('&', '').replace('\t', ' ').strip().lower()
        if clean.startswith(wanted.lower()):
            sub = user32.GetSubMenu(hmenu, i)
            if sub:
                return find_cmd(sub, wanted, depth + 1) if depth < 2 else None
            cid = user32.GetMenuItemID(hmenu, i)
            if cid > 0:
                return cid, txt
        sub = user32.GetSubMenu(hmenu, i)
        if sub and depth < 2:
            r = find_cmd(sub, wanted, depth + 1)
            if r:
                return r
    return None


def enter():
    user32.keybd_event(0x0D, 0, 0, 0)
    user32.keybd_event(0x0D, 0, 2, 0)


def main():
    os.makedirs(os.path.dirname(QAFILE), exist_ok=True)
    with open(QAFILE, 'w', encoding='utf-8', newline='\r\n') as f:
        f.write('Q: What is the capital of France?\nA: Paris\n\n')
        f.write('Q: 2 + 2 equals?\nA: 4\n\n')
        f.write('Q: What does SM stand for?\nA: SuperMemo\n')
    print('qa file:', QAFILE)

    run_dir = r'F:\Projects\逆向\run'
    p = subprocess.Popen([os.path.join(run_dir, 'SuperMemo19.exe')], cwd=run_dir)
    time.sleep(12)

    for _ in range(4):
        boxes = [x for x in all_windows() if x[1] == 'TMsgDialog' and x[3]]
        if not boxes:
            break
        user32.SetForegroundWindow(boxes[0][0])
        time.sleep(0.3)
        enter()
        time.sleep(2)

    smmain = [x for x in all_windows() if x[1] == 'TSMMain']
    if not smmain:
        print('TSMMain not found')
        p.terminate()
        return 1
    h = smmain[0][0]
    print('TSMMain:', h, 'visible=', smmain[0][3])

    user32.ShowWindow(h, 5)          # SW_SHOW
    user32.SetForegroundWindow(h)
    time.sleep(1.5)
    hmenu = user32.GetMenu(h)
    print('menu after show:', hmenu, 'items:', user32.GetMenuItemCount(hmenu) if hmenu else -1)
    if not hmenu:
        p.terminate()
        return 1

    print('top-level menus:', [menu_text(hmenu, i) for i in range(user32.GetMenuItemCount(hmenu))])
    hit = find_cmd(hmenu, 'Q&A text')
    print('Q&A text command:', hit)
    if not hit:
        p.terminate()
        return 1
    cid, txt = hit
    user32.PostMessageW(h, 0x0111, cid, 0)
    time.sleep(3)

    dlg = [x for x in all_windows() if x[1] == 'TImportTXTDlg']
    print('dialog:', dlg)
    if not dlg:
        print('no dialog; windows:', [(c, t) for _, c, t, v, m in all_windows() if v][:10])
        p.terminate()
        return 1

    d = dlg[0][0]
    edit = ok = utf = None
    for ch in children(d):
        c = cls_of(ch)
        if c == 'TEdit':
            edit = ch
        elif c == 'TButton' and 'OK' in text_of(ch):
            ok = ch
        elif c == 'TCheckBox' and 'UTF' in text_of(ch):
            utf = ch
    print('edit=%s ok=%s utf=%s' % (edit, ok, utf))
    if edit:
        user32.SetWindowTextW(edit, QAFILE)
    if utf:
        user32.SendMessageW(utf, 0x00F5, 1, 0)   # BM_SETCHECK
    time.sleep(0.5)
    if ok:
        user32.SendMessageW(ok, 0x00F5, 0, 0)    # BM_CLICK
    time.sleep(6)

    for _ in range(5):
        boxes = [x for x in all_windows() if x[1] in ('TMsgDialog',) and x[3]]
        if not boxes:
            break
        print('dialog:', cls_of(boxes[0][0]), repr(text_of(boxes[0][0])))
        user32.SetForegroundWindow(boxes[0][0])
        time.sleep(0.3)
        enter()
        time.sleep(2)

    user32.SetForegroundWindow(h)
    time.sleep(0.5)
    for vk in (0x11, 0x53):
        user32.keybd_event(vk, 0, 0, 0)
    for vk in (0x53, 0x11):
        user32.keybd_event(vk, 0, 2, 0)
    time.sleep(3)
    user32.PostMessageW(h, 0x0010, 0, 0)
    time.sleep(3)
    p.terminate()
    print('done')
    return 0


if __name__ == '__main__':
    sys.exit(main())
