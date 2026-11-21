#!/usr/bin/env python3
"""
SM20 Algorithm Simulation — Test Bayesian Smoothing
=====================================================
Simulates the SM20 algorithm to test the 3×3×3 neighbor
smoothing behavior with synthetic repetition data.

This is a pure Python reimplementation based on the decompiled
FUN_00ce1250 and FUN_00ccf070 functions.
"""

import math
import struct
import random

# ============================================================
# CONSTANTS (all confirmed from runtime extraction)
# ============================================================

# Version 2 constants
V2_C1 = 9.29
V2_C2 = 1.3
V2_C3 = 1.0
V2_C4 = -0.08
V2_C5 = -0.31
V2_C6 = 1.04
V2_C7 = 0.07
V2_C8 = -1.88
V2_C9 = 1.58
V2_C10 = 600.0

# Core computation constants
CORE_INIT = 0.0
CORE_WEIGHT_BASE = 500.0
CORE_MIN_WEIGHT = 10.0
CORE_MAX_WEIGHT = 1000.0
CORE_CUBE_WEIGHT = 3.0
CORE_NEUTRAL = 1.0

# Init value constants
INIT_IV1 = 15.0
INIT_IV2 = 3.0
INIT_IV3 = 1.0
INIT_IV4 = -0.08
INIT_IV5 = -0.35
INIT_IV6 = -2.0
INIT_IV7 = 2.25
INIT_IV8 = 600.0

# U-factor table (20 values for D=0..19)
UFACTOR = [
    13.822076, 8.212571, 6.056511, 4.879609, 4.126662,
    3.598557, 3.205138, 2.899285, 2.653822, 2.451912,
    2.282528, 2.138131, 2.013379, 1.904376, 1.808207,
    1.722649, 1.645970, 1.576804, 1.514055, 1.456836,
]

# Parameter ranges
D_MAX = 20  # difficulty 0..20
S_MAX = 20  # stability 0..20  
R_MAX = 20  # repetition 0..20


# ============================================================
# HELPER FUNCTIONS (matching decompiled code)
# ============================================================

def weight_func(x, y):
    """FUN_00f6ae80: x / (x + y)"""
    if x + y == 0:
        return 0.0
    return x / (x + y)


def exp2_clamped(x):
    """FUN_00f614b0: exp2(x), clamped to [-38, 38]"""
    x = max(-38.0, min(38.0, x))
    return 2.0 ** x


def pow_func(x, y):
    """FUN_00477180: pow(x, y)"""
    return math.pow(x, y)


def clamp_idx(val, lo=0, hi=20):
    """Clamp to valid index range"""
    return max(lo, min(hi, int(val)))


def difficulty_to_idx(d):
    """Convert raw difficulty to 0-based index (0..20)"""
    return clamp_idx(round(d))


def stability_to_idx(s):
    """Convert raw stability to 0-based index (0..20)"""
    return clamp_idx(round(s))


def repetition_to_idx(r):
    """Convert repetition number to 0-based index (0..20)"""
    return clamp_idx(round(r) - 1)


# ============================================================
# VERSION 2 INTERVAL COMPUTATION (FUN_00ccf070)
# ============================================================

def compute_interval_v2(stability, quality, repetition, a_factor):
    """
    FUN_00ccf070: Compute next interval.
    
    Parameters:
        stability: float (stability parameter)
        quality: float (response quality, typically 0..5)
        repetition: float (repetition number, 1-based)
        a_factor: float (easiness/A-factor)
    
    Returns:
        float: next interval in days
    """
    # Step 1: Stability scaling
    # dVar2 = c2 + (c1 - c2) * (c3 - quality)
    stability_scale = V2_C2 + (V2_C1 - V2_C2) * (V2_C3 - quality)
    # = 1.3 + 7.99 * (1.0 - quality)
    
    # Step 2: Repetition factor using pow
    # FUN_00477180(repetition, c4 + quality * (c5 - c4))
    rep_param = V2_C4 + quality * (V2_C5 - V2_C4)
    # = -0.08 + quality * (-0.31 - (-0.08))
    # = -0.08 - 0.23 * quality
    rep_factor = pow_func(max(1, repetition), max(0.01, rep_param))
    
    # Step 3: Combine
    # dVar2 = (stability_scale - c6) * rep_factor + c7
    base_interval = (stability_scale - V2_C6) * rep_factor + V2_C7
    # = (stability_scale - 1.04) * rep_factor + 0.07
    
    # Step 4: Quality penalty
    # dVar1 = quality * c8 + c9, clamped to c10
    quality_penalty = quality * V2_C8 + V2_C9
    # = quality * (-1.88) + 1.58
    quality_penalty = min(V2_C10, quality_penalty)
    
    # Step 5: XOR sign bit (negate) + exp2 + multiply by a_factor
    # The XOR with -0.0 flips the sign bit
    # FUN_00f614b0 is exp2, clamped to [-38, 38]
    interval_multiplier = exp2_clamped(-quality_penalty * a_factor)
    # Note: the XOR flips sign of quality_penalty before multiplying by a_factor
    # So we negate quality_penalty
    
    return base_interval * interval_multiplier


# ============================================================
# INITIAL INTERVAL COMPUTATION (FUN_00ce1900)
# ============================================================

def compute_initial_interval(stability, quality, repetition):
    """
    FUN_00ce1900: Compute initial interval for first repetitions.
    
    Based on constants: 15.0, 3.0, 1.0, -0.08, -0.35, -2.0, 2.25, 600.0
    
    The structure mirrors FUN_00ccf070 but with different constants.
    """
    rep = max(1, int(repetition))
    
    if rep <= 0:
        return 1.0
    
    # From decompiled FUN_00ce1900 (similar structure to V2):
    # Uses iv1=15.0, iv2=3.0, iv3=1.0 for rep scaling
    # iv4=-0.08, iv5=-0.35 for power offset
    # iv6=-2.0, iv7=2.25, iv8=600.0 for interval scaling
    
    rep_param = INIT_IV4 + quality * (INIT_IV5 - INIT_IV4)
    # = -0.08 + quality * (-0.35 - (-0.08))
    # = -0.08 - 0.27 * quality
    
    stability_scale = INIT_IV2 + (INIT_IV1 - INIT_IV2) * (INIT_IV3 - quality)
    # = 3.0 + 12.0 * (1.0 - quality)
    
    rep_factor = pow_func(rep, max(0.01, rep_param))
    
    base_interval = (stability_scale - INIT_IV6) * rep_factor + INIT_IV7
    # = (stability_scale - (-2.0)) * rep_factor + 2.25
    # = (stability_scale + 2.0) * rep_factor + 2.25
    
    quality_penalty = quality * INIT_IV8_scaled() + INIT_IV7_scaled()
    quality_penalty = min(INIT_IV8, quality_penalty)
    
    interval_multiplier = exp2_clamped(-quality_penalty)
    
    return max(1.0, base_interval * interval_multiplier)


def INIT_IV8_scaled():
    return -2.0  # Approximate


def INIT_IV7_scaled():
    return 2.25


# ============================================================
# CORE BAYESIAN COMPUTATION (FUN_00ce1250)
# ============================================================

def compute_interval_core(d_idx, s_idx, r_idx, interval_matrix, count_matrix):
    """
    FUN_00ce1250: Core Bayesian interval computation with 3×3×3 smoothing.
    
    Parameters:
        d_idx: difficulty index (0..20)
        s_idx: stability index (0..20)
        r_idx: repetition index (0..20)
        interval_matrix: 21×21×21 flat array [R*441 + S*21 + D]
        count_matrix: 21×21×21 flat array [R*441 + S*21 + D] (int counts)
    
    Returns:
        float: computed interval
    """
    # Get initial interval (when matrix is empty)
    # For now, use a simple formula based on U-factors
    d_safe = min(d_idx, 19)
    initial = UFACTOR[d_safe] if d_safe < len(UFACTOR) else 1.0
    
    # Look up target cell
    target_interval = interval_matrix[r_idx * 441 + s_idx * 21 + d_idx]
    target_count = count_matrix[r_idx * 441 + s_idx * 21 + d_idx]
    
    # Accumulate 3×3×3 neighbor cube
    accumulator = CORE_INIT  # 0.0
    count_sum = 0
    
    for nr in range(max(0, r_idx - 1), min(21, r_idx + 2)):
        for ns in range(max(0, s_idx - 1), min(21, s_idx + 2)):
            for nd in range(max(0, d_idx - 1), min(21, d_idx + 2)):
                # Skip if any index product is 0 (boundary) or >= 21
                if (nr + 1) * (ns + 1) * (nd + 1) == 0:
                    continue
                if nr >= 21 or ns >= 21 or nd >= 21:
                    continue
                
                idx = nr * 441 + ns * 21 + nd
                accumulator += interval_matrix[idx] * count_matrix[idx]
                count_sum += count_matrix[idx]
    
    total_count = count_sum + 1
    
    # Bayesian weights
    target_weight = weight_func(float(target_count), CORE_WEIGHT_BASE) * CORE_MIN_WEIGHT
    neighbor_weight = weight_func(float(count_sum), CORE_MAX_WEIGHT) * CORE_CUBE_WEIGHT
    
    numerator = (initial 
                 + target_interval * target_weight
                 + ((target_interval + accumulator) / total_count) * neighbor_weight * CORE_CUBE_WEIGHT)
    denominator = target_weight + CORE_NEUTRAL + neighbor_weight * CORE_CUBE_WEIGHT
    
    if denominator == 0:
        return initial
    
    return numerator / denominator


# ============================================================
# SIMULATION: Build matrices with synthetic data
# ============================================================

def simulate_repetitions(num_items=1000, num_reps_per_item=20, seed=42):
    """
    Simulate learning sessions to populate the 21×21×21 matrices.
    
    Each item has:
    - difficulty: 0..19 (random or based on content)
    - stability: starts at 0, increases with successful repetitions
    - quality: 0..5 (response quality, higher = better recall)
    
    For each repetition, we compute the interval using V2 algorithm,
    then record it in the matrices.
    """
    random.seed(seed)
    
    interval_matrix = [0.0] * (21 * 21 * 21)  # R*441 + S*21 + D
    count_matrix = [0] * (21 * 21 * 21)
    
    # Track items
    items = []
    for i in range(num_items):
        difficulty = random.randint(0, 19)
        a_factor = random.uniform(1.0, 3.0)  # A-factor (easiness)
        stability = 0.0
        items.append({
            'difficulty': difficulty,
            'stability': stability,
            'a_factor': a_factor,
            'repetitions_done': 0,
            'last_interval': 0.0,
        })
    
    # Simulate learning sessions
    total_reps = 0
    for rep_num in range(1, num_reps_per_item + 1):
        for item in items:
            # Generate a quality response (biased toward higher quality)
            # as repetitions increase
            base_quality = min(5.0, max(0.0, 
                random.gauss(3.5 + 0.3 * rep_num - 0.05 * item['difficulty'], 1.2)))
            quality = max(0.0, min(5.0, base_quality))
            
            # Compute next interval using V2 algorithm
            stability_param = item['stability'] if item['stability'] > 0 else 1.0
            
            # For first few reps, use initial interval formula
            if rep_num <= 3:
                interval = compute_initial_interval(
                    stability_param, quality, rep_num)
            else:
                interval = compute_interval_v2(
                    stability_param, quality, rep_num, item['a_factor'])
            
            interval = max(0.1, interval)
            
            # Update stability (increases with successful repetitions)
            # This is a simplified model
            if quality >= 3:
                item['stability'] += 0.5 * quality / 5.0
            else:
                item['stability'] *= 0.5
            
            # Convert to matrix indices
            d_idx = difficulty_to_idx(item['difficulty'])
            s_idx = stability_to_idx(item['stability'])
            r_idx = repetition_to_idx(rep_num)
            
            # Update matrices (running average)
            idx = r_idx * 441 + s_idx * 21 + d_idx
            if idx < len(interval_matrix):
                old_count = count_matrix[idx]
                old_interval = interval_matrix[idx]
                new_count = old_count + 1
                count_matrix[idx] = new_count
                interval_matrix[idx] = (old_interval * old_count + interval) / new_count
            
            item['repetitions_done'] = rep_num
            item['last_interval'] = interval
            total_reps += 1
    
    return interval_matrix, count_matrix, items


# ============================================================
# TEST: Demonstrate Bayesian smoothing
# ============================================================

def test_bayesian_smoothing():
    """Show how the 3×3×3 neighbor smoothing affects results."""
    
    print("=" * 70)
    print("SM20 Algorithm Simulation")
    print("=" * 70)
    
    # Build matrices with synthetic data
    print("\nPhase 1: Simulating 1000 items × 20 repetitions...")
    interval_matrix, count_matrix, items = simulate_repetitions(1000, 20)
    
    # Count populated cells
    populated = sum(1 for c in count_matrix if c > 0)
    total_cells = 21 * 21 * 21
    print(f"  Populated cells: {populated}/{total_cells} ({100*populated/total_cells:.1f}%)")
    print(f"  Total data points: {sum(count_matrix)}")
    
    # Show some sample intervals from the matrix
    print("\n  Sample intervals (R=1, S=1, D=0..19):")
    for d in range(20):
        idx = 1 * 441 + 1 * 21 + d
        if count_matrix[idx] > 0:
            print(f"    D={d:2d}: interval={interval_matrix[idx]:8.3f}, count={count_matrix[idx]}")
    
    # Phase 2: Test core computation with vs without smoothing
    print("\n" + "=" * 70)
    print("Phase 2: Testing Bayesian Smoothing (FUN_00ce1250)")
    print("=" * 70)
    
    # Test cells with different amounts of data
    test_cases = [
        (5, 5, 5, "moderate data"),
        (10, 3, 8, "high difficulty"),
        (2, 1, 15, "high repetition"),
        (15, 15, 15, "edge of matrix"),
        (0, 0, 0, "corner (likely sparse)"),
    ]
    
    for d, s, r, desc in test_cases:
        # Raw lookup (no smoothing)
        raw_idx = r * 441 + s * 21 + d
        raw_interval = interval_matrix[raw_idx]
        raw_count = count_matrix[raw_idx]
        
        # With Bayesian smoothing
        smoothed = compute_interval_core(d, s, r, interval_matrix, count_matrix)
        
        # Show neighbor counts
        neighbor_count = 0
        for nr in range(max(0, r-1), min(21, r+2)):
            for ns in range(max(0, s-1), min(21, s+2)):
                for nd in range(max(0, d-1), min(21, d+2)):
                    if (nr+1)*(ns+1)*(nd+1) == 0 or nr >= 21 or ns >= 21 or nd >= 21:
                        continue
                    neighbor_count += count_matrix[nr*441+ns*21+nd]
        
        print(f"\n  [{d:2d},{s:2d},{r:2d}] ({desc}):")
        print(f"    Raw: interval={raw_interval:8.3f}, count={raw_count}")
        print(f"    Neighbors total: count={neighbor_count}")
        print(f"    Smoothed: interval={smoothed:8.3f}")
        if raw_count > 0:
            print(f"    Difference: {smoothed - raw_interval:+8.3f} ({100*(smoothed-raw_interval)/raw_interval:+.1f}%)")
    
    # Phase 3: Show how smoothing evolves as data accumulates
    print("\n" + "=" * 70)
    print("Phase 3: Smoothing vs Data Volume")
    print("=" * 70)
    
    for n_items in [50, 200, 500, 1000, 5000]:
        im, cm, _ = simulate_repetitions(n_items, 20, seed=42)
        target_idx = 5 * 441 + 5 * 21 + 5
        target_count = cm[target_idx]
        target_raw = im[target_idx]
        
        if target_count > 0:
            smoothed = compute_interval_core(5, 5, 5, im, cm)
            print(f"  Items={n_items:5d}: raw={target_raw:8.3f} (n={target_count:3d}), "
                  f"smoothed={smoothed:8.3f}, diff={smoothed-target_raw:+.3f}")
        else:
            print(f"  Items={n_items:5d}: no data at [5,5,5]")
    
    # Phase 4: Version 2 interval computation demo
    print("\n" + "=" * 70)
    print("Phase 4: Version 2 Interval Formula (FUN_00ccf070)")
    print("=" * 70)
    
    print("\n  Intervals for quality=5 (perfect recall), a_factor=2.0:")
    for rep in [1, 2, 3, 5, 10, 15, 20]:
        interval = compute_interval_v2(1.0, 5.0, rep, 2.0)
        print(f"    Rep={rep:2d}: interval={interval:8.3f} days")
    
    print("\n  Intervals for quality=0 (complete failure), a_factor=2.0:")
    for rep in [1, 2, 3, 5, 10]:
        interval = compute_interval_v2(1.0, 0.0, rep, 2.0)
        print(f"    Rep={rep:2d}: interval={interval:8.3f} days")
    
    print("\n  Quality sensitivity at rep=5, a_factor=2.0:")
    for q in [0, 1, 2, 3, 4, 5]:
        interval = compute_interval_v2(1.0, q, 5, 2.0)
        print(f"    Quality={q}: interval={interval:8.3f} days")
    
    print("\n  A-factor sensitivity at rep=5, quality=4:")
    for af in [1.0, 1.5, 2.0, 2.5, 3.0, 4.0]:
        interval = compute_interval_v2(1.0, 4.0, 5, af)
        print(f"    A-factor={af:.1f}: interval={interval:8.3f} days")


if __name__ == "__main__":
    test_bayesian_smoothing()
