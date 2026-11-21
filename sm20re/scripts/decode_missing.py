#!/usr/bin/env python3
"""
Disassemble FUN_ce8dd0, FUN_cf7550, FUN_4772a0 from sm20.exe.
Uses lief for PE parsing and capstone for disassembly.
"""

import lief
import struct

binary = lief.parse("/Users/mini/sm20-re/sm20.exe")

# Get the .text section for RVA to file offset conversion
text_section = None
for s in binary.sections:
    if s.name == ".text":
        text_section = s
        break

print(f".text section: VA=0x{text_section.virtual_address:x}, size=0x{text_section.size:x}, offset=0x{text_section.offset:x}")

# Function RVA to file offset
def rva_to_offset(rva):
    for s in binary.sections:
        if s.virtual_address <= rva < s.virtual_address + s.size:
            return s.offset + (rva - s.virtual_address)
    return None

def rva_to_va(rva):
    return binary.optional_header.imagebase + rva

# Extract function bytes
functions = {
    "FUN_ce8dd0": 0x00ce8dd0,  # rounding/adjustment
    "FUN_cf7550": 0x00cf7550,  # stability pre-transform
    "FUN_4772a0": 0x004772a0,  # A-factor transform
}

# Get raw bytes from the binary
with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw_bytes = f.read()

for name, rva in functions.items():
    offset = rva_to_offset(rva)
    va = rva_to_va(rva)
    if offset is None:
        print(f"\n{name}: RVA 0x{rva:x} not found in any section!")
        continue
    
    # Extract a generous chunk (1KB should be enough)
    chunk = raw_bytes[offset:offset+1024]
    
    print(f"\n{'='*60}")
    print(f"{name}: RVA=0x{rva:x}, VA=0x{va:x}, file_offset=0x{offset:x}")
    print(f"First 64 bytes (hex):")
    print(' '.join(f'{b:02x}' for b in chunk[:64]))
    print(f"\nFirst 64 bytes (asm-like interpretation):")
    
    # Print as x86-64 instructions (manual for now, will use capstone)
    for i in range(0, min(64, len(chunk)), 1):
        pass
    
    # Also extract RIP-relative data references
    # Scan for 48 8d 05 (lea rax, [rip+disp32]) or 48 8b 05 (mov rax, [rip+disp32])
    print(f"\nRIP-relative references found:")
    for i in range(len(chunk) - 7):
        # lea reg, [rip+disp32] = 48 8d XX disp32 where XX encodes the register
        if chunk[i] == 0x48 and chunk[i+1] == 0x8d:
            modrm = chunk[i+2]
            mod = (modrm >> 6) & 3
            rm = modrm & 7
            if mod == 0 and rm == 5:  # RIP-relative
                disp = struct.unpack('<i', chunk[i+3:i+7])[0]
                target_va = va + i + 7 + disp
                reg_names = {0:'rax',1:'rcx',2:'rdx',3:'rbx',4:'rsp',5:'rbp',6:'rsi',7:'rdi'}
                reg = reg_names.get((modrm >> 3) & 7, '?')
                print(f"  0x{va+i:x}: lea {reg}, [0x{target_va:x}]")
        
        # mov reg, [rip+disp32] = 48 8b XX disp32
        if chunk[i] == 0x48 and chunk[i+1] == 0x8b:
            modrm = chunk[i+2]
            mod = (modrm >> 6) & 3
            rm = modrm & 7
            if mod == 0 and rm == 5:  # RIP-relative
                disp = struct.unpack('<i', chunk[i+3:i+7])[0]
                target_va = va + i + 7 + disp
                reg_names = {0:'rax',1:'rcx',2:'rdx',3:'rbx',4:'rsp',5:'rbp',6:'rsi',7:'rdi'}
                reg = reg_names.get((modrm >> 3) & 7, '?')
                print(f"  0x{va+i:x}: mov {reg}, [0x{target_va:x}]")

# Now try to install capstone for proper disassembly
