"""Native-compatible text registry writes.

The registry is four files, and all four must agree:

  Text.rtx   the text blobs
  Text.mem   30-byte records: useCount / rtxOffset / rtxLength / lstRelated
  Text.lst   8-byte nodes: (referencing element slot, next node or 0)
  Text.ptr   member-id ordering (collation rule NOT confirmed, see below)

Registry member id == the one-based row number in Text.mem.

Chain semantics, verified on EXTEST (see TEXT_REGISTRY_EVIDENCE.md):
  mem.lstRelated is the 1-based node index where this member's reference chain
  starts; following `next` yields exactly `useCount` nodes.  A slot may repeat in
  a chain (member 3 -> [9, 9, 3, 3]), so "distinct elements" is not useCount.

STATUS
  Text.lst maintenance is implemented and matches every observed chain.
  Text.ptr ordering is NOT confirmed: the original orders members by text
  collation which we have not reverse-engineered.  This module appends new ids to
  ptr, which produces a readable collection in our tests but is *not* proven
  identical to the original ordering.  Callers must not claim byte-identical
  registry output while that is open.
"""
import struct

MEMREC = 30
LSTREC = 8

# mem field offsets (verified)
M_USE_COUNT = 0
M_LINK_TYPE = 4
M_RTX_OFF = 10
M_RTX_LEN = 14
M_LST_RELATED = 18


def parse_mem(mem):
    out = []
    for i in range(len(mem) // MEMREC):
        r = mem[i * MEMREC:(i + 1) * MEMREC]
        out.append(dict(
            member=i + 1,
            use_count=struct.unpack_from('<i', r, M_USE_COUNT)[0],
            link_type=r[M_LINK_TYPE],
            rtx_off=struct.unpack_from('<i', r, M_RTX_OFF)[0],
            rtx_len=struct.unpack_from('<i', r, M_RTX_LEN)[0],
            lst_related=struct.unpack_from('<i', r, M_LST_RELATED)[0]))
    return out


def parse_lst(lst):
    return [tuple(struct.unpack_from('<ii', lst, i * LSTREC))
            for i in range(len(lst) // LSTREC)]


def chain_slots(lst_bytes, start_node):
    """Follow a reference chain, returning the list of element slots."""
    nodes = parse_lst(lst_bytes)
    out, cur, guard = [], start_node, 0
    while cur and 1 <= cur <= len(nodes) and guard < 1000:
        slot, nxt = nodes[cur - 1]
        out.append(slot)
        cur = nxt
        guard += 1
    return out


def encode_mem(offset, length, use_count, lst_related):
    rec = bytearray(MEMREC)
    struct.pack_into('<i', rec, M_USE_COUNT, use_count)
    rec[M_LINK_TYPE] = 3                    # inline text
    struct.pack_into('<i', rec, M_RTX_OFF, offset)
    struct.pack_into('<i', rec, M_RTX_LEN, length)
    struct.pack_into('<i', rec, M_LST_RELATED, lst_related)
    return rec


def member_text(mem, rtx, member):
    """Return a member's raw text bytes (without the NUL/id/tail)."""
    if member < 1 or member * MEMREC > len(mem):
        return b''
    base = (member - 1) * MEMREC
    off = struct.unpack_from('<i', mem, base + M_RTX_OFF)[0]
    ln = struct.unpack_from('<i', mem, base + M_RTX_LEN)[0]
    if off < 1 or ln < 6:
        return b''
    start = off - 1
    return bytes(rtx[start:start + ln - 6])


def add_text_linked(rtx, mem, lst, ptr, text_bytes, ref_slot):
    """Append a text record referenced by one element.

    rtx/mem/lst/ptr are mutable buffers.  Returns the new member id.
    Every input is validated before any buffer is touched.
    """
    text_bytes = bytes(text_bytes)
    if b'\x00' in text_bytes:
        raise ValueError('text cannot contain NUL')
    if len(mem) % MEMREC or len(lst) % LSTREC or len(ptr) % 4:
        raise ValueError('truncated registry file')
    if ref_slot < 1:
        raise ValueError('ref_slot must be a 1-based element slot')

    new_id = len(mem) // MEMREC + 1
    new_node = len(lst) // LSTREC + 1
    offset = len(rtx) + 1                   # one-based
    blob = text_bytes + b'\x00' + struct.pack('<i', new_id) + b'\x01'
    length = len(blob)

    # build everything first
    rec = encode_mem(offset, length, 1, new_node)
    node = struct.pack('<ii', ref_slot, 0)

    # Text.ptr orders members by the byte value of their text (verified on the
    # 15 members of EXTEST: CRLF sorts before space, space before letters, and
    # the two 's' texts order by their second byte).  Insert, do not append.
    insert_at = len(ptr)
    for i in range(0, len(ptr) - 3, 4):
        other_id = struct.unpack_from('<i', ptr, i)[0]
        other = member_text(mem, rtx, other_id)
        if text_bytes < other:
            insert_at = i
            break
    ptr_entry = struct.pack('<i', new_id)
    ptr[insert_at:insert_at] = ptr_entry

    rtx += blob
    mem += rec
    lst += node
    return new_id


def add_reference(lst, mem, member, ref_slot):
    """Add one more reference to an existing member.

    The chain grows by one node, and useCount is bumped.  New node is prepended
    at the tail of the list and linked from the last existing node, which keeps
    the original node indices stable.
    """
    if len(lst) % LSTREC or len(mem) % MEMREC:
        raise ValueError('truncated registry file')
    base = (member - 1) * MEMREC
    use_count = struct.unpack_from('<i', mem, base + M_USE_COUNT)[0]
    start = struct.unpack_from('<i', mem, base + M_LST_RELATED)[0]

    new_node = len(lst) // LSTREC + 1
    node = bytearray(struct.pack('<ii', ref_slot, 0))
    lst += node

    if start == 0:
        struct.pack_into('<i', mem, base + M_LST_RELATED, new_node)
    else:
        # walk to the end of the existing chain
        cur, guard = start, 0
        while guard < 1000:
            nxt = struct.unpack_from('<i', lst, (cur - 1) * LSTREC + 4)[0]
            if nxt == 0:
                break
            cur = nxt
            guard += 1
        struct.pack_into('<i', lst, (cur - 1) * LSTREC + 4, new_node)

    struct.pack_into('<i', mem, base + M_USE_COUNT, use_count + 1)
    return new_node


def drop_reference(lst, mem, member, node_index):
    """Remove one node from a member's chain (not used yet; kept for symmetry)."""
    base = (member - 1) * MEMREC
    use_count = struct.unpack_from('<i', mem, base + M_USE_COUNT)[0]
    if use_count <= 0:
        raise ValueError('member has no references')
    start = struct.unpack_from('<i', mem, base + M_LST_RELATED)[0]
    # relink predecessor -> successor
    prev, cur, guard = 0, start, 0
    while cur and guard < 1000:
        if cur == node_index:
            nxt = struct.unpack_from('<i', lst, (cur - 1) * LSTREC + 4)[0]
            if prev == 0:
                struct.pack_into('<i', mem, base + M_LST_RELATED, nxt)
            else:
                struct.pack_into('<i', lst, (prev - 1) * LSTREC + 4, nxt)
            struct.pack_into('<ii', lst, (cur - 1) * LSTREC, 0, 0)
            struct.pack_into('<i', mem, base + M_USE_COUNT, use_count - 1)
            return True
        prev = cur
        cur = struct.unpack_from('<i', lst, (cur - 1) * LSTREC + 4)[0]
        guard += 1
    return False


def verify(mem, lst):
    """Check every member's chain length equals its useCount. Returns list of problems."""
    problems = []
    nodes = parse_lst(lst)
    for m in parse_mem(mem):
        chain = chain_slots(lst, m['lst_related']) if m['lst_related'] else []
        if len(chain) != m['use_count']:
            problems.append('member %d: useCount=%d but chain=%s'
                            % (m['member'], m['use_count'], chain))
    return problems
