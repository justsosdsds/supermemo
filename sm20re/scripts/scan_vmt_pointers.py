#!/usr/bin/env python3
"""
The .data VMT entries contain pointers to REAL .text code.
Extract all code pointers from the algorithm-related .data structures
and analyze what they actually do.
"""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

import lief
binary = lief.parse("/Users/mini/sm20-re/sm20.exe")
image_base = binary.optional_header.imagebase

text_va_start = image_base + 0x1000
text_va_end = text_va_start + 0xc33400

def va_to_file_offset(va):
    for s in binary.sections:
        if s.virtual_address <= (va - image_base) < s.virtual_address + s.sizeof_raw_data:
            return s.offset + (va - image_base - s.virtual_address)
    return None

def rva_to_file_offset(rva):
    return va_to_file_offset(image_base + rva)

def is_code(va):
    return text_va_start <= va <= text_va_end

# Scan the entire .data section for code pointers
data_section = None
for s in binary.sections:
    if s.name == ".data":
        data_section = s
        break

data_foff = data_section.offset
data_size = data_section.sizeof_raw_data
data_chunk = raw[data_foff:data_foff + data_size]

print(f"Scanning .data section ({data_size} bytes) for code pointers...")
print(f"Code range: 0x{text_va_start:x} - 0x{text_va_end:x}")
print()

# Find all unique code pointers in .data
code_ptrs = set()
for i in range(0, len(data_chunk) - 7, 4):
    val = struct.unpack('<Q', data_chunk[i:i+8])[0]
    if is_code(val):
        code_ptrs.add(val)

# Also check aligned on 8 bytes
for i in range(0, len(data_chunk) - 7, 8):
    val = struct.unpack('<Q', data_chunk[i:i+8])[0]
    if is_code(val):
        code_ptrs.add(val)

print(f"Found {len(code_ptrs)} unique code pointers in .data")

# Now for each code pointer, check if it references any of the 
# key .rsrc string addresses via RIP-relative addressing
# Key strings in .rsrc
rsrc_strings = {
    "AlgSM20": 0x17fdfed,
    "AlgSM20Ext": 0x17febb1,
    "NewUFactor": None,  # was in .text, need correct VA
    "GetNextRepetitionDayNo": None,
    "SM20MetricCount": None,
    "SM20MetricResult": None,
    "FinalSM20MetricResult": None,
    "FillUpPostLapseIntervalArray": None,
}

# Find the .text string VAs properly
text_strings = {}
for name, needle in [
    ("NewUFactor", b"NewUFactor"),
    ("GetNextRepetitionDayNo", b"GetNextRepetitionDayNo"),
    ("SM20MetricCount", b"SM20MetricCount"),
    ("SM20MetricSum", b"SM20MetricSum"),
    ("SM20MetricResult", b"SM20MetricResult"),
    ("FinalSM20MetricResult", b"FinalSM20MetricResult"),
    ("FillUpPostLapseIntervalArray", b"FillUpPostLapseIntervalArray"),
]:
    pos = raw.find(needle)
    if pos >= 0:
        for s in binary.sections:
            if s.offset <= pos < s.offset + s.sizeof_raw_data:
                va = image_base + s.virtual_address + (pos - s.offset)
                text_strings[name] = va
                rsrc_strings[name] = va
                break

all_string_vas = {k: v for k, v in rsrc_strings.items() if v is not None}
print(f"\nKey string VAs: {len(all_string_vas)}")
for name, va in all_string_vas.items():
    print(f"  {name}: 0x{va:x}")

# For each code pointer, check if the function references any algorithm strings
print(f"\nChecking {len(code_ptrs)} code pointers for algorithm string references...")
algo_functions = []

for code_va in sorted(code_ptrs):
    foff = va_to_file_offset(code_va)
    if foff is None:
        continue
    
    # Read function bytes (up to 2KB)
    func_bytes = raw[foff:foff + 2048]
    
    # Look for RIP-relative references to string VAs
    for i in range(len(func_bytes) - 7):
        if func_bytes[i] in (0x48, 0x4c) and func_bytes[i+1] in (0x8d, 0x8b):
            modrm = func_bytes[i+2]
            mod = (modrm >> 6) & 3
            rm = modrm & 7
            if mod == 0 and rm == 5:
                disp = struct.unpack('<i', func_bytes[i+3:i+7])[0]
                target = code_va + i + 7 + disp
                
                for name, str_va in all_string_vas.items():
                    if abs(target - str_va) < 32:
                        regs = {0:'rax',1:'rcx',2:'rdx',3:'rbx',4:'rsp',5:'rbp',6:'rsi',7:'rdi'}
                        reg = regs.get((modrm >> 3) & 7, '?')
                        algo_functions.append((code_va, name, target - str_va))
                        break

print(f"\nFound {len(algo_functions)} code→string references:")
for code_va, name, delta in algo_functions:
    rva = code_va - image_base
    print(f"  0x{code_va:x} (RVA 0x{rva:x}) → '{name}' (delta={delta:+d})")
