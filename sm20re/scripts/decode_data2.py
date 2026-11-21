#!/usr/bin/env python3
"""Analyze FUN_ce8dd0, FUN_cf7550, FUN_4772a0 using lief for PE parsing."""

import lief
import struct

binary = lief.parse("/Users/mini/sm20-re/sm20.exe")

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

image_base = binary.optional_header.imagebase
text_start = image_base + 0x1000  # .text
text_end = text_start + 0xc33400

def rva_to_file_offset(rva):
    for s in binary.sections:
        if s.virtual_address <= rva < s.virtual_address + s.virtual_size:
            return s.offset + (rva - s.virtual_address)
    # Fallback: try raw_size
    for s in binary.sections:
        if s.virtual_address <= rva < s.virtual_address + s.sizeof_raw_data:
            return s.offset + (rva - s.virtual_address)
    return None

def va_to_file_offset(va):
    return rva_to_file_offset(va - image_base)

def is_code_ptr(val):
    return text_start <= val <= text_end

def read_u64(offset):
    if offset is None or offset + 8 > len(raw):
        return None
    return struct.unpack('<Q', raw[offset:offset+8])[0]

def read_double(offset):
    if offset is None or offset + 8 > len(raw):
        return None
    return struct.unpack('<d', raw[offset:offset+8])[0]

def analyze_data(name, va):
    print(f"\n{'='*60}")
    print(f"{name} (VA=0x{va:x})")
    print(f"{'='*60}")
    
    offset = va_to_file_offset(va)
    if offset is None:
        print(f"  ERROR: Cannot map VA to file offset")
        return
    
    print(f"  File offset: 0x{offset:x}")
    
    for i in range(0, min(400, len(raw) - offset), 8):
        val = read_u64(offset + i)
        if val is None:
            break
        
        if is_code_ptr(val):
            # Decode what this code function might be
            func_off = va_to_file_offset(val)
            if func_off:
                first_bytes = raw[func_off:func_off+4]
                desc = f"CODE (bytes: {first_bytes.hex()})"
            else:
                desc = "CODE"
            print(f"  +0x{i:03x}: 0x{val:016x} → {desc}")
        elif val == 0:
            print(f"  +0x{i:03x}: NULL")
        elif val < 0x100000:
            print(f"  +0x{i:03x}: int = {val}")
        else:
            # Try as double
            d = read_double(offset + i)
            if d is not None and 1e-6 < abs(d) < 1e10 and d == d:
                print(f"  +0x{i:03x}: double = {d:.6f}")
            else:
                # Could be RVA/VA pointer to another data section
                print(f"  +0x{i:03x}: 0x{val:016x}")

# Analyze each
analyze_data("FUN_ce8dd0 (data table/VMT)", 0x10e8dd0)
analyze_data("FUN_cf7550 (data table/VMT)", 0x10f7550)

# FUN_4772a0 — real code function
print(f"\n{'='*60}")
print("FUN_4772a0 (VA=0x8772a0) — .text code")
print(f"{'='*60}")

offset = va_to_file_offset(0x8772a0)
chunk = raw[offset:offset+3000]

# Extract all data references from lea/mov instructions
refs = []
for i in range(len(chunk) - 7):
    # lea reg, [rip+disp32]
    if chunk[i] == 0x48 and chunk[i+1] == 0x8d:
        modrm = chunk[i+2]
        if (modrm >> 6) & 3 == 0 and (modrm & 7) == 5:
            disp = struct.unpack('<i', chunk[i+3:i+7])[0]
            target = 0x8772a0 + i + 7 + disp
            regs = {0:'rax',1:'rcx',2:'rdx',3:'rbx',6:'rsi',7:'rdi'}
            reg = regs.get((modrm >> 3) & 7, f'r{(modrm>>3)&7}')
            refs.append((i, reg, target, 'lea'))
    
    # mov reg, [rip+disp32]
    if chunk[i] == 0x48 and chunk[i+1] == 0x8b:
        modrm = chunk[i+2]
        if (modrm >> 6) & 3 == 0 and (modrm & 7) == 5:
            disp = struct.unpack('<i', chunk[i+3:i+7])[0]
            target = 0x8772a0 + i + 7 + disp
            regs = {0:'rax',1:'rcx',2:'rdx',3:'rbx',6:'rsi',7:'rdi'}
            reg = regs.get((modrm >> 3) & 7, f'r{(modrm>>3)&7}')
            refs.append((i, reg, target, 'mov'))

print(f"\n  {len(refs)} data references found:")
for pos, reg, target, kind in refs[:50]:
    toff = va_to_file_offset(target)
    if toff:
        d = read_double(toff)
        if d is not None and 1e-10 < abs(d) < 1e10 and d == d:
            val_str = f"double {d:.6f}"
        else:
            v = read_u64(toff)
            if v and is_code_ptr(v):
                val_str = f"→ code 0x{v:x}"
            else:
                val_str = f"raw 0x{v:016x}" if v else "0"
    else:
        val_str = "?"
    print(f"  0x{0x8772a0+pos:x}: {kind} {reg}, [0x{target:x}] → {val_str}")
