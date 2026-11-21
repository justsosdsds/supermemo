"""Generate an Object Pascal (LCL/FPC) skeleton project from parsed DFM trees."""
import json, glob, os, re, collections, io

SRC = r'F:\Projects\逆向\work\dfm_json'
OUT = r'F:\Projects\逆向\sm19src'
UNITS = os.path.join(OUT, 'units')

# --- class -> LCL unit ------------------------------------------------------
CLASS_UNIT = {
    'TForm': 'Forms', 'TApplication': 'Forms',
    'TControl': 'Controls', 'TWinControl': 'Controls',
    'TButton': 'StdCtrls', 'TEdit': 'StdCtrls', 'TLabel': 'StdCtrls',
    'TCheckBox': 'StdCtrls', 'TRadioButton': 'StdCtrls', 'TListBox': 'StdCtrls',
    'TComboBox': 'StdCtrls', 'TMemo': 'StdCtrls', 'TGroupBox': 'StdCtrls',
    'TStaticText': 'StdCtrls', 'TScrollBar': 'StdCtrls',
    'TCheckListBox': 'CheckLst', 'TMaskEdit': 'MaskEdit',
    'TPanel': 'ExtCtrls', 'TBevel': 'ExtCtrls', 'TPaintBox': 'ExtCtrls',
    'TImage': 'ExtCtrls', 'TTimer': 'ExtCtrls', 'TRadioGroup': 'ExtCtrls',
    'TSplitter': 'ExtCtrls', 'TScrollBox': 'ExtCtrls', 'TShape': 'ExtCtrls',
    'TTrayIcon': 'ExtCtrls', 'TNotebook': 'ExtCtrls', 'TPage': 'ExtCtrls',
    'TPageControl': 'ComCtrls', 'TTabSheet': 'ComCtrls', 'TTabControl': 'ComCtrls',
    'TToolBar': 'ComCtrls', 'TToolButton': 'ComCtrls', 'TTrackBar': 'ComCtrls',
    'TProgressBar': 'ComCtrls', 'TUpDown': 'ComCtrls', 'TStatusBar': 'ComCtrls',
    'TListView': 'ComCtrls', 'TTreeView': 'ComCtrls', 'THeaderControl': 'ComCtrls',
    'TBitBtn': 'Buttons', 'TSpeedButton': 'Buttons',
    'TMainMenu': 'Menus', 'TPopupMenu': 'Menus', 'TMenuItem': 'Menus',
    'TStringGrid': 'Grids', 'TDrawGrid': 'Grids',
    'TOpenDialog': 'Dialogs', 'TSaveDialog': 'Dialogs',
    'TOpenPictureDialog': 'ExtDlgs', 'TSavePictureDialog': 'ExtDlgs',
    'TColorDialog': 'Dialogs', 'TFontDialog': 'Dialogs',
    'TImageList': 'ImgList',
    'TFileListBox': 'FileCtrl', 'TFilterComboBox': 'FileCtrl',
    'TSpinEdit': 'Spin',
    'TColorBox': 'ColorBox',
    'TActionList': 'ActnList', 'TAction': 'ActnList',
}

# classes that LCL does not provide -> stub with a close base class
STUB_BASE = {
    'TRichEdit': 'TMemo',
    'TMediaPlayer': 'TPanel',
    'TCategoryButtons': 'TPanel',
    'TOleGraphic': 'TPanel',
    'TSpinButton': 'TPanel',
    'TPopupForm': 'TForm',
    'TTabPage': 'TPanel',
    'TTabSet': 'TPanel',
    'TTabbedNotebook': 'TPageControl',
    'TMonthCalendar': 'TCalendar',
    'TDirectoryListBox': 'TListBox',
    'TDriveComboBox': 'TComboBox',
}

# events -> parameter list (LCL compatible)
EVENT_SIG = {
    'OnClick': 'Sender: TObject',
    'OnDblClick': 'Sender: TObject',
    'OnChange': 'Sender: TObject',
    'OnCreate': 'Sender: TObject',
    'OnDestroy': 'Sender: TObject',
    'OnShow': 'Sender: TObject',
    'OnHide': 'Sender: TObject',
    'OnActivate': 'Sender: TObject',
    'OnDeactivate': 'Sender: TObject',
    'OnResize': 'Sender: TObject',
    'OnPaint': 'Sender: TObject',
    'OnTimer': 'Sender: TObject',
    'OnEnter': 'Sender: TObject',
    'OnExit': 'Sender: TObject',
    'OnPopup': 'Sender: TObject',
    'OnDropDown': 'Sender: TObject',
    'OnClickCheck': 'Sender: TObject',
    'OnClose': 'Sender: TObject; var Action: TCloseAction',
    'OnCloseQuery': 'Sender: TObject; var CanClose: Boolean',
    'OnKeyDown': 'Sender: TObject; var Key: Word; Shift: TShiftState',
    'OnKeyUp': 'Sender: TObject; var Key: Word; Shift: TShiftState',
    'OnKeyPress': 'Sender: TObject; var Key: Char',
    'OnMouseDown': 'Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer',
    'OnMouseUp': 'Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer',
    'OnMouseMove': 'Sender: TObject; Shift: TShiftState; X, Y: Integer',
    'OnDrawCell': 'Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState',
    'OnSelectCell': 'Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean',
    'OnRowMoved': 'Sender: TObject; FromIndex, ToIndex: Integer',
    'OnDragDrop': 'Sender, Source: TObject; X, Y: Integer',
    'OnDragOver': 'Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean',
    'OnStartDrag': 'Sender: TObject; var DragObject: TDragObject',
    'OnCanResize': 'Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean',
    'OnConstrainedResize': 'Sender: TObject; var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer',
    'OnContextPopup': 'Sender: TObject; MousePos: TPoint; var Handled: Boolean',
    'OnMouseWheel': 'Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean',
    'OnExecute': 'Sender: TObject',
    'OnUpdate': 'Sender: TObject',
    'OnHint': 'Sender: TObject',
    'OnMinimize': 'Sender: TObject',
    'OnMaximize': 'Sender: TObject',
    'OnWindowStateChange': 'Sender: TObject',
    'OnEditingDone': 'Sender: TObject',
    'OnEdited': 'Sender: TObject; var AText: string',
    'OnSelect': 'Sender: TObject; User: Boolean',
    'OnSelectItem': 'Sender: TObject; Index: Integer',
    'OnChanging': 'Sender: TObject; var AllowChange: Boolean',
    'OnCustomDraw': 'Sender: TObject',
    'OnCustomDrawItem': 'Sender: TObject',
    'OnAdvancedDrawItem': 'Sender: TObject',
    'OnMeasureItem': 'Sender: TObject',
    'OnDrawItem': 'Sender: TObject',
    'OnDrawTab': 'Sender: TObject',
    'OnColumnClick': 'Sender: TObject',
}

INTERACTIVE_EVENTS = {
    'OnClick', 'OnDblClick', 'OnChange', 'OnKeyDown', 'OnKeyPress',
    'OnPopup', 'OnDropDown', 'OnSelect', 'OnEditingDone',
    'OnClickCheck', 'OnSelectCell', 'OnRowMoved', 'OnExecute', 'OnUpdate',
    'OnChanging', 'OnSelectItem', 'OnDrawItem',
}

PASCAL_RESERVED = set('''and array as asm begin case class const constructor destructor dispinterface
div do downto else end except exports file finalization finally for function goto if
implementation in inherited initialization inline interface is label library mod nil not
object of on operator or out packed procedure program property raise record repeat
resourcestring set shl shr string then threadvar to try type unit until uses var while with xor'''.split())

BASE_UNITS = ['Classes', 'SysUtils', 'Types', 'Math', 'Forms', 'Controls', 'Graphics',
              'Dialogs', 'Menus', 'StdCtrls', 'ExtCtrls', 'ComCtrls', 'Buttons', 'Grids',
              'ExtDlgs', 'ImgList', 'FileCtrl', 'CheckLst', 'Spin', 'ColorBox',
              'MaskEdit', 'ActnList', 'Calendar', 'LCLType', 'LCLIntf', 'LResources', 'compat', 'smactions']


def pident(name):
    if not name:
        return 'Unnamed'
    n = re.sub(r'[^A-Za-z0-9_]', '_', name)
    if n[0].isdigit():
        n = '_' + n
    if n.lower() in PASCAL_RESERVED:
        n = '&' + n
    return n


def unit_name(cls):
    base = cls[1:] if cls.startswith('T') else cls
    return 'u' + base


def resolve_class(cls):
    """Return (declared type, is_stub, base)."""
    if cls in STUB_BASE:
        return cls, True, STUB_BASE[cls]
    return cls, False, None


def walk(node):
    yield node
    for c in node['children']:
        yield from walk(c)


def render_value(t, v, indent):
    pad = '  ' * indent
    if t in ('null', 'nil'):
        return 'nil'
    if t == 'int':
        return str(v)
    if t == 'bool':
        return 'True' if v else 'False'
    if t == 'ident':
        return v
    if t == 'str':
        return quote(v, indent)
    if t == 'set':
        return '[' + ', '.join(v) + ']'
    if t == 'float':
        s = repr(v)
        return s
    if t == 'currency':
        return '%r' % v
    if t == 'date':
        return '%r' % v
    if t == 'ext':
        return 'DROP'
    if t == 'binary':
        return '{' + v.upper() + '}'
    if t == 'list':
        parts = []
        for tt, vv in v:
            parts.append(render_value(tt, vv, indent + 1))
        if all(p == 'DROP' for p in parts):
            return 'DROP'
        parts = [p for p in parts if p != 'DROP']
        body = ('\n' + pad + '  ').join(parts)
        return '(\n' + pad + '  ' + body + ')'
    if t == 'collection':
        out = ['<']
        for item in v:
            out.append(pad + '  item')
            for k, (tt, vv) in item.items():
                rv = render_value(tt, vv, indent + 2)
                if rv == 'DROP':
                    continue
                out.append('%s    %s = %s' % (pad, k, rv))
            out.append(pad + '  end')
        out.append(pad + '>')
        return '\n'.join(out)
    return 'DROP'


def quote(s, indent):
    s = str(s)
    if s == '':
        return "''"
    out = []
    cur = []
    i = 0
    changed = False
    for ch in s:
        o = ord(ch)
        if ch == "'":
            cur.append("''")
        elif ch in '\r\n' or o < 32 or o > 126:
            if cur:
                out.append("'" + ''.join(cur) + "'")
                cur = []
            out.append('#%d' % o)
        else:
            cur.append(ch)
    if cur:
        out.append("'" + ''.join(cur) + "'")
    return ''.join(out)


def render_props(node, indent):
    lines = []
    for k, (t, v) in node['props']:
        rv = render_value(t, v, indent)
        if rv == 'DROP':
            continue
        if k == 'Name':
            continue
        lines.append('%s%s = %s' % ('  ' * indent, k, rv))
    return lines


def render_lfm(node, indent=0, namemap=None):
    pad = '  ' * indent
    nm = (namemap or {}).get(id(node), node['name'])
    lines = ['%sobject %s: %s' % (pad, nm, node['cls'])]
    lines.extend(render_props(node, indent + 1))
    for c in node['children']:
        lines.append(render_lfm(c, indent + 1, namemap))
    lines.append('%send' % pad)
    return '\n'.join(lines)


def safe_sig(sig):
    """Prefix non-Sender parameter names with A so they cannot collide with
    published property/method names of TForm in objfpc mode."""
    return re.sub(r'(?<![\w.])([A-Za-z_]\w*)(\s*:\s*)',
                  lambda m: m.group(0) if m.group(1).lower() in ('sender', 'var') else 'A' + m.group(1) + m.group(2),
                  sig)


def collect_events(root):
    """handler name -> dict(params=set of signatures, kinds=set of event names)"""
    ev = {}
    for node in walk(root):
        for k, (t, v) in node['props']:
            if t == 'ident' and k.startswith('On') and v and v not in ('nil',):
                d = ev.setdefault(v, dict(params=set(), kinds=set()))
                d['params'].add(safe_sig(EVENT_SIG.get(k, 'Sender: TObject')))
                d['kinds'].add(k)
    return ev


BASE_METHODS = set('''create destroy free show hide close setfocus repaint invalidate
afterconstruction beforedestruction classtype classname tostring equals getnamepath
newinstance freeinstance defaulthandler dispatch setparentcomponent getparentcomponent
executemenu getchildren findcomponent getchildowner getchildparent loaded notification
setname getowner showmodal showintaskbar bringtofront sendtoback setbounds
setdesigning setinline updating endupdate beginupdate getenabled insertcontrol
removecontrol realign controlcount insertcomponent removecomponent
destroycomponents findchildcontrol gettaborderlist'''.split())


def load_form_props():
    """published properties of LCL TForm, used to detect field/property collisions."""
    path = r'F:\Projects\逆向\sm19src\tools\props.txt'
    if not os.path.exists(path):
        return set()
    for line in open(path, encoding='utf-8', errors='replace'):
        if line.startswith('TForm='):
            return {p.lower() for p in line.strip().split('=', 1)[1].split(',') if p}
    return set()


FORM_PROPS = load_form_props()
RESERVED_NAMES = {m.lower() for m in BASE_METHODS} | FORM_PROPS
_BLACKLIST = r'F:\Projects\逆向\work\name_blacklist.json'
if os.path.exists(_BLACKLIST):
    try:
        RESERVED_NAMES |= {n.lower() for n in json.load(open(_BLACKLIST, encoding='utf-8'))}
    except Exception:
        pass


def apply_rename(root, rename):
    if not rename:
        return
    for node in walk(root):
        node['props'] = [[k, [t, rename.get(v, v) if t == 'ident' else v]]
                         for k, (t, v) in node['props']]


def gen_unit(filename, root, report):
    cls = root['cls']
    uname = unit_name(cls)
    stub_classes = {}
    types_used = set()
    for node in walk(root):
        types_used.add(node['cls'])
    stub_need = sorted(c for c in types_used if c in STUB_BASE)
    fields = []
    anon = 0
    namemap = {}
    for node in root['children']:
        for c in walk(node):
            if not c['name']:
                anon += 1
                newname = 'AnonComp_%d' % anon
                namemap[id(c)] = newname
                continue
            fname = pident(c['name'])
            if fname.lstrip('&').lower() in RESERVED_NAMES:
                newname = c['name'] + '_Ctl'
                namemap[id(c)] = newname
                fname = pident(newname)
            fields.append((fname, c['cls'], c['name']))
    if namemap:
        report.append((uname, 'renamed-components',
                       [namemap[k] for k in namemap]))
    seen = set()
    uniq = []
    dup = 0
    for f in fields:
        if f[0] in seen:
            dup += 1
            continue
        seen.add(f[0])
        uniq.append(f)
    fields = uniq
    if anon or dup:
        report.append((uname, 'anon-or-dup-fields', dict(anon=anon, dup=dup)))
    events = collect_events(root)
    conflicts = {n: d['params'] for n, d in events.items() if len(d['params']) > 1}
    if conflicts:
        report.append((uname, 'event-signature-conflict', conflicts))
    rename = {}
    for ev in list(events):
        if ev.lower() in RESERVED_NAMES:
            rename[ev] = ev + 'Evt'
    if rename:
        report.append((uname, 'renamed-handlers', rename))
        events = {rename.get(k, k): v for k, v in events.items()}
        apply_rename(root, rename)

    buf = io.StringIO()
    buf.write('unit %s;\n{$mode objfpc}{$H+}\n\ninterface\n\n' % uname)
    buf.write('uses\n  ' + ', '.join(BASE_UNITS) + ';\n\n')
    buf.write('type\n  %s = class(TForm)\n' % cls)
    if fields:
        for fname, ccls, orig in fields:
            buf.write('    %s: %s;\n' % (fname, ccls))
        for ev in sorted(events):
            buf.write('    procedure %s(%s);\n' % (pident(ev), list(events[ev]['params'])[0]))
        buf.write('  end;\n')
    else:
        for ev in sorted(events):
            buf.write('    procedure %s(%s);\n' % (pident(ev), list(events[ev]['params'])[0]))
        buf.write('  end;\n')
    buf.write('\nvar\n  %s: %s;\n\nimplementation\n\n{$R *.lfm}\n\n' % (pident(root['name']), cls))
    for ev in sorted(events):
        if events[ev]['kinds'] & INTERACTIVE_EVENTS:
            buf.write('procedure %s.%s(%s);\nbegin\n  DispatchAction(Sender, \'%s\');\nend;\n\n' % (
                cls, pident(ev), list(events[ev]['params'])[0], pident(ev)))
        else:
            buf.write('procedure %s.%s(%s);\nbegin\nend;\n\n' % (
                cls, pident(ev), list(events[ev]['params'])[0]))
    buf.write('initialization\n  if GetClass(\'%s\') = nil then\n    RegisterClass(%s);\n\nend.\n' % (cls, cls))
    return uname, buf.getvalue(), render_lfm(root, 0, namemap), stub_need, len(fields), len(events)


def main():
    os.makedirs(UNITS, exist_ok=True)
    report = []
    manifest = []
    stubs = set()
    for fn in sorted(glob.glob(os.path.join(SRC, '*.json'))):
        root = json.load(open(fn, encoding='utf-8'))
        uname, code, lfm, stub_need, nfields, nev = gen_unit(fn, root, report)
        stubs.update(stub_need)
        open(os.path.join(UNITS, uname + '.pas'), 'w', encoding='utf-8', newline='\r\n').write(code)
        open(os.path.join(UNITS, uname + '.lfm'), 'w', encoding='utf-8', newline='\r\n').write(lfm)
        manifest.append(dict(unit=uname, cls=root['cls'], name=root['name'],
                             fields=nfields, events=nev,
                             source=os.path.basename(fn)))

    # compat unit with stub classes
    cb = io.StringIO()
    cb.write('unit compat;\n{$mode objfpc}{$H+}\n\ninterface\n\nuses\n  Classes, SysUtils, '
             'Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, Grids, '
             'Calendar, ImgList, Buttons, ExtDlgs, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit;\n\n')
    cb.write('type\n')
    for cls in sorted(stubs):
        base = STUB_BASE[cls]
        cb.write('  %s = class(%s)\n  public\n  end;\n' % (cls, base))
    cb.write('\nimplementation\n\ninitialization\n')
    for cls in sorted(stubs):
        cb.write('  RegisterClass(%s);\n' % cls)
    cb.write('end.\n')
    open(os.path.join(OUT, 'compat.pas'), 'w', encoding='utf-8', newline='\r\n').write(cb.getvalue())

    # project file
    units = [m['unit'] for m in manifest]
    main_form = [m for m in manifest if m['cls'] == 'TSMMain']
    main_cls = main_form[0]['cls'] if main_form else manifest[0]['cls']
    main_var = pident(main_form[0]['name']) if main_form else pident(manifest[0]['name'])
    lb = io.StringIO()
    lb.write('program sm19;\n{$mode objfpc}{$H+}\n\nuses\n  Interfaces, Forms, LResources, compat,\n  ')
    lb.write(',\n  '.join(units))
    lb.write(',\n  smdemo;\n\nbegin\n  Application.Initialize;\n  Application.Title := \'SuperMemo 19\';\n')
    # image-list host forms must exist before the forms that reference their
    # ImageList through the `Images = AboutBox.ImageList1` style properties
    host_forms = [m for m in manifest if m['cls'] in ('TAboutBox',)
                  and m['cls'] != main_cls]
    for h in host_forms:
        lb.write('  %s := %s.Create(Application);   // image-list host, never shown\n'
                 % (pident(h['name']), h['cls']))
        lb.write('  %s.Hide;\n' % pident(h['name']))
    lb.write('  Application.CreateForm(%s, %s);\n' % (main_cls, main_var))
    # forms the original binary instantiates at startup (verified with a live
    # window-tree dump): created hidden, in this order
    hidden_forms = ('TStatBar', 'TCommanderDlg', 'TAncestors', 'TBack', 'TStats',
                    'TElDataWind', 'TContents')
    hidden = [m for m in manifest if m['cls'] in hidden_forms]
    for h in hidden:
        lb.write('  %s := %s.Create(Application);\n' % (pident(h['name']), h['cls']))
    # the element window is the original's first visible screen
    shown = [m for m in manifest if m['cls'] in ('TElWind',)]
    for d in shown:
        lb.write('  Application.CreateForm(%s, %s);   // element window: original startup screen\n'
                 % (d['cls'], pident(d['name'])))
        lb.write('  %s.Show;\n' % pident(d['name']))
    lb.write("  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 9) = '--import=') then\n")
    lb.write("  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 15) = '--test-settings') then\n")
    lb.write("  begin\n    SMTestSettings(0);\n    Halt(0);\n  end;\n")
    lb.write("  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 7) = '--study') then\n")
    lb.write('  begin\n    SMStartupStudy(0);\n    Halt(0);\n  end;\n')
    lb.write('  Application.Run;\nend.\n')
    open(os.path.join(OUT, 'sm19.lpr'), 'w', encoding='utf-8', newline='\r\n').write(lb.getvalue())

    json.dump(manifest, open(os.path.join(OUT, 'manifest.json'), 'w', encoding='utf-8'),
              ensure_ascii=False, indent=1)
    print('units:', len(manifest))
    print('stub classes:', sorted(stubs))
    print('total fields:', sum(m['fields'] for m in manifest), 'events:', sum(m['events'] for m in manifest))
    for r in report:
        print('REPORT', r[0], r[1], list(r[2])[:8])


if __name__ == '__main__':
    main()
