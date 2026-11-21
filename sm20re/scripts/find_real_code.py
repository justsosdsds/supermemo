#!/usr/bin/env python3
"""
Find actual code that references algorithm strings in .rsrc.
Search ALL of .text for cross-references to key strings.
"""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

import lief
binary = lief.parse("/Users/mini/sm20-re/sm20.exe")
image_base = binary.optional_header.imagebase

def rva_to_file_offset(rva):
    for s in binary.sections:
        if s.virtual_address <= rva < s.virtual_address + s.sizeof_raw_data:
            return s.offset + (rva - s.virtual_address)
    return None

def va_to_file_offset(va):
    return rva_to_file_offset(va - image_base)

# Key .rsrc strings (we know these from earlier analysis)
key_strings = {
    "AlgSM20": None,
    "AlgSM20Ext": None,
    "NewUFactor": None,
    "GetNextRepetitionDayNo": None,
    "SM20MetricCount": None,
    "SM20MetricSum": None,
    "SM20MetricResult": None,
    "FinalSM20MetricResult": None,
    "FillUpPostLapseIntervalArray": None,
}

# Find these strings in the binary
for name in key_strings:
    needle = name.encode('ascii')
    pos = raw.find(needle)
    if pos >= 0:
        va = pos  # approximate (need to adjust for section mapping)
        # The .rsrc section: VA=0x12a3000, offset=0xe21c00
        rsrc_va = 0x12a3000
        rsrc_off = 0xe21c00
        if pos >= rsrc_off and pos < rsrc_off + 0xbffa00:
            va = rsrc_va + (pos - rsrc_off)
        key_strings[name] = va
        print(f"Found '{name}' at file offset 0x{pos:x}, VA ~0x{va:x}")

print()

# Now search .text for references to these string addresses
# In x64 Delphi, strings are typically referenced via:
# 1. Direct RIP-relative LEA (most common)
# 2. Through global pointers (mov reg, [ptr]; ... push reg)

text_va_start = image_base + 0x1000
text_va_end = text_va_start + 0xc33400
text_file_start = 0x400

chunk = raw[text_file_start:text_file_start + 0xc33400]

print("Searching .text for references to algorithm strings...")
print("=" * 60)

# Build a set of target VAs
target_vas = set()
for name, va in key_strings.items():
    if va:
        # The pointer to the string could be at any position, but
        # typically Delphi stores the VA of the string literal
        # Also check nearby VAs (string might be preceded by length byte)
        for delta in range(-16, 17, 4):
            target_vas.add(va + delta)

print(f"Searching for ~{len(target_vas)} target VAs in {0xc33400} bytes of code...")

# Scan for LEA instructions referencing our targets
# Pattern: [REX] 8d [ModRM: mod=00, rm=101 (RIP-relative)] [disp32]
# Or mov reg, [rip+disp32]: [REX] 8b [ModRM] [disp32]
ref_count = 0
for i in range(len(chunk) - 7):
    # Check for 48 8d or 48 8b or 4c 8d etc.
    if chunk[i] in (0x48, 0x4c) and chunk[i+1] in (0x8d, 0x8b):
        modrm = chunk[i+2]
        mod = (modrm >> 6) & 3
        rm = modrm & 7
        if mod == 0 and rm == 5:  # RIP-relative
            disp = struct.unpack('<i', chunk[i+3:i+7])[0]
            instr_va = text_va_start + i
            target_va = instr_va + 7 + disp
            
            # Check if this target is near any of our key strings
            for name, str_va in key_strings.items():
                if str_va and abs(target_va - str_va) < 16:
                    regs = {0:'rax',1:'rcx',2:'rdx',3:'rbx',4:'rsp',5:'rbp',6:'rsi',7:'rdi'}
                    prefix = 'r' if chunk[i] == 0x4c else ''
                    reg = prefix + regs.get((modrm >> 3) & 7, '?')
                    op = 'lea' if chunk[i+1] == 0x8d else 'mov'
                    print(f"  0x{instr_va:x}: {op} {reg}, [0x{target_va:x}] → near '{name}' (delta={target_va - str_va})")
                    ref_count += 1

# Also scan for the string address as a 64-bit immediate
print(f"\n  Found {ref_count} RIP-relative references")

# Scan for 64-bit immediate comparisons/assignments
# movabs reg, imm64: REX.B + B8+rd + imm64
print("\nSearching for movabs patterns...")
for i in range(len(chunk) - 10):
    # 48 B8+rd = movabs rax, imm64
    if chunk[i] == 0x48 and (0xb8 <= chunk[i+1] <= 0xbf):
        imm = struct.unpack('<Q', chunk[i+2:i+10])[0]
        for name, str_va in key_strings.items():
            if str_va and imm == str_va:
                rd = chunk[i+1] & 7
                regs = ['rax','rcx','rdx','rbx','rsp','rbp','rsi','rdi']
                print(f"  0x{text_va_start+i:x}: movabs {regs[rd]}, 0x{imm:x} → '{name}'")
