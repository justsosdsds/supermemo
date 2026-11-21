#!/usr/bin/env python3
"""
Parse PE relocation table to find code/data that references BSS globals.
"""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

import lief
binary = lief.parse("/Users/mini/sm20-re/sm20.exe")
image_base = binary.optional_header.imagebase

bss_start_rva = 0xd27000
bss_end_rva = 0xd27000 + 0x179688  # from section info

# Parse relocation directory raw
reloc_dir_offset = 0xd2c800
reloc_dir_size = 0x78200

pos = reloc_dir_offset
block_count = 0

# Collect all DIR64 (type 10) relocation patch sites
all_patches = []
bss_patches = []

while pos < reloc_dir_offset + reloc_dir_size and pos + 8 <= len(raw):
    page_rva = struct.unpack('<I', raw[pos:pos+4])[0]
    block_size = struct.unpack('<I', raw[pos+4:pos+8])[0]
    
    if block_size == 0 or block_size > 0x10000:
        break
    
    num_entries = (block_size - 8) // 2
    
    for i in range(num_entries):
        if pos + 8 + i*2 + 2 > len(raw):
            break
        entry = struct.unpack('<H', raw[pos+8+i*2:pos+10+i*2])[0]
        entry_type = entry >> 12
        entry_offset = entry & 0xFFF
        
        if entry_type == 10:  # IMAGE_REL_BASED_DIR64
            patch_rva = page_rva + entry_offset
            all_patches.append(patch_rva)
            
            if bss_start_rva <= patch_rva < bss_end_rva:
                bss_patches.append(patch_rva)
    
    pos += block_size
    block_count += 1

print(f"Total relocation blocks: {block_count}")
print(f"Total DIR64 patches: {len(all_patches)}")
print(f"Patches in BSS: {len(bss_patches)}")

# The patches in BSS are where the actual BSS pointers are initialized
# These are likely global variable pointers set by the runtime
# The RELOCATION itself tells us the LOCATION of the patch (in BSS)
# NOT the code that writes to them.

# But wait - the relocation table tells us where 8-byte absolute addresses
# need to be fixed up at load time. If a patch is at BSS address X,
# it means some code/data somewhere has a pointer TO BSS address X.
# 
# We need the INVERSE: find patches that are NOT in BSS but whose
# target (the value that will be written) is a BSS address.
# 
# In PE relocations, the "address" field IS the patch location.
# The relocation doesn't store the target - it stores the location
# where an absolute address will be written, and the linker/loader
# adds image_base to the pre-stored RVA.
#
# So at runtime: [patch_location] = stored_RVA + image_base
# The stored_RVA is in the file at the patch location.
#
# Let's read the stored values from the file!

print("\nReading pre-relocation values at patch locations...")
bss_value_patches = []

for patch_rva in all_patches[:50000]:
    # Map RVA to file offset
    foff = None
    for s in binary.sections:
        if s.virtual_address <= patch_rva < s.virtual_address + s.sizeof_raw_data:
            foff = s.offset + (patch_rva - s.virtual_address)
            break
    
    if foff is None or foff + 8 > len(raw):
        continue
    
    stored_rva = struct.unpack('<Q', raw[foff:foff+8])[0]
    
    # Check if the stored value points into BSS
    if bss_start_rva <= stored_rva < bss_end_rva:
        bss_value_patches.append((patch_rva, stored_rva, foff))

print(f"Patches whose VALUE points to BSS: {len(bss_value_patches)}")

# Group by target BSS address
from collections import defaultdict
bss_targets = defaultdict(list)
for patch_rva, target_rva, foff in bss_value_patches:
    section = "?"
    for s in binary.sections:
        if s.virtual_address <= patch_rva < s.virtual_address + s.virtual_size:
            section = s.name
            break
    bss_targets[target_rva].append((patch_rva, section))

print(f"\nUnique BSS targets: {len(bss_targets)}")
for target_rva, patches in sorted(bss_targets.items()):
    # Identify known pointers
    known = ""
    known_map = {
        0x11240a8: "interval_matrix_ptr",
        0x11228c8: "count_matrix_ptr",
        0x1124138: "interval_table_ptr",
        0x11238e8: "post_lapse1_ptr",
        0x11250c8: "alt_table_ptr",
        0x11239f0: "matrix2_ptr",
        0x122e192: "alg_version_byte",
    }
    known = known_map.get(target_rva, "")
    
    # Find patches in .text (these are the code locations!)
    text_patches = [(rva, sec) for rva, sec in patches if sec == ".text"]
    data_patches = [(rva, sec) for rva, sec in patches if sec == ".data"]
    
    print(f"\n  BSS 0x{target_rva:x} {known}:")
    if text_patches:
        print(f"    Referenced from .text ({len(text_patches)} locations):")
        for rva, sec in text_patches[:10]:
            print(f"      RVA 0x{rva:x}")
    if data_patches:
        print(f"    Referenced from .data ({len(data_patches)} locations):")
        for rva, sec in data_patches[:10]:
            print(f"      RVA 0x{rva:x}")
