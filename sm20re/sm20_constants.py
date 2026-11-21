#!/usr/bin/env python3
"""
SM20 Algorithm Constants - Complete Runtime Extraction
======================================================
Extracted from sm20.exe (27MB PE32+ x86-64) running under Wine on Linux.
Base address: 0x400000 (no ASLR).
"""

# ==========================================
# 1. U-FACTOR INTERVAL TABLE (NewUFactor)
# ==========================================
# Pointer: PTR_DAT_01124138 -> runtime address
# 21 rows x 20 values each (row R=0..19 identical, R=20 all zeros)
# Built by FUN_00cd87f0, used by FUN_00cd6260 (matrix builder)
# Each row is a 20-element vector of U-factors indexed by D (difficulty 0-19)
# These are the "forgetting curve" multipliers

UFACTOR_TABLE = {
    # R=0..19 all have the same values:
    "R_0_to_19": [
        13.822076, 8.212571, 6.056511, 4.879609, 4.126662,
        3.598557, 3.205138, 2.899285, 2.653822, 2.451912,
        2.282528, 2.138131, 2.013379, 1.904376, 1.808207,
        1.722649, 1.645970, 1.576804, 1.514055, 1.456836
    ],
    # R=20 is all zeros (unused/terminator)
    "R_20": [0.0] * 20,
}

# ==========================================
# 2. VERSION 2 ALGORITHM CONSTANTS
# ==========================================
# FUN_00ccf070 (version 2 variant of algorithm dispatch)
# Address: 0xccf150 - 0xccf198
V2_CONSTANTS = {
    "c1": 9.29,       # 0xccf150
    "c2": 1.3,        # 0xccf158
    "c3": 1.0,        # 0xccf160
    "c4": -0.08,      # 0xccf168
    "c5": -0.31,      # 0xccf170
    "c6": 1.04,       # 0xccf178
    "c7": 0.07,       # 0xccf180
    "c8": -1.88,      # 0xccf188
    "c9": 1.58,       # 0xccf190
    "c10": 600.0,     # 0xccf198
}

# ==========================================
# 3. CORE COMPUTATION CONSTANTS
# ==========================================
# FUN_00ce1250 (main Bayesian-like weighted averaging)
V2_CORE = {
    "weight_base": 500.0,   # 0xce1820
    "min_count": 10.0,      # 0xce1828
    "max_weight": 1000.0,   # 0xce1830
    "cube_weight": 3.0,     # 0xce1838 (3x3x3 neighbor cube)
    "neutral_weight": 1.0,  # 0xce1840
}

# ==========================================
# 4. INITIAL VALUE CONSTANTS
# ==========================================
# FUN_00ce1900 (initial interval/stability computation)
INIT_VALUES = {
    "iv1": 15.0,      # 0xce1a00
    "iv2": 3.0,       # 0xce1a08
    "iv3": 1.0,       # 0xce1a10
    "iv4": -0.08,     # 0xce1a18
    "iv5": -0.35,     # 0xce1a20
    "iv6": -2.0,      # 0xce1a28
    "iv7": 2.25,      # 0xce1a30
    "iv8": 600.0,     # 0xce1a38
}

# ==========================================
# 5. PARAMETER RANGE CONSTANTS
# ==========================================
PARAM_RANGES = {
    "difficulty_max": 19,    # 0xcf70b8
    "repetition_max": 23,    # 0xcf71e8 (max repetitions tracked)
    "stability_max": 20,     # 0xcf73c0
    "stability_lookup_base": 2,  # 0xcf7450
    "stability_power_denom": 2.90396936502257,  # DAT_0127cb08 (BSS runtime, used by FUN_cf7330 and FUN_cf7420)
}

# ==========================================
# 6. VERSION DISPATCH
# ==========================================
# FUN_00ccfe80 dispatches based on DAT_0122e192
# Version 2 (FUN_00ccf070) - default, set by FUN_00ccd1e0
# Version 4 (FUN_00ccd8e0) - uses constant 1.0 at 0xccd908
# Version 6 (FUN_00ccfde0) - uses constant -0.0 at 0xccfe70
ALGO_VERSIONS = {
    2: {"func": "FUN_00ccf070", "constants": V2_CONSTANTS},
    4: {"func": "FUN_00ccd8e0", "constant": 1.0},
    6: {"func": "FUN_00ccfde0", "constant": -0.0},
}

# ==========================================
# 7. MATRIX DIMENSIONS
# ==========================================
MATRIX_DIMS = {
    # FUN_00cd6260 - Primary interval matrix builder
    "primary_interval": (21, 21, 21),  # R*441 + S*21 + D (doubles)
    "primary_count": (21, 21, 21),      # Same indexing (int32)
    
    # FUN_00cd41d0 - Post-lapse interval builder
    "post_lapse1": (20, 20, 36),        # R*720 + S*36 + D (doubles)
    
    # FUN_00cd7b60 - Post-lapse interval builder 2
    "post_lapse2": (25, 24),            # R*25 + S (doubles)
}

# ==========================================
# 8. FUNCTION ADDRESSES (PE VA)
# ==========================================
FUNCTIONS = {
    "algo_dispatch": 0x00ccfe80,
    "version_2": 0x00ccf070,
    "version_4": 0x00ccd8e0,
    "version_6": 0x00ccfde0,
    "core_compute": 0x00ce1250,
    "matrix_builder": 0x00cd6260,
    "post_lapse1": 0x00cd41d0,
    "post_lapse2": 0x00cd7b60,
    "weight_func": 0x00f6ae80,      # param_1/(param_1+param_2)
    "difficulty_conv": 0x00cf6fd0,   # -> 1..10 scale
    "stability_conv": 0x00cf7330,
    "repetition_conv": 0x00cf71c0,
    "a_factor_conv": 0x00cf7420,
    "interval_lookup": 0x00cd87f0,
    "new_ufactor": 0x00cd6260,       # builds U-factor table
    "set_version": 0x00ccd1e0,       # sets DAT_0122e192 = 2
}

# ==========================================
# 9. KEY DATA POINTERS (BSS globals)
# ==========================================
# These point to runtime-allocated matrices in the data section
DATA_POINTERS = {
    "interval_matrix": 0x011240a8,   # double[9261] (21^3)
    "count_matrix": 0x011228c8,       # int32[9261] (21^3)
    "interval_table": 0x01124138,     # double[441] (21*21 U-factors)
    "post_lapse_table1": 0x011238e8,  # double[14400] (20*20*36)
    "alt_table": 0x011250c8,          # double[600] (25*24)
    "matrix2": 0x011239f0,            # int32[9261] or similar
}

if __name__ == "__main__":
    import json
    print("SM20 Algorithm Constants - Runtime Extraction Summary")
    print("=" * 60)
    print(f"\nU-Factor Table (20 values):")
    for i, v in enumerate(UFACTOR_TABLE["R_0_to_19"]):
        print(f"  D={i:2d}: {v:.6f}")
    
    print(f"\nVersion 2 Constants:")
    for k, v in V2_CONSTANTS.items():
        print(f"  {k} = {v}")
    
    print(f"\nCore Computation Constants:")
    for k, v in V2_CORE.items():
        print(f"  {k} = {v}")
    
    print(f"\nInitial Value Constants:")
    for k, v in INIT_VALUES.items():
        print(f"  {k} = {v}")
    
    print(f"\nParameter Ranges:")
    for k, v in PARAM_RANGES.items():
        print(f"  {k} = {v}")
    
    print(f"\nMatrix Dimensions:")
    for k, v in MATRIX_DIMS.items():
        print(f"  {k}: {v}")
