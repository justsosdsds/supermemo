#!/usr/bin/env python3
"""Analyze FUN_ce8dd0 and FUN_cf7550 as Delphi data structures."""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

image_base = 0x400000
text_start = 0x401000
text_end = 0x1034400

# RVA to file offset helper
pe_offset = 0x3c  # offset to PE header
pe_sig = struct.unpack('<I', raw[pe_offset:pe_offset+4])[0]
sections_offset = pe_offset + 4 + 20  # PE sig + COFF header

num_sections = struct.unpack('<H', raw[sections_offset+2:sections_offset+4])[0]
opt_header_size = struct.unpack('<H', raw[sections_offset+16:sections_offset+18])[0]
sections_start = sections_offset + 20 + opt_header_size

sections = []
for i in range(num_sections):
    off = sections_start + i * 40
    name = raw[off:off+8].rstrip(b'\x00').decode('ascii', errors='replace')
    vsize = struct.unpack('<I', raw[off+8:off+12])[0]
    va = struct.unpack('<I', raw[off+12:off+16])[0]
    raw_size = struct.unpack('<I', raw[off+16:off+20])[0]
    raw_off = struct.unpack('<I', raw[off+20:off+24])[0]
    sections.append((name, va, vsize, raw_size, raw_off))

def rva_to_offset(rva):
    for name, va, vsize, raw_size, raw_off in sections:
        if va <= rva < va + max(vsize, raw_size):
            return raw_off + (rva - va)
    return None

def va_to_offset(va):
    return rva_to_offset(va - image_base)

def is_code_ptr(val):
    return text_start <= val <= text_end

def read_ptr(offset):
    return struct.unpack('<Q', raw[offset:offset+8])[0]

def read_dword(offset):
    return struct.unpack('<I', raw[offset:offset+8])[0]  # also read 8 bytes for context

# Analyze FUN_ce8dd0
print("=" * 60)
print("FUN_ce8dd0 (0x10e8dd0) — Delphi data structure")
print("=" * 60)

offset = va_to_offset(0x10e8dd0)
print(f"File offset: 0x{offset:x}")

# Read as 8-byte values
for i in range(0, 200, 8):
    val = read_ptr(offset + i)
    va = 0x10e8dd0 + i
    
    if is_code_ptr(val):
        print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → CODE pointer")
    elif val < 0x10000 and val > 0:
        # Small number, could be count/flag
        print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → small value ({val})")
    elif val == 0:
        print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → NULL")
    else:
        # Try as double
        d = struct.unpack('<d', raw[offset+i:offset+i+8])[0]
        if 0.001 < abs(d) < 1e10 and not (d != d):  # not NaN
            print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → double {d:.6f}")
        else:
            print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → ?")

print()
print("=" * 60)
print("FUN_cf7550 (0x10f7550) — Delphi data structure")
print("=" * 60)

offset = va_to_offset(0x10f7550)
print(f"File offset: 0x{offset:x}")

for i in range(0, 300, 8):
    val = read_ptr(offset + i)
    va = 0x10f7550 + i
    
    if is_code_ptr(val):
        print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → CODE pointer")
    elif val < 0x10000 and val > 0:
        print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → small value ({val})")
    elif val == 0:
        print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → NULL")
    else:
        d = struct.unpack('<d', raw[offset+i:offset+i+8])[0]
        if 0.001 < abs(d) < 1e10 and not (d != d):
            print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → double {d:.6f}")
        else:
            print(f"  +0x{i:03x} (0x{va:x}): 0x{val:016x} → ?")

# Also analyze FUN_4772a0 (in .text, real function)
print()
print("=" * 60)
print("FUN_4772a0 (0x8772a0) — .text code function")  
print("=" * 60)

offset = va_to_offset(0x8772a0)
print(f"File offset: 0x{offset:x}")

# Read referenced data addresses
chunk = raw[offset:offset+2048]
for i in range(len(chunk) - 7):
    if chunk[i] == 0x48 and chunk[i+1] == 0x8d:
        modrm = chunk[i+2]
        mod = (modrm >> 6) & 3
        rm = modrm & 7
        if mod == 0 and rm == 5:
            disp = struct.unpack('<i', chunk[i+3:i+7])[0]
            target_va = 0x8772a0 + i + 7 + disp
            reg_names = {0:'rax',1:'rcx',2:'rdx',3:'rbx',4:'rsp',5:'rbp',6:'rsi',7:'rdi'}
            reg = reg_names.get((modrm >> 3) & 7, '?')
            
            # Try to read value at target
            target_offset = va_to_offset(target_va)
            if target_offset:
                val = read_ptr(target_offset)
                d = struct.unpack('<d', raw[target_offset:target_offset+8])[0]
                if 0.001 < abs(d) < 1e10 and not (d != d):
                    print(f"  lea {reg}, [0x{target_va:x}] → double {d:.6f}")
                elif is_code_ptr(val):
                    print(f"  lea {reg}, [0x{target_va:x}] → code ptr 0x{val:x}")
                else:
                    print(f"  lea {reg}, [0x{target_va:x}] → raw 0x{val:x}")
