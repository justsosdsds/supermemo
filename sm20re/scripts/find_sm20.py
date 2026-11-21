#!/usr/bin/env python3
"""
Extract and decode FUN_ce8dd0, FUN_cf7550, FUN_4772a0 from sm20.exe
using lief for PE parsing and capstone for disassembly.
"""

import lief
import struct
import sys

# Load binary
binary = lief.parse("/Users/mini/sm20inst.exe")  
# Actually we need sm20.exe, not the installer
# Let's check if we have the main exe

import os
sm20_paths = [
    "/Users/mini/sm20.exe",
    "/Users/mini/sm20-re/sm20.exe",
]
for p in sm20_paths:
    if os.path.exists(p):
        print(f"Found: {p} ({os.path.getsize(p)} bytes)")
    else:
        print(f"Not found: {p}")

# Try remote
import subprocess
result = subprocess.run(
    ["ssh", "ubuntu@100.98.48.78", 
     "ls -la /home/ubuntu/sm20pkg/bin/sm20.exe /home/ubuntu/.wine/drive_c/users/ubuntu/Local\\ Settings/Application\\ Data/Programs/SuperMemo/sm20.exe 2>/dev/null"],
    capture_output=True, text=True, timeout=10
)
print(f"\nRemote sm20.exe:\n{result.stdout}")
print(f"{result.stderr}")

# Check IE cache
result2 = subprocess.run(
    ["ssh", "ubuntu@100.98.48.78",
     "find /home/ubuntu/.wine -name 'sm20.exe' -type f 2>/dev/null | head -5"],
    capture_output=True, text=True, timeout=10
)
print(f"\nRemote find sm20.exe:\n{result2.stdout}")
