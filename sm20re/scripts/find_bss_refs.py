#!/usr/bin/env python3
"""
Find code that references the BSS data pointers.
The algorithm code must read/write to interval_matrix (0x11240a8),
count_matrix (0x11228c8), etc.
Search .text for RIP-relative accesses to these addresses.
"""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

import lief
binary = lief.parse("/Users/mini/sm20-re/sm20.exe")
image_base = binary.optional_header.imagebase

text_foff = 0x400
text_size = 0xc33400
text_va = image_base + 0x1000
text_chunk = raw[text_foff:text_foff + text_size]

# Known BSS/global data pointers
known_pointers = {
    "interval_matrix_ptr": image_base + 0x11240a8,
    "count_matrix_ptr": image_base + 0x11228c8,
    "interval_table_ptr": image_base + 0x1124138,
    "post_lapse1_ptr": image_base + 0x11238e8,
    "alt_table_ptr": image_base + 0x11250c8,
    "matrix2_ptr": image_base + 0x11239f0,
    "alg_version_byte": image_base + 0x122e192,
    "xor_key": image_base + 0x00ccf1a0,  # This is in .data
}

print("Searching .text for references to known data pointers:")
print("=" * 60)

for name, target_va in sorted(known_pointers.items(), key=lambda x: x[1]):
    refs = []
    for i in range(len(text_chunk) - 7):
        # REX + 8d (lea) or REX + 8b (mov) with RIP-relative
        if text_chunk[i] in (0x48, 0x4c, 0x80, 0x81, 0x83, 0x89, 0x8b, 0x8d):
            is_lea = text_chunk[i+1] == 0x8d if (i+1 < len(text_chunk)) else False
            is_mov = text_chunk[i+1] == 0x8b if (i+1 < len(text_chunk)) else False
            
            if i < len(text_chunk) - 7 and text_chunk[i] in (0x48, 0x4c) and text_chunk[i+1] in (0x8d, 0x8b):
                modrm = text_chunk[i+2]
                mod = (modrm >> 6) & 3
                rm = modrm & 7
                if mod == 0 and rm == 5:
                    disp = struct.unpack('<i', text_chunk[i+3:i+7])[0]
                    instr_va = text_va + i
                    resolved = instr_va + 7 + disp
                    if resolved == target_va:
                        regs = {0:'rax',1:'rcx',2:'rdx',3:'rbx',4:'rsp',5:'rbp',6:'rsi',7:'rdi'}
                        prefix = 'r' if text_chunk[i] == 0x4c else ''
                        reg = prefix + regs.get((modrm >> 3) & 7, '?')
                        op = 'lea' if text_chunk[i+1] == 0x8d else 'mov'
                        refs.append((instr_va, op, reg))
    
    if refs:
        print(f"\n  {name} (0x{target_va:x}): {len(refs)} references")
        for instr_va, op, reg in refs[:20]:
            print(f"    0x{instr_va:x}: {op} {reg}, [target]")
    else:
        print(f"\n  {name} (0x{target_va:x}): NO references (accessed indirectly?)")
