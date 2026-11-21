#!/usr/bin/env python3
"""
SM20 Runtime Memory Dumper — dump algorithm state before and after
repetitions to reverse-engineer the algorithm behavior.
"""
import subprocess, struct, json, time, sys, os

REMOTE = "ubuntu@100.98.48.78"
WINE_CMD = "WINEDEBUG=-all WINEPREFIX=/home/ubuntu/.wine wine"
SM20_PATH = "/home/ubuntu/sm20pkg/bin/sm20.exe"
COLLECTION = "/home/ubuntu/My Knowledge"

IMAGE_BASE = 0x400000

def ssh_run(cmd, timeout=15):
    result = subprocess.run(
        ["ssh", "-o", "ConnectTimeout=5", REMOTE, cmd],
        capture_output=True, text=True, timeout=timeout
    )
    return result.stdout.strip(), result.stderr.strip(), result.returncode

def find_sm20_pid():
    out, err, rc = ssh_run("pgrep -f sm20.exe")
    if rc == 0 and out.strip():
        pids = [int(p) for p in out.strip().split('\n') if p.strip()]
        return pids
    return []

def read_mem(pid, rva, size):
    """Read memory at RVA from Wine process via /proc/pid/mem"""
    # Convert RVA to PE virtual address
    va = IMAGE_BASE + rva
    cmd = f"python3 -c \""
    cmd += "import struct,sys;"
    cmd += f"f=open('/proc/{pid}/mem','rb');"
    cmd += f"f.seek({va});"
    cmd += f"d=f.read({size});"
    cmd += "import base64;"
    cmd += "sys.stdout.write(base64.b64encode(d).decode());"
    cmd += "f.close()\""
    
    out, err, rc = ssh_run(cmd, timeout=10)
    if rc != 0 or not out:
        return None
    return base64.b64decode(out)

import base64

def read_double(pid, rva):
    data = read_mem(pid, rva, 8)
    if data and len(data) == 8:
        return struct.unpack('<d', data)[0]
    return None

def read_u64(pid, rva):
    data = read_mem(pid, rva, 8)
    if data and len(data) == 8:
        return struct.unpack('<Q', data)[0]
    return None

def read_u8(pid, rva):
    data = read_mem(pid, rva, 1)
    if data and len(data) == 1:
        return data[0]
    return None

# Data structure addresses (RVAs)
ALG_VERSION = 0x122e192
INTERVAL_MATRIX_PTR = 0x11240a8  # pointer to interval_matrix (21^3 doubles)
COUNT_MATRIX_PTR = 0x11228c8     # pointer to count_matrix (21^3 ints?)
INTERVAL_TABLE_PTR = 0x1124138   # pointer to U-factor table
POST_LAPSE1_PTR = 0x11238e8     # pointer to post-lapse table 1
XOR_KEY = 0x00ccf1a0

def dump_algorithm_state(pid):
    """Dump the complete algorithm state from a running SM20 instance."""
    state = {}
    
    # Algorithm version
    ver = read_u8(pid, ALG_VERSION)
    state['alg_version'] = ver
    
    # XOR key
    xor = read_u64(pid, XOR_KEY)
    state['xor_key'] = f"0x{xor:016x}" if xor else "NULL"
    
    # Matrix pointers (these point to heap-allocated arrays)
    im_ptr = read_u64(pid, INTERVAL_MATRIX_PTR)
    cm_ptr = read_u64(pid, COUNT_MATRIX_PTR)
    it_ptr = read_u64(pid, INTERVAL_TABLE_PTR)
    pl_ptr = read_u64(pid, POST_LAPSE1_PTR)
    
    state['interval_matrix_ptr'] = f"0x{im_ptr:x}" if im_ptr else "NULL"
    state['count_matrix_ptr'] = f"0x{cm_ptr:x}" if cm_ptr else "NULL"
    state['interval_table_ptr'] = f"0x{it_ptr:x}" if it_ptr else "NULL"
    state['post_lapse1_ptr'] = f"0x{pl_ptr:x}" if pl_ptr else "NULL"
    
    return state

# Main
print("SM20 Runtime Memory Analysis")
print("=" * 60)

# Check if SM20 is running
pids = find_sm20_pid()
if not pids:
    print("SM20 is not running. Start it with:")
    print(f"  {WINE_CMD} '{SM20_PATH}'")
    print()
    print("Trying to start SM20...")
    # Start SM20 in background
    ssh_run(f"nohup {WINE_CMD} '{SM20_PATH}' > /tmp/sm20.log 2>&1 &")
    time.sleep(5)
    pids = find_sm20_pid()
    
if pids:
    pid = pids[0]
    print(f"SM20 running (PID {pid})")
    
    # Dump state
    state = dump_algorithm_state(pid)
    print(f"\nAlgorithm State:")
    for k, v in state.items():
        print(f"  {k}: {v}")
    
    # If pointers are valid, dump matrix data
    im_ptr_hex = state['interval_matrix_ptr']
    if im_ptr_hex != "NULL":
        im_ptr = int(im_ptr_hex, 16)
        # Read first few interval matrix entries
        print(f"\n  Interval Matrix (first 10 entries at 0x{im_ptr:x}):")
        for i in range(10):
            # Each entry is a double (8 bytes)
            data = read_mem(pid, im_ptr - IMAGE_BASE + i*8, 8)
            if data:
                val = struct.unpack('<d', data)[0]
                print(f"    [{i}]: {val:.6f}")
else:
    print("Could not start/find SM20")
