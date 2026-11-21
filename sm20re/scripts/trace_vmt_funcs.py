#!/usr/bin/env python3
"""
For each real code pointer from the VMTs, extract all RIP-relative
data references. These will tell us what data the functions access.
"""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

import lief
binary = lief.parse("/Users/mini/sm20-re/sm20.exe")
image_base = binary.optional_header.imagebase

def va_to_file_offset(va):
    for s in binary.sections:
        if s.virtual_address <= (va - image_base) < s.virtual_address + s.sizeof_raw_data:
            return s.offset + (va - image_base - s.virtual_address)
    return None

def get_section_name(va):
    for s in binary.sections:
        if s.virtual_address <= (va - image_base) < s.virtual_address + s.virtual_size:
            return s.name
    return "?"

# Real function entry points from VMT analysis
functions = {
    0x00ce5c03: "VMT method (near ce8dd0)",
    0x00ce5c25: "VMT method",
    0x00ce5c26: "VMT method",
    0x00ce5c70: "VMT method (prologue+ret+13, small function)",
    0x00ce5c80: "VMT method (push rbp; push rbx; sub rsp,28h)",
}

for func_va, desc in sorted(functions.items()):
    foff = va_to_file_offset(func_va)
    if foff is None:
        continue
    
    print(f"\n{'='*60}")
    print(f"Function 0x{func_va:x}: {desc}")
    print(f"{'='*60}")
    
    # Read up to 4KB
    func_bytes = raw[foff:foff+4096]
    
    # Find function end (look for ret C3 or CC padding)
    func_size = len(func_bytes)
    for i in range(len(func_bytes)):
        if func_bytes[i] == 0xCC:
            func_size = i
            break
    
    func_bytes = func_bytes[:func_size]
    print(f"Size: ~{func_size} bytes")
    
    # Extract all RIP-relative references
    refs = []
    for i in range(len(func_bytes) - 7):
        # lea/mov with RIP-relative
        if func_bytes[i] in (0x48, 0x4c) and func_bytes[i+1] in (0x8d, 0x8b, 0x89, 0x3b, 0x39):
            modrm = func_bytes[i+2]
            mod = (modrm >> 6) & 3
            rm = modrm & 7
            if mod == 0 and rm == 5:
                disp = struct.unpack('<i', func_bytes[i+3:i+7])[0]
                target = func_va + i + 7 + disp
                regs = {0:'rax',1:'rcx',2:'rdx',3:'rbx',4:'rsp',5:'rbp',6:'rsi',7:'rdi'}
                prefix = 'r' if func_bytes[i] == 0x4c else ''
                reg = prefix + regs.get((modrm >> 3) & 7, '?')
                ops = {0x8d:'lea', 0x8b:'mov', 0x89:'mov_store', 0x3b:'cmp', 0x39:'cmp_store'}
                op = ops.get(func_bytes[i+1], f'op_{func_bytes[i+1]:02x}')
                section = get_section_name(target)
                
                # Try to read the value
                toff = va_to_file_offset(target)
                val_str = ""
                if toff and toff + 8 <= len(raw):
                    v = struct.unpack('<Q', raw[toff:toff+8])[0]
                    d = struct.unpack('<d', raw[toff:toff+8])[0]
                    if 1e-10 < abs(d) < 1e10 and d == d:
                        val_str = f"double={d:.6f}"
                    elif v == 0:
                        val_str = "NULL/0"
                    else:
                        val_str = f"0x{v:x}"
                
                refs.append((i, op, reg, target, section, val_str))
        
        # cmp/mov with immediate RIP-relative
        if func_bytes[i] in (0x80, 0x83):
            modrm = func_bytes[i+1]
            mod = (modrm >> 6) & 3
            rm = modrm & 7
            if mod == 0 and rm == 5:
                disp = struct.unpack('<i', func_bytes[i+2:i+6])[0]
                target = func_va + i + 6 + disp
                section = get_section_name(target)
                toff = va_to_file_offset(target)
                val_str = ""
                if toff and toff + 1 <= len(raw):
                    val_str = f"byte={raw[toff]}"
                refs.append((i, "cmp/add/mov_byte", "mem", target, section, val_str))
    
    # Deduplicate and print
    seen = set()
    for offset, op, reg, target, section, val_str in refs:
        key = (target, op)
        if key in seen:
            continue
        seen.add(key)
        print(f"  0x{func_va+offset:x}: {op:12s} {reg:4s}, [0x{target:x}] ({section}) {val_str}")
