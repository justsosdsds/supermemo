"""Component block builder — layout verified against five elements in a real
collection and against SuperMemoAssistant's ComponentRegistry / InfComponentsElem17.

Block layout (measured + confirmed by SMA source)
-------------------------------------------------
  +0   31 d4                  CGroupHeader
  +2   ushort length          block data length; total footprint = 4 + length
  +4   int    dummy           low byte is the 1-based slot number
  +8   byte   compCount
  +9   ushort skip            always 43 in observed collections
  +11  byte[skip]             reserved area (copied verbatim from a template)
  +54  component[0]           first component, 31 bytes
  +85  component[1]           second component (cloze only)

  length = 11 + skip + N*31 - 4 = 50 + N*31
        N=1 -> 81,  N=2 -> 112          (both observed)

Component layout (31 bytes)
  +0   ushort typeHeader      0x1C0D = HTML, 0x2200 = Text, 0x1D0C = Rtf,
                              0x2201 = Spelling, 0x1902 = Image,
                              0x3003 = Sound, 0x1F04 = Video
  +2   InfComponentsHtml17    29 bytes, registryId at its own +18 => block +20

ElementInfo does NOT store the block size.  The old field I read as "comp_size"
at +10 is actually `unknownId` (0x00010059 for topics, 0x00010070 for items), and
is copied from the template unchanged.
"""
import struct

MAGIC = b'\x31\xd4'
HTML_HEADER = 0x1C0D
TEXT_HEADER = 0x2200
RTF_HEADER = 0x1D0C
SPELLING_HEADER = 0x2201
IMAGE_HEADER = 0x1902
SOUND_HEADER = 0x3003
VIDEO_HEADER = 0x1F04

COMPONENT_SIZE = 31
REGISTRY_ID_OFFSET = 2 + 18      # inside a component


def parse_block(data, pos):
    """Decode one component group starting at `pos`. Returns dict or None."""
    if pos + 11 > len(data) or data[pos:pos + 2] != MAGIC:
        return None
    length = struct.unpack_from('<H', data, pos + 2)[0]
    dummy = struct.unpack_from('<i', data, pos + 4)[0]
    count = data[pos + 8]
    skip = struct.unpack_from('<H', data, pos + 9)[0]
    comp_start = pos + 11 + skip
    comps = []
    for k in range(count):
        cs = comp_start + k * COMPONENT_SIZE
        if cs + COMPONENT_SIZE > len(data):
            break
        comps.append(dict(
            type_header=struct.unpack_from('<H', data, cs)[0],
            registry_id=struct.unpack_from('<i', data, cs + REGISTRY_ID_OFFSET)[0],
            raw=bytes(data[cs:cs + COMPONENT_SIZE])))
    return dict(pos=pos, length=length, total=4 + length,
                slot=dummy & 0xFF, count=count, skip=skip, components=comps,
                reserved=bytes(data[pos + 11:pos + 11 + skip]))


def build_block(slot_no, registry_ids, template_block, comp_type=HTML_HEADER):
    """Assemble a component group.

    slot_no        1-based slot number written into `dummy`
    registry_ids   one text-pool record id per component
    template_block parsed dict from parse_block(); its `reserved` area and its
                   first component are used as the byte template
    comp_type      type header to stamp on every component
    """
    n = len(registry_ids)
    reserved = template_block['reserved']
    tmpl_comp = bytearray(template_block['components'][0]['raw'])

    length = 11 + len(reserved) + n * COMPONENT_SIZE - 4
    out = bytearray()
    out += MAGIC
    out += struct.pack('<H', length)
    out += struct.pack('<i', slot_no)
    out += bytes([n])
    out += struct.pack('<H', len(reserved))
    out += reserved
    for rid in registry_ids:
        comp = bytearray(tmpl_comp)
        struct.pack_into('<H', comp, 0, comp_type)
        struct.pack_into('<i', comp, REGISTRY_ID_OFFSET, rid)
        out += comp
    assert len(out) == 4 + length, 'block size mismatch: %d vs %d' % (len(out), 4 + length)
    return bytes(out)


if __name__ == '__main__':
    import sys, os
    if len(sys.argv) < 3:
        print('usage: sm_compblock.py <collection> <slot>')
        sys.exit(2)
    coll, slot = sys.argv[1], int(sys.argv[2])
    info = open(os.path.join(coll, 'info', 'ElementInfo.dat'), 'rb').read()
    data = open(os.path.join(coll, 'info', 'compon.dat'), 'rb').read()
    pos = struct.unpack_from('<i', info, (slot - 1) * 118 + 6)[0]
    b = parse_block(data, pos)
    print('slot %d @ %d: length=%d total=%d slot=%d count=%d skip=%d'
          % (slot, b['pos'], b['length'], b['total'], b['slot'], b['count'], b['skip']))
    for i, c in enumerate(b['components']):
        print('  component %d: type=0x%04X registryId=%d'
              % (i + 1, c['type_header'], c['registry_id']))
