"""Shared collection writer with the format facts we have actually verified.

Field layout of an element record (InfElementsElem17, Size=118, Pack=1) is taken
from SuperMemoAssistant's C# definition and cross-checked against 11 real
elements in C:\\supermemo\\systems\\EXTEST:

  +0    byte   elementType      0=Topic 1=Item 4=Concept
  +1    byte   unknownbyte1     0x01 on every child element, 0x02 on the root
  +2    int    titleTextId      id into registry\\Text.*, -1 when deleted
  +6    int    componPos        offset into compon.dat, -1 when no components
  +10   int    unknownId        0x00010059 on topics, 0x00010070 on items
  +28   byte[6] AF              encoding NOT decoded - copied from template
  +61   int    templateId
  +65   int    conceptId
  +103  byte[5] ordinal         encoding NOT decoded - copied from template

Fields marked "not decoded" are always copied verbatim from a template element.
Copying unknown fields does not establish their suitability for a new element.

Component block layout is verified in sm_compblock.py.

save_atomic protects a single file only. Extract/Cloze use sm_transaction for
recoverable multi-file commits. Native registry indexes remain unimplemented;
add_text requires explicit experimental opt-in.
"""
import os, struct, shutil, tempfile

DIM, CONTENT, MEMREC = 118, 37, 30

# --- element offsets ---
E_TYPE, E_UNK1, E_TITLE_ID, E_COMPON, E_UNKNOWN_ID = 0, 1, 2, 6, 10
E_UNK6, E_UNK7, E_AF, E_TEMPLATE_ID, E_CONCEPT_ID = 26, 27, 28, 61, 65
E_ORDINAL = 103

TYPE_TOPIC, TYPE_ITEM, TYPE_CONCEPT = 0x00, 0x01, 0x04
FREE_ID = 65535

# --- component geometry (measured; identical across 8 of 11 elements) ---
GEO_SINGLE = dict(left=100, top=200, width=9700, height=9300, display_at=255)
GEO_CLOZE_Q = dict(left=100, top=57, width=9701, height=7848, display_at=255)
GEO_CLOZE_A = dict(left=100, top=7961, width=4989, height=1495, display_at=223)

# reserved area of a component group, 43 bytes (all-zero form used by new elements)
RESERVED_ZERO = bytes([0x05, 0x00, 0x00, 0xFF, 0x01]) + bytes(19) + bytes([0x01]) + bytes(18)
assert len(RESERVED_ZERO) == 43

HTML_HEADER = 0x1C0D
COMP_SIZE = 31
REG_ID_OFF = 2 + 18


# ---------------------------------------------------------------- file helpers

def load(path):
    with open(path, 'rb') as stream:
        return bytearray(stream.read())


def save_atomic(path, data):
    """Write to a temp file in the same directory then replace."""
    d = os.path.dirname(path) or '.'
    fd, tmp = tempfile.mkstemp(dir=d, prefix='.tmp_', suffix='.bak')
    try:
        with os.fdopen(fd, 'wb') as f:
            f.write(bytes(data))
        os.replace(tmp, path)
    except Exception:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise


def paths(coll):
    return dict(
        info=os.path.join(coll, 'info', 'ElementInfo.dat'),
        cont=os.path.join(coll, 'info', 'contents.dat'),
        comp=os.path.join(coll, 'info', 'compon.dat'),
        rtx=os.path.join(coll, 'registry', 'Text.rtx'),
        mem=os.path.join(coll, 'registry', 'Text.mem'),
        ptr=os.path.join(coll, 'registry', 'Text.ptr'),
        eldir=os.path.join(coll, 'elements'),
    )


# -------------------------------------------------------------------- parsing

def parse_elements(data):
    out = []
    for i in range(len(data) // DIM):
        r = bytes(data[i * DIM:(i + 1) * DIM])
        out.append(dict(
            slot=i + 1, raw=r,
            element_type=r[E_TYPE], unknown1=r[E_UNK1],
            title_id=struct.unpack_from('<i', r, E_TITLE_ID)[0],
            compon_pos=struct.unpack_from('<i', r, E_COMPON)[0],
            unknown_id=struct.unpack_from('<i', r, E_UNKNOWN_ID)[0],
            template_id=struct.unpack_from('<i', r, E_TEMPLATE_ID)[0],
            concept_id=struct.unpack_from('<i', r, E_CONCEPT_ID)[0]))
    return out


def parse_contents(data):
    out = []
    for i in range(len(data) // CONTENT):
        r = bytes(data[i * CONTENT:(i + 1) * CONTENT])
        out.append(dict(raw=r,
                        parent=struct.unpack_from('<H', r, 1)[0],
                        first=struct.unpack_from('<H', r, 5)[0],
                        last=struct.unpack_from('<H', r, 9)[0],
                        prev=struct.unpack_from('<H', r, 13)[0],
                        next=struct.unpack_from('<H', r, 17)[0],
                        kids=struct.unpack_from('<H', r, 21)[0]))
    return out


def parse_text(rtx):
    out, i = [], 0
    while i < len(rtx):
        st = i
        while i < len(rtx) and rtx[i] != 0:
            i += 1
        if i >= len(rtx):
            break
        raw = bytes(rtx[st:i])
        i += 1
        tid = struct.unpack_from('<i', rtx, i)[0] if i + 4 <= len(rtx) else -1
        i += 5
        out.append(dict(id=tid, text=raw, start=st, end=i))
    return out


def component_blocks(comp):
    """Scan compon.dat for every 31-D4 group. Returns list of dicts."""
    out, pos = [], 0
    while True:
        pos = comp.find(b'\x31\xd4', pos)
        if pos < 0 or pos + 11 > len(comp):
            break
        length = struct.unpack_from('<H', comp, pos + 2)[0]
        count = comp[pos + 8]
        skip = struct.unpack_from('<H', comp, pos + 9)[0]
        total = 4 + length
        if count == 0 or count > 8 or pos + total > len(comp) or length != 50 + count * COMP_SIZE or skip != 43:
            pos += 2
            continue
        comps = []
        cstart = pos + 11 + skip
        for k in range(count):
            cs = cstart + k * COMP_SIZE
            comps.append(dict(
                type_header=struct.unpack_from('<H', comp, cs)[0],
                registry_id=struct.unpack_from('<i', comp, cs + REG_ID_OFF)[0],
                raw=bytes(comp[cs:cs + COMP_SIZE])))
        out.append(dict(pos=pos, length=length, total=total, slot=struct.unpack_from('<i', comp, pos + 4)[0] & 0xFF,
                        count=count, skip=skip, reserved=bytes(comp[pos + 11:pos + 11 + skip]),
                        components=comps))
        pos += total
    return out


# --------------------------------------------------------------------- writer

def encode_text_mem_record(offset, length, *, use_count=0, lst_related=0):
    """Encode verified RegMemElem17 fields; offset is one-based.

    Unreferenced records use use_count=lst_related=0. The caller must maintain
    Text.lst when linking a registry member to an element. See
    TEXT_REGISTRY_EVIDENCE.md for source and compatibility limits.
    """
    if offset < 1 or length < 6:
        raise ValueError('invalid text offset or record length')
    if use_count < 0 or lst_related < 0 or bool(use_count) != bool(lst_related):
        raise ValueError('use_count and lst_related must describe a valid reference list')
    rec = bytearray(MEMREC)
    struct.pack_into('<i', rec, 0, use_count)
    rec[4] = 3                       # inline text link type
    struct.pack_into('<i', rec, 10, offset)
    struct.pack_into('<i', rec, 14, length)
    struct.pack_into('<i', rec, 18, lst_related)
    return rec


def add_text(rtx, mem, ptr, text_bytes, *, experimental=False):
    """Append a research-only registry record, returning its one-based mem slot.

    Native-compatible writes need Text.lst backlinks and the native Text.ptr
    collation. These are not maintained by this three-buffer API. Refuse by
    default; experimental=True is only for disposable research collections.
    """
    if not experimental:
        raise ValueError('native registry writes are not verified: Text.lst backlinks '
                         'and Text.ptr sorting are not maintained; use explicit '
                         'experimental registry mode on a disposable copy only')
    if len(mem) % MEMREC or len(ptr) % 4:
        raise ValueError('truncated Text.mem or Text.ptr')
    text_bytes = bytes(text_bytes)
    if b'\x00' in text_bytes:
        raise ValueError('text cannot contain NUL')
    # Registry ID is the one-based mem row, not lstRelated or max(ptr).
    new_id = len(mem) // MEMREC + 1
    blob = text_bytes + b'\x00' + struct.pack('<i', new_id) + b'\x01'
    rec = encode_text_mem_record(len(rtx) + 1, len(blob))
    pointer = struct.pack('<i', new_id)
    # Validate/build everything before changing any caller-owned buffer.
    rtx += blob
    mem += rec
    ptr += pointer                   # experimental: native sort is unresolved
    return new_id


def geometry_bytes(geo, registry_id, type_header=HTML_HEADER):
    """Build one 31-byte component: 2 type bytes + 29-byte HTML17."""
    html = bytearray(29)
    struct.pack_into('<h', html, 1, geo['left'])
    struct.pack_into('<h', html, 3, geo['top'])
    struct.pack_into('<h', html, 5, geo['width'])
    struct.pack_into('<h', html, 7, geo['height'])
    html[9] = geo['display_at']
    html[15] = 1                     # isFullHtml
    struct.pack_into('<i', html, 18, registry_id)
    comp = bytearray(COMP_SIZE)
    struct.pack_into('<H', comp, 0, type_header)
    comp[2:] = html
    return bytes(comp)


def build_block(slot_no, geometries, registry_ids, reserved=RESERVED_ZERO):
    """Assemble a component group. geometries/registry_ids are parallel lists."""
    n = len(registry_ids)
    assert n == len(geometries) and n > 0
    length = 11 + len(reserved) + n * COMP_SIZE - 4
    out = bytearray()
    out += b'\x31\xd4'
    out += struct.pack('<H', length)
    out += struct.pack('<i', slot_no)
    out += bytes([n])
    out += struct.pack('<H', len(reserved))
    out += reserved
    for geo, rid in zip(geometries, registry_ids):
        out += geometry_bytes(geo, rid)
    assert len(out) == 4 + length
    return bytes(out)


def new_element_record(template, element_type, title_id, compon_pos):
    """Copy an element record, then stamp only the fields we have verified."""
    rec = bytearray(template['raw'])
    rec[E_TYPE] = element_type
    rec[E_UNK1] = 0x01
    struct.pack_into('<i', rec, E_TITLE_ID, title_id)
    struct.pack_into('<i', rec, E_COMPON, compon_pos)
    # unknownId / AF / templateId / conceptId / ordinal stay as the template's
    return bytes(rec)


def recount_subtrees(conts):
    """kids = number of descendants (verified: root kids=3 with one direct child)."""
    children = {}
    for i, c in enumerate(conts):
        children.setdefault(struct.unpack_from('<H', c['raw'], 1)[0], []).append(i + 1)

    def count(o, depth=0):
        if depth > 40:
            return 0
        return sum(1 + count(k, depth + 1) for k in children.get(o, []))

    for i, c in enumerate(conts):
        raw = bytearray(c['raw'])
        struct.pack_into('<H', raw, 21, count(i + 1))
        c['raw'] = bytes(raw)


def attach_child(conts, parent_ord, new_ord):
    last = conts[parent_ord - 1]['last']
    if last:
        r = bytearray(conts[last - 1]['raw'])
        struct.pack_into('<H', r, 17, new_ord)
        conts[last - 1]['raw'] = bytes(r)
        r = bytearray(conts[new_ord - 1]['raw'])
        struct.pack_into('<H', r, 13, last)
        conts[new_ord - 1]['raw'] = bytes(r)
    pr = bytearray(conts[parent_ord - 1]['raw'])
    if last == 0:
        struct.pack_into('<H', pr, 5, new_ord)
    struct.pack_into('<H', pr, 9, new_ord)
    conts[parent_ord - 1]['raw'] = bytes(pr)
    recount_subtrees(conts)


def concat_contents(conts):
    out = bytearray()
    for c in conts:
        out += c['raw']
    return out


def find_free_slot(els):
    """A freed element has titleTextId == -1 (deleted).  The old reading of
    'kind=3 / id=65535' came from reading +1 as the type and the low half of
    the -1 int as the id; the real marker is titleTextId == -1."""
    for e in els:
        if e['title_id'] == -1:
            return e
    return None
