"""Feed real content into SuperMemo 19 through its Q&A text importer.

Path: File -> Import -> Q&A text  (handler MIMCTTextClick)
      -> TImportTXTDlg: set file name, tick "Decode UTF-8", press OK.
This is far more reliable than typing into SM's custom-drawn editor.
"""
import ctypes, ctypes.wintypes as w, subprocess, time, os, sys

user32 = ctypes.WinDLL('user32', use_last_error=True)
LRESULT = ctypes.c_longlong

QAFILE = r'F:\SMImport\sample_qa.txt'


def enum_windows():
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


def press_enter():
    user32.keybd_event(0x0D, 0, 0, 0)
    user32.keybd_event(0x0D, 0, 2, 0)


def main():
    os.makedirs(os.path.dirname(QAFILE), exist_ok=True)
    with open(QAFILE, 'w', encoding='utf-8', newline='\r\n') as f:
        f.write('Q: What is the capital of France?\n')
        f.write('A: Paris\n\n')
        f.write('Q: 2 + 2 equals?\n')
        f.write('A: 4\n\n')
        f.write('Q: What does SM stand for?\n')
        f.write('A: SuperMemo\n')
    print('wrote', QAFILE)

    run_dir = r'F:\Projects\逆向\run'
    p = subprocess.Popen([os.path.join(run_dir, 'SuperMemo19.exe')], cwd=run_dir)

    # wait for the element window, dismissing the repair notice with Enter
    main_hwnd = None
    for _ in range(15):
        time.sleep(2)
        wins = enum_windows()
        classes = [c for _, c, _ in wins]
        if 'TMsgDialog' in classes:
            for h, c, t in wins:
                if c == 'TMsgDialog':
                    user32.SetForegroundWindow(h)
                    time.sleep(0.3)
            press_enter()
            time.sleep(2)
        el = [h for h, c, t in wins if c == 'TElWind']
        if el:
            main_hwnd = el[0]
            break
    if not main_hwnd:
        print('no element window')
        p.terminate()
        return 1
    print('element window', main_hwnd)

    # find whichever top-level window actually owns a native menu
    target = None
    for h, c, t in enum_windows():
        if user32.GetMenu(h):
            target = h
            print('menu window:', c, repr(t), h)
            break
    print('menu owner:', target)
    if not target:
        p.terminate()
        return 1

    hmenu = user32.GetMenu(target)
    hit = find_cmd(hmenu, 'Q&A text')
    print('Q&A text command:', hit)
    if not hit:
        p.terminate()
        return 1
    cid, txt = hit
    user32.PostMessageW(target, 0x0111, cid, 0)
    time.sleep(3)

    dlg = [h for h, c, t in enum_windows() if c == 'TImportTXTDlg']
    print('import dialog:', dlg)
    if not dlg:
        print('dialog did not open; windows:', [c for _, c, _ in enum_windows()][:12])
        p.terminate()
        return 1

    d = dlg[0]
    kids = children(d)
    edit = ok_btn = utf = None
    for ch in kids:
        c = cls_of(ch)
        if c == 'TEdit':
            edit = ch
        elif c == 'TButton' and 'OK' in text_of(ch):
            ok_btn = ch
        elif c == 'TCheckBox' and 'UTF' in text_of(ch):
            utf = ch
    print('edit=%s ok=%s utf=%s' % (edit, ok_btn, utf))

    if edit:
        user32.SetWindowTextW(edit, QAFILE)
        time.sleep(0.4)
    if utf:
        state = user32.SendMessageW(utf, 0x00F0, 0, 0)   # BM_GETCHECK
        if state != 1:
            user32.SendMessageW(utf, 0x00F5, 1, 0)       # BM_SETCHECK
        time.sleep(0.3)
    if ok_btn:
        user32.SendMessageW(ok_btn, 0x00F5, 0, 0)        # BM_CLICK
    time.sleep(5)

    # dismiss any follow-up message boxes
    for _ in range(4):
        boxes = [h for h, c, t in enum_windows() if c in ('TMsgDialog', 'TInformationDlg', 'TDialog')]
        if not boxes:
            break
        print('dismissing', [(cls_of(h), text_of(h)) for h in boxes])
        user32.SetForegroundWindow(boxes[0])
        time.sleep(0.4)
        press_enter()
        time.sleep(2)

    # save and close
    user32.SetForegroundWindow(main_hwnd)
    time.sleep(0.5)
    user32.keybd_event(0x11, 0, 0, 0)
    user32.keybd_event(0x53, 0, 0, 0)
    user32.keybd_event(0x53, 0, 2, 0)
    user32.keybd_event(0x11, 0, 2, 0)
    time.sleep(3)
    user32.PostMessageW(main_hwnd, 0x0010, 0, 0)
    time.sleep(3)
    p.terminate()
    print('done')
    return 0


if __name__ == '__main__':
    sys.exit(main())
