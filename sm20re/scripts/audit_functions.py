#!/usr/bin/env python3
"""
Audit all 55 decompiled functions: which are real .text code vs .data VMTs?
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

def get_section(rva):
    for s in binary.sections:
        if s.virtual_address <= rva < s.virtual_address + s.virtual_size:
            return s.name
    return "???"

# Extract addresses from filenames
import os, re

decompiled_dir = "/Users/mini/sm20-re/sm20_decompiled"
files = sorted(os.listdir(decompiled_dir))

results = {"code": [], "data": [], "unknown": []}

for f in files:
    m = re.match(r'func_0+(\w+)\.c', f)
    if not m:
        continue
    addr_hex = m.group(1)
    rva = int(addr_hex, 16)
    va = image_base + rva
    section = get_section(rva)
    
    # Check if first bytes look like code or data
    foff = rva_to_file_offset(rva)
    if foff is None:
        results["unknown"].append((f, rva, section))
        continue
    
    first_bytes = raw[foff:foff+4]
    
    if section == ".text":
        # It's in code section - likely real code
        results["code"].append((f, rva, section))
    elif section == ".data":
        # Check if it looks like code (executable)
        # Common first bytes: 40 55 48 89 (push rbp; mov [rsp+8], rbp) etc.
        # VMT first bytes: small integers + pointers
        results["data"].append((f, rva, section, first_bytes.hex()))
    else:
        results["unknown"].append((f, rva, section))

print("REAL CODE (.text section):")
print(f"  {len(results['code'])} functions:")
for f, rva, sec in results["code"]:
    print(f"    {f} (RVA 0x{rva:x})")

print(f"\nDATA/VMT (.data section) — FALSE POSITIVES:")
print(f"  {len(results['data'])} entries:")
for entry in results["data"]:
    f, rva, sec, fb = entry
    print(f"    {f} (RVA 0x{rva:x}) first 4 bytes: {fb}")

print(f"\nUNKNOWN:")
for f, rva, sec in results["unknown"]:
    print(f"    {f} (RVA 0x{rva:x}) in {sec}")
