"""Append a text record to the Text registry (rtx + mem + ptr, leaving lst alone)
and see whether the original program accepts the collection.

mem record layout (30 bytes, values stored << 16):
  +0  int32 status      1 = live, 0 = free slot
  +4  int32 kind        3 in every observed record
  +8  int32 (offset+1) << 16
  +12 int32 length << 16
  +16 int32 slot/reference (pool specific, 0 in Template)
  +20 int32 0
  +24 int32 0
  +28 2 bytes 0
"""
import struct, os, sys

MEMREC = 30


def load(p):
    return bytearray(open(p, 'rb').read())


def save(p, d):
    open(p, 'wb').write(bytes(d))


def add_text(coll, text, text_id):
    reg = os.path.join(coll, 'registry')
    rtx_p = os.path.join(reg, 'Text.rtx')
    mem_p = os.path.join(reg, 'Text.mem')
    ptr_p = os.path.join(reg, 'Text.ptr')

    rtx = load(rtx_p)
    mem = load(mem_p)

    offset = len(rtx)
    blob = text.encode('utf-8') + b'\x00' + struct.pack('<i', text_id) + b'\x01'
    rtx += blob
    save(rtx_p, rtx)

    rec = bytearray(MEMREC)
    struct.pack_into('<i', rec, 0, 1)
    struct.pack_into('<i', rec, 4, 3)
    struct.pack_into('<i', rec, 8, (offset + 1) << 16)
    struct.pack_into('<i', rec, 12, len(blob) << 16)
    struct.pack_into('<i', rec, 16, text_id << 16)
    mem += rec
    save(mem_p, mem)

    ptr = load(ptr_p)
    ptr += struct.pack('<i', text_id)
    save(ptr_p, ptr)

    print('appended text id=%d at rtx offset %d (%d bytes)' % (text_id, offset, len(blob)))
    print('mem records now %d, ptr entries now %d' % (len(mem) // MEMREC, len(ptr) // 4))
    return 0


if __name__ == '__main__':
    coll = sys.argv[1] if len(sys.argv) > 1 else r'F:\SMCollections\ABC'
    text = sys.argv[2] if len(sys.argv) > 2 else 'Appended by the engine.'
    tid = int(sys.argv[3]) if len(sys.argv) > 3 else 7
    sys.exit(add_text(coll, text, tid))
