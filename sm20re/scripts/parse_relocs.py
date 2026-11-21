#!/usr/bin/env python3
"""
Parse PE relocation table to find code that references BSS addresses.
Relocations patch absolute addresses into code/data at load time.
"""

import struct

with open("/Users/mini/sm20-re/sm20.exe", "rb") as f:
    raw = f.read()

import lief
binary = lief.parse("/Users/mini/sm20-re/sm20.exe")
image_base = binary.optional_header.imagebase

# BSS range
bss_start = image_base + 0x1127000
bss_end = image_base + 0x1297688

# Get relocations
print(f"Image base: 0x{image_base:x}")
print(f"BSS range: 0x{bss_start:x} - 0x{bss_end:x}")
print()

# Parse relocations using lief
relocs = binary.relocations
print(f"Total relocations: {len(relocs)}")

# Find relocations that point into BSS
bss_relocs = []
for reloc in relocs:
    if bss_start <= reloc.address <= bss_end:
        rva = reloc.address - image_base
        bss_relocs.append((reloc.address, rva))

print(f"Relocations pointing to BSS: {len(bss_relocs)}")

# Show unique pages (relocations are organized by page)
if bss_relocs:
    print("\nBSS relocation details:")
    for addr, rva in sorted(bss_relocs)[:30]:
        # Find which section contains the relocation target
        section = "?"
        for s in binary.sections:
            if s.virtual_address <= (addr - image_base) < s.virtual_address + s.virtual_size:
                section = s.name
                break
        print(f"  RVA 0x{rva:x} (VA 0x{addr:x}) → in {section}")
    
    # Now find what code/data REFERENCES these relocations
    # The relocation is at the target address (where the pointer lives)
    # We need to find code that reads from/writes to those addresses
    
    # Actually, in PE, relocations are where the FIXUP happens, not where
    # the reference is. The relocation target IS the BSS address.
    # The relocation itself is a patch at some location in code/data
    # that will contain the BSS address after loading.
    
    # Let me re-interpret: lief relocations have .address = where the fixup is applied
    # .content or similar = the target value
    print("\nRelocation patch locations (where BSS addresses are stored):")

print("\nLet me check the relocation entries more carefully...")
for reloc in relocs:
    if reloc.address >= bss_start and reloc.address <= bss_end:
        # This relocation's target is in BSS
        # The size tells us the fixup type
        if hasattr(reloc, 'size') and reloc.size == 8:
            print(f"  Fixup at 0x{reloc.address:x}: size={reloc.size}")
        elif hasattr(reloc, 'content'):
            print(f"  Fixup at 0x{reloc.address:x}: content=0x{reloc.content:x}")

# Actually let's look at the raw relocation data
# Relocation directory: VA=0x12a4000, offset=0xd2c800
reloc_dir_offset = 0xd2c800
reloc_dir_size = 0x78200

# Parse the relocation directory
pos = reloc_dir_offset
block_count = 0
bss_patch_locations = []

while pos < reloc_dir_offset + reloc_dir_size:
    page_rva = struct.unpack('<I', raw[pos:pos+4])[0]
    block_size = struct.unpack('<I', raw[pos+4:pos+8])[0]
    
    if block_size == 0:
        break
    
    num_entries = (block_size - 8) // 2
    
    for i in range(num_entries):
        entry = struct.unpack('<H', raw[pos+8+i*2:pos+10+i*2])[0]
        entry_type = entry >> 12
        entry_offset = entry & 0xFFF
        
        if entry_type == 10:  # IMAGE_REL_BASED_DIR64 (8-byte absolute)
            target_rva = page_rva + entry_offset
            target_va = image_base + target_rva
            
            # Check if this patch location is in BSS
            if bss_start <= target_va <= bss_end:
                bss_patch_locations.append((target_va, target_rva))
    
    pos += block_size
    block_count += 1

print(f"\nTotal relocation blocks: {block_count}")
print(f"Patch locations in BSS: {len(bss_patch_locations)}")

# Show a few
for va, rva in sorted(bss_patch_locations)[:20]:
    print(f"  VA 0x{va:x} (RVA 0x{rva:x})")
