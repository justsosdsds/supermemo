#!/usr/bin/env python3
"""
Search the .reloc and .data sections for pointers to BSS addresses.
If interval_matrix_ptr (0x11240a8) is stored in .data, any code
that uses that .data location can be found via normal xref.
"""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

import lief
binary = lief.parse("/Users/mini/sm20-re/sm20.exe")
image_base = binary.optional_header.imagebase

# BSS addresses (these are in the 0x1127xxx - 0x1297xxx range)
bss_vas = {
    "interval_matrix_ptr": 0x11240a8,
    "count_matrix_ptr": 0x11228c8,
    "interval_table_ptr": 0x1124138,
    "post_lapse1_ptr": 0x11238e8,
    "alt_table_ptr": 0x11250c8,
    "matrix2_ptr": 0x11239f0,
}

# Search ALL sections for 8-byte values that match BSS addresses
print("Searching all sections for BSS address pointers:")
print("=" * 60)

for name, bss_va in sorted(bss_vas.items()):
    # The pointer value as stored in the file (RVA, not VA)
    target_rva = bss_va - image_base  # 0x11240a8 - 0x400000 = 0xd240a8
    
    # Search for this RVA as a 4-byte LE value (common in PE)
    target_bytes_32 = struct.pack('<I', target_rva)
    target_bytes_64 = struct.pack('<Q', bss_va)
    
    found = []
    for i in range(len(raw) - 8):
        # Check 64-bit match
        val = struct.unpack('<Q', raw[i:i+8])[0]
        if val == bss_va or val == image_base + target_rva:
            # Map this file offset back to VA
            va = None
            for s in binary.sections:
                if s.offset <= i < s.offset + s.sizeof_raw_data:
                    va = image_base + s.virtual_address + (i - s.offset)
                    section = s.name
                    break
            
            if va:
                found.append((va, section, val))
    
    # Also search for 32-bit RVA (common in relocations)
    for i in range(len(raw) - 4):
        val = struct.unpack('<I', raw[i:i+4])[0]
        if val == target_rva:
            va = None
            section = "?"
            for s in binary.sections:
                if s.offset <= i < s.offset + s.sizeof_raw_data:
                    va = image_base + s.virtual_address + (i - s.offset)
                    section = s.name
                    break
            if va and not any(abs(f[0] - va) < 8 for f in found):
                found.append((va, section, val))
    
    if found:
        print(f"\n  {name} (RVA 0x{target_rva:x}):")
        for va, section, val in found:
            rva = va - image_base
            print(f"    VA 0x{va:x} (RVA 0x{rva:x}) in {section}")
    else:
        print(f"\n  {name} (RVA 0x{target_rva:x}): NOT FOUND in file")
        print(f"    (BSS is zero-initialized — pointers set at runtime)")
