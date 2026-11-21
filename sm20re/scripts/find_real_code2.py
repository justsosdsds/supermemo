#!/usr/bin/env python3
"""
Find actual code referencing algorithm strings.
Properly map file offsets to VAs using section headers.
"""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

import lief
binary = lief.parse("/Users/mini/sm20-re/sm20.exe")
image_base = binary.optional_header.imagebase

# Build section map
sections = []
for s in binary.sections:
    sections.append({
        'name': s.name,
        'va': image_base + s.virtual_address,
        'va_end': image_base + s.virtual_address + s.virtual_size,
        'offset': s.offset,
        'offset_end': s.offset + s.sizeof_raw_data,
        'vaddr': s.virtual_address,
        'vsize': s.virtual_size,
    })
    print(f"  {s.name:10s}: offset 0x{s.offset:x}-0x{s.offset+s.sizeof_raw_data:x}, VA 0x{image_base+s.virtual_address:x}-0x{image_base+s.virtual_address+s.virtual_size:x}")

def file_offset_to_va(foff):
    for s in sections:
        if s['offset'] <= foff < s['offset_end']:
            return s['va'] + (foff - s['offset'])
    return None

def va_to_file_offset(va):
    for s in sections:
        if s['va'] <= va < s['va_end']:
            off = s['offset'] + (va - s['va'])
            if off < len(raw):
                return off
    return None

# Find key strings
key_strings = {}
search_terms = ["AlgSM20", "AlgSM20Ext", "NewUFactor", "GetNextRepetitionDayNo",
                 "SM20MetricCount", "SM20MetricSum", "SM20MetricResult",
                 "FinalSM20MetricResult", "FillUpPostLapseIntervalArray"]

for name in search_terms:
    needle = name.encode('ascii')
    pos = 0
    while True:
        pos = raw.find(needle, pos)
        if pos < 0:
            break
        va = file_offset_to_va(pos)
        section = "?"
        for s in sections:
            if s['va'] <= (va or 0) < s['va_end']:
                section = s['name']
                break
        print(f"  '{name}' at offset 0x{pos:x}, VA=0x{va:x} (in {section})")
        if name not in key_strings:
            key_strings[name] = []
        key_strings[name].append(va)
        pos += 1

# Now search .text for code referencing these string VAs
print(f"\nSearching .text for cross-references...")
text_section = sections[0]  # .text is first
text_start = text_section['va']
text_size = text_section['vsize']
text_foff = text_section['offset']
text_chunk = raw[text_foff:text_foff+text_size]

ref_results = []

for i in range(len(text_chunk) - 7):
    # REX prefix + 8d or 8b (LEA or MOV with RIP-relative)
    if text_chunk[i] in (0x48, 0x4c) and text_chunk[i+1] in (0x8d, 0x8b):
        modrm = text_chunk[i+2]
        mod = (modrm >> 6) & 3
        rm = modrm & 7
        if mod == 0 and rm == 5:
            disp = struct.unpack('<i', text_chunk[i+3:i+7])[0]
            instr_va = text_start + i
            target_va = instr_va + 7 + disp
            
            # Check against all known string VAs
            for name, vas in key_strings.items():
                for str_va in vas:
                    if str_va is None:
                        continue
                    # String might have a length byte prefix, so check ±16
                    if abs(target_va - str_va) < 32:
                        regs = {0:'rax',1:'rcx',2:'rdx',3:'rbx',4:'rsp',5:'rbp',6:'rsi',7:'rdi'}
                        prefix = 'r' if text_chunk[i] == 0x4c else ''
                        reg = prefix + regs.get((modrm >> 3) & 7, '?')
                        op = 'lea' if text_chunk[i+1] == 0x8d else 'mov'
                        ref_results.append((instr_va, op, reg, target_va, name, target_va - str_va))
                        break

print(f"\n  Found {len(ref_results)} cross-references:")
for instr_va, op, reg, target_va, name, delta in ref_results:
    print(f"  0x{instr_va:x}: {op} {reg}, [0x{target_va:x}] → '{name}' (delta={delta:+d})")
