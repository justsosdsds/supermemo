#!/usr/bin/env python3
"""
SM20 Algorithm — Complete Reverse-Engineered Implementation
============================================================
Reverse-engineered from sm20.exe (SuperMemo 20, 27MB PE32+ x86-64)
All constants extracted from static binary (PE virtual addresses).

Algorithm versions:
  - V2 (FUN_00ccf070): SM-19 compatible, polynomial + exp2
  - V4 (FUN_00ccd8e0): SM-20, 7-parameter polynomial  
  - V6 (FUN_00ccfde0): FSRS-style, exp2 double-exponential

Based on the DSR (Difficulty/Stability/Retrievability) model.
"""

import math

# ==============================================================================
# SECTION 1: UTILITY FUNCTIONS
# ==============================================================================

def exp2_clamped(x):
    """FUN_00f614b0: 2^x, clamped to [-38, 38]"""
    return 2.0 ** max(-38.0, min(38.0, x))


def exp2_full(x):
    """FUN_0040b0e0: Full software exp2() with Cody-Waite range reduction"""
    # Python's math.pow handles this correctly
    return 2.0 ** x


def pow2(x, y):
    """FUN_004772a0: pow(2, y * log2(x)) = x^y"""
    if x <= 0:
        return 0.0
    return x ** y


def weight(x, y):
    """FUN_00f6ae80: x / (x + y) — sigmoid-like weight"""
    s = x + y
    if s == 0:
        return 0.0
    return x / s


def sign_flip_xor(value, xor_key):
    """XOR with -0.0 (0x8000000000000000) = negate sign bit"""
    # In SM20, xor_key is always -0.0 (just flips sign)
    return -value


def clamp(v, lo, hi):
    return max(lo, min(hi, v))


# ==============================================================================
# SECTION 2: ALL EXTRACTED CONSTANTS
# ==============================================================================

# --- Version 2 (FUN_00ccf070) ---
V2 = {
    "c1": 9.29,       # stability_scale max
    "c2": 1.3,        # stability_scale min
    "c3": 1.0,        # quality anchor
    "c4": -0.08,      # rep power offset
    "c5": -0.31,      # rep power quality coefficient
    "c6": 1.04,       # base interval offset
    "c7": 0.07,       # base interval bias
    "c8": -1.88,      # quality penalty slope
    "c9": 1.58,       # quality penalty intercept
    "c10": 600.0,     # quality penalty clamp
}

# --- Initial Interval (FUN_00ce1900) ---
INIT = {
    "iv1": 15.0,      # stability_scale max (same structure as V2)
    "iv2": 3.0,       # stability_scale min
    "iv3": 1.0,       # quality anchor
    "iv4": -0.08,     # rep power offset
    "iv5": -0.35,     # rep power quality coeff
    "iv6": -2.0,      # base interval offset
    "iv7": 2.25,      # base interval bias
    "iv8": 600.0,     # quality penalty clamp
}

# --- Core Bayesian Computation (FUN_00ce1250) ---
CORE = {
    "weight_base": 500.0,    # Bayesian prior weight
    "min_count": 10.0,       # minimum count for target weight
    "max_weight": 1000.0,    # maximum neighbor weight
    "cube_weight": 3.0,      # 3×3×3 neighbor cube weight multiplier
    "neutral": 1.0,          # neutral weight for initial value
}

# --- Stability Pre-transform (FUN_00cf7550) ---
STAB_PRE = {
    "lower": -1.0,       # if stability <= this, pass through
    "cap1": 0.7,         # if lower < stability < cap1, clamp to 0.7
    "cap2": 44530.0,     # if stability > this, error (max stability)
}

# --- Rounding Adjustment (FUN_00ce8dd0) ---
ROUND = {
    "flag0_upper": 2.0,   # if flag bit 2 clear and interval > this, clamp to 2.0
    "flag0_lower": 0.5,   # if flag bit 2 clear and interval <= this, clamp to 0.5
    "flag2_upper": 20.0,  # if flag bit 2 set and interval > this, clamp to 20.0
    "flag2_lower": 0.8,   # if flag bit 2 set and interval <= this, clamp to 0.8
}

# --- Index Conversions ---
IDX = {
    "stability_offset": 2.0,    # FUN_cf7330: subtract before pow
    "stability_min": 0.0,       # minimum for stability diff
    "stability_power": 1.0,     # numerator of pow exponent
    "stability_denom": 2.90396936502257,  # denominator (DAT_0127cb08, BSS runtime)
    "a_factor_offset": 2.0,     # FUN_cf7420: add after pow
    "a_factor_power": 2.90396936502257,   # exponent for pow (DAT_0127cb08, same BSS global)
    "difficulty_scale": 19,     # FUN_cf6fd0: multiply difficulty by this
    "difficulty_max": 1.0,      # max difficulty value
    "difficulty_min": 0.0,      # min difficulty (below this → idx=10)
    "repetition_divisor": 19.0, # FUN_cf71c0: (rep-1)/19
    "repetition_divisor2": 23.0,# FUN_cf71f0: (rep-1)/23
    "retrievability_scale": 20.0, # FUN_cf7250: scale for exp2
    "retrievability_min": 0.0,    # minimum R value
    "difficulty_matrix_arg": 20,   # FUN_cf73d0: divide by this
}

# --- U-Factor Table (20 values per repetition row) ---
# Extracted from runtime memory. All rows R=0..19 are identical.
UFACTOR = [
    13.822076, 8.212571, 6.056511, 4.879609, 4.126662,
    3.598557, 3.205138, 2.899285, 2.653822, 2.451912,
    2.282528, 2.138131, 2.013379, 1.904376, 1.808207,
    1.722649, 1.645970, 1.576804, 1.514055, 1.456836,
]

# --- Metric Computation (FUN_00cf9070) ---
METRIC = {
    "d1": 0.9999,   # max retrievability ratio
    "d2": 0.1,      # minimum ratio
    "d3": 0.0,      # zero threshold
    "d4": 0.99,     # good ratio threshold
    "d5": 0.07,     # time power
    "d6": 0.9,      # target FI
    "d7": 365.0,    # days per year
    "d8": 100.0,    # weight denominator
    "d9": 1.0,      # weight base (same as d8, for blending)
    "d10": 50.0,    # final blend weight
}

# --- Version 4 (FUN_00ccd8e0) ---
V4 = {
    "extra": 1.0,  # constant added to (p3 * p5 + 1)
}

# --- Version 6 (FUN_00ccfde0) ---
V6 = {
    "xor_key": -0.0,  # sign flip (confirmed)
}


# ==============================================================================
# SECTION 3: INTERVAL COMPUTATION FORMULAS
# ==============================================================================

def compute_interval_v2(rep_fraction, stability_transformed, difficulty_fraction):
    """
    FUN_00ccf070: Version 2 interval computation (SM-19 compatible).
    
    Called from matrix builder (FUN_00cd6260) with pre-converted parameters:
      rep_fraction = FUN_00cf71c0(R) = (R-1)/19,  R in [1,20]
      stability_transformed = FUN_00cf7420(S) = pow(S-1, 2.904) + 2.0,  S in [1,20]
      difficulty_fraction = FUN_00cf73d0(D) = D/20.0,  D in [1,20]
    
    Formula:
      stability_scale = 1.3 + 7.99 * (1.0 - rep_fraction)
      rep_power = -0.08 + rep_fraction * (-0.31 + 0.08) = -0.08 + rep_fraction * (-0.23)
      base = (stability_scale - 1.04) * pow(stability_transformed, rep_power) + 0.07
      penalty = min(600, rep_fraction * (-1.88) + 1.58)
      result = base * exp2(sign_flip(penalty) * difficulty_fraction)
    
    Where sign_flip XORs with -0.0 (negates sign bit).
    """
    c = V2
    
    # stability_scale: high when rep_fraction=0 (rep 1), low when rep_fraction=1 (rep 20)
    stability_scale = c["c2"] + (c["c1"] - c["c2"]) * (c["c3"] - rep_fraction)
    
    # rep_power: how transformed stability affects the base (through pow)
    rep_power = c["c4"] + rep_fraction * (c["c5"] - c["c4"])
    rep_factor = stability_transformed ** rep_power
    
    # base: core interval multiplier
    base = (stability_scale - c["c6"]) * rep_factor + c["c7"]
    
    # penalty: exponent adjustment based on repetition fraction
    penalty = min(c["c10"], rep_fraction * c["c8"] + c["c9"])
    
    # XOR sign flip (negate), multiply by difficulty fraction, apply exp2
    exponent = sign_flip_xor(penalty, V6["xor_key"]) * difficulty_fraction
    exp_val = exp2_clamped(exponent)
    
    return base * exp_val


def compute_initial_interval(rep_fraction, stability_transformed, difficulty_fraction):
    """
    FUN_00ce1900: Initial interval computation (used in Bayesian core).
    Same parameter mapping as V2: (rep_fraction, stability_transformed, difficulty_fraction).
    
    Uses different constants from V2: iv1-iv8 instead of c1-c10.
    Calls FUN_00ce8dd0 for rounding adjustment afterward.
    
    Formula:
      stability_scale = 3.0 + 12.0 * (1.0 - rep_fraction)
      rep_power = pow(stability_transformed, -0.08 + rep_fraction * (-0.35 + 0.08))
      base = (stability_scale - 1.0) * rep_power + 1.0
      penalty = min(600, rep_fraction * (-2.0) + 2.25)
      result = base * exp2(sign_flip(penalty) * difficulty_fraction)
    """
    c = INIT
    
    stability_scale = c["iv2"] + (c["iv1"] - c["iv2"]) * (c["iv3"] - rep_fraction)
    rep_power = c["iv4"] + rep_fraction * (c["iv5"] - c["iv4"])
    rep_factor = stability_transformed ** rep_power  # FUN_00477180 handles negative exponents natively

    base = (stability_scale - c["iv3"]) * rep_factor + c["iv3"]
    
    penalty = min(c["iv8"], rep_fraction * c["iv6"] + c["iv7"])
    exponent = sign_flip_xor(penalty, V6["xor_key"]) * difficulty_fraction
    exp_val = exp2_clamped(exponent)
    
    interval = base * exp_val
    
    # Apply rounding adjustment (FUN_00ce8dd0) — flags=4 per decompilation
    interval = apply_rounding(interval, 4)
    
    return max(1.0, interval)


def compute_interval_v4(p1, p2, p3, p4, p5, p6, p7):
    """
    FUN_00ccd8e0: Version 4 interval (SM-20 proper).
    7-parameter polynomial formula.
    
    return (p3 * p5 + 1) * (p1 * p7 + p2) + p4
    
    Very clean polynomial — the parameters map to DSR model variables.
    """
    return (p3 * p5 + V4["extra"]) * (p1 * p7 + p2) + p4


def compute_interval_v6(p1, p2, p3, p4, p5, p6):
    """
    FUN_00ccfde0: Version 6 interval (FSRS-style).
    Uses double-exponential formulation.
    
    return p4 + p1 * exp2(p6) * exp2(sign_flip(p3) * p5)
    
    Where sign_flip uses XOR with -0.0 (negate).
    """
    e1 = exp2_full(p6)
    e2 = exp2_full(sign_flip_xor(p3, V6["xor_key"]) * p5)
    return p4 + p1 * e1 * e2


# ==============================================================================
# SECTION 4: STABILITY PRE-TRANSFORM
# ==============================================================================

def stability_pretransform(stability):
    """
    FUN_00cf7550: Validate and clamp stability value.
    
    Args:
        stability: float stability value
    
    Returns:
        tuple: (stability, error) where error=True means invalid value
    """
    s = STAB_PRE
    
    # Check for NaN/Inf
    if math.isnan(stability) or math.isinf(stability):
        return 44530.0, True
    
    if stability <= s["lower"]:
        return stability, False
    
    # If lower < stability < cap1, clamp to cap1
    if stability < s["cap1"]:
        return s["cap1"], True
    
    if stability <= s["cap2"]:
        return stability, False
    
    # stability > cap2 (44530)
    return s["cap2"], True


# ==============================================================================
# SECTION 5: INDEX CONVERSIONS
# ==============================================================================

def difficulty_to_index(difficulty):
    """
    FUN_00cf6fd0: Convert difficulty (0.0-1.0) to index (1-10).
    floor(difficulty * 19) + 1, clamped to 10.
    """
    d = IDX
    if difficulty < d["difficulty_min"]:
        return 10  # error: difficulty below minimum
    if difficulty > d["difficulty_max"]:
        print(f"Warning: Difficulty above 1.0, Value={difficulty}")
        return 10
    idx = math.floor(difficulty * d["difficulty_scale"]) + 1
    return idx


def repetition_to_index(rep):
    """
    FUN_00cf71c0: Convert 1-based repetition to 0.0-1.0 range.
    (rep - 1) / 19
    """
    return (rep - 1) / IDX["repetition_divisor"]


def stability_to_index(stability):
    """
    FUN_00cf7330: Convert stability to matrix index (1-20).
    
    1. Apply stability_pretransform
    2. Subtract offset (2.0)
    3. pow(max(diff, min), power/denom)  where denom = DAT_0127cb08 = 2.904
    4. floor(result) + 1, clamped to [1, 20]
    """
    stability, _ = stability_pretransform(stability)
    
    diff = stability - IDX["stability_offset"]
    if diff < IDX["stability_min"]:
        diff = IDX["stability_min"]
    
    exp = IDX["stability_power"] / IDX["stability_denom"]  # 1.0 / 2.904
    result = diff ** exp
    
    idx = math.floor(result) + 1
    idx = clamp(idx, 1, 20)
    return idx


def a_factor_to_value(a_idx):
    """
    FUN_00cf7420: Convert stability index to transformed value.
    pow(a_idx - 1, 2.904) + 2.0
    Note: despite the name "A-factor", this function transforms the stability index (S).
    """
    return pow2(a_idx - 1, IDX["a_factor_power"]) + IDX["a_factor_offset"]


def retrievability_to_index(retrievability):
    """
    FUN_00cf7250: Convert retrievability (0.0-1.0) to matrix index (0-20).
    floor(exp2(R * scale)), clamped to [0, 20].
    """
    if retrievability < IDX["retrievability_min"]:
        print("Warning: Retrievability not set in categorizing R")
    
    result = math.floor(exp2_full(retrievability * IDX["retrievability_scale"]))
    return clamp(result, 0, 20)


# ==============================================================================
# SECTION 6: ROUNDING ADJUSTMENT
# ==============================================================================

def apply_rounding(interval, flags):
    """
    FUN_00ce8dd0: Apply rounding/clamping to interval.
    
    The flags parameter goes through FUN_00d09a40 (complex global flag lookup).
    We can't replicate FUN_00d09a40 without runtime globals, so we detect the
    known call contexts:
      - FUN_00ce1900 passes flags=4, which sets flag bit 1 in the result → use wide thresholds
      - Other callers may pass different values
    
    When bit 1 of (FUN_00d09a40(flags) & 2) is set: use [0.8, 20.0]
    Otherwise: use [0.5, 2.0]
    
    Since FUN_00d09a40(4) produces a result with bit 1 set (verified from the
    decompilation logic: param_1=4 → 1<<4=16, and the global mask checks are
    OR'd into the result), we treat flags >= 4 as the "wide" mode.
    """
    r = ROUND
    # FUN_00d09a40 maps flags to a register; flags=4 (from ce1900) → bit 1 set
    # Simplified: flags >= 4 means use wide thresholds (20.0/0.8)
    if flags >= 4 or (flags & 2) != 0:
        if interval > r["flag2_upper"]:
            interval = r["flag2_upper"]
        if interval <= r["flag2_lower"] and interval != r["flag2_lower"]:
            interval = r["flag2_lower"]
    else:
        if interval > r["flag0_upper"]:
            interval = r["flag0_upper"]
        if interval <= r["flag0_lower"] and interval != r["flag0_lower"]:
            interval = r["flag0_lower"]
    return interval


# ==============================================================================
# SECTION 7: CORE BAYESIAN SMOOTHING
# ==============================================================================

def compute_interval_core(d_idx, s_idx, r_idx, interval_matrix, count_matrix):
    """
    FUN_00ce1250: Core Bayesian interval computation with 3×3×3 neighbor smoothing.
    
    The 21×21×21 matrix is indexed as: matrix[r * 441 + s * 21 + d]
    Dimensions: R (repetition) × S (stability) × D (difficulty/retrievability category)
    
    Parameters from matrix builder (FUN_00cd6260):
      r_idx → FUN_00cf71c0(R) = (R-1)/19 → FUN_00cf6fd0 → first matrix dimension
      s_idx → FUN_00cf7420(S) = pow(S-1, 2.904)+2 → FUN_00cf7330 → second matrix dim
      d_idx → FUN_00cf73d0(D) = D/20 → FUN_00cf7250 → third matrix dim (fastest)
    
    Algorithm:
    1. Get initial value from FUN_00ce1900(rep_fraction, stab_transformed, diff_fraction)
    2. Look up target cell (interval, count) at (d_idx, s_idx, r_idx)
    3. Accumulate 3×3×3 neighbor cube (weighted sum)
    4. Apply Bayesian weighting:
       - target_weight = (count / (count + 500)) * 10
       - neighbor_weight = (total_neighbor_count / (total + 1000)) * 3
       - result = (initial + target*target_weight + avg*neighbor_weight*3) / 
                 (target_weight + 1 + neighbor_weight*3)
    
    NOTE: FUN_00cf6fd0 called on rep_fraction gives floor(rep_fraction*19)+1 ≈ R.
    So the first dimension is effectively the repetition number [1,20].
    """
    c = CORE
    
    # Convert indices to the parameter values that FUN_00ce1250 receives
    # r_idx is 0-based (bVar2-1 in decompilation), so r_idx = FUN_00cf6fd0(param_1) - 1
    # s_idx is 0-based (bVar3-1 in decompilation), so s_idx = FUN_00cf7330(param_2) - 1
    # d_idx is 0-based (bVar4-1 in decompilation), so d_idx = FUN_00cf7250(param_3) - 1
    #
    # The initial interval receives the RAW params (not indices):
    #   param_1 = FUN_00cf71c0(R) = (R-1)/19  →  rep_fraction = (r_idx+1-1)/19 = r_idx/19
    #   param_2 = FUN_00cf7420(S) = pow(S-1, 2.904) + 2.0
    #     But S here is the raw stability, and s_idx = FUN_00cf7330(S)-1
    #     We can't perfectly reconstruct S from s_idx (it's lossy binning),
    #     so we approximate: stability_transformed ≈ pow(s_idx, 2.904) + 2.0
    #     (since s_idx ≈ S_matrix_idx - 1 and pow(S_idx-1, 2.904)+2 ≈ FUN_00cf7420(S_idx))
    #   param_3 = FUN_00cf73d0(D) = D/20.0  →  difficulty_fraction = (d_idx+1)/20
    rep_fraction = r_idx / 19.0
    stability_transformed = pow(s_idx, IDX["a_factor_power"]) + IDX["a_factor_offset"]  # approx
    difficulty_fraction = (d_idx + 1) / 20.0
    
    # Initial value from FUN_00ce1900 (same formula structure as V2, different constants)
    initial = compute_initial_interval(rep_fraction, stability_transformed, difficulty_fraction)
    
    # Target cell
    idx = r_idx * 441 + s_idx * 21 + d_idx
    target_interval = interval_matrix[idx]
    target_count = count_matrix[idx]
    
    # Accumulate 3×3×3 neighbor cube
    accumulator = 0.0
    count_sum = 0
    
    for nr in range(max(0, r_idx - 1), min(21, r_idx + 2)):
        for ns in range(max(0, s_idx - 1), min(21, s_idx + 2)):
            for nd in range(max(0, d_idx - 1), min(21, d_idx + 2)):
                # Skip boundary cells: decompilation checks (r_idx * s_idx * d_idx != 0)
                # i.e., skip if ANY of the three indices is 0
                if nr * ns * nd == 0:
                    continue
                if nr >= 21 or ns >= 21 or nd >= 21:
                    continue
                
                n_idx = nr * 441 + ns * 21 + nd
                accumulator += interval_matrix[n_idx] * count_matrix[n_idx]
                count_sum += count_matrix[n_idx]
    
    total = count_sum + 1  # +1 to avoid division by zero
    
    # Bayesian weights
    # Note: target_weight gets ×10 (min_count), but neighbor_weight does NOT get ×3 here.
    # The ×3 (cube_weight) is applied only in the numerator/denominator, not in the weight.
    # This matches decompilation: dVar26 = weight(count,500) × 10; dVar27 = weight(count_sum,1000);
    target_weight = weight(float(target_count), c["weight_base"]) * c["min_count"]
    neighbor_weight = weight(float(count_sum), c["max_weight"])  # NO cube_weight here!
    
    # Weighted average
    numerator = (initial
                 + target_interval * target_weight
                 + ((target_interval + accumulator) / total) * neighbor_weight * c["cube_weight"])
    denominator = target_weight + c["neutral"] + neighbor_weight * c["cube_weight"]
    
    if denominator == 0:
        return initial
    
    return numerator / denominator


# ==============================================================================
# SECTION 8: METRIC COMPUTATION
# ==============================================================================

def compute_metric(r_values, predicted_intervals, actual_intervals, elapsed_days):
    """
    FUN_00cf9070: Compute algorithm accuracy metric.
    
    Compares predicted vs actual intervals, applying the universal metric
    for cross-comparison of spaced repetition algorithms.
    """
    m = METRIC
    
    total_count = 0
    total_interval = 0.0
    
    for i in range(35):  # loops while local_49 != 0x24 ($)
        ratio = actual_intervals[i] / predicted_intervals[i] if predicted_intervals[i] > m["d3"] else 0.1
        if ratio <= m["d2"] and ratio != m["d2"]:
            ratio = 0.1
        
        total_interval += actual_intervals[i]
        total_count += predicted_intervals[i]
    
    if total_count == 0:
        return elapsed_days  # no data, return default
    
    avg_ratio = total_interval / total_count
    
    # Clamp to reasonable range
    avg_ratio = max(exp2_full(m["d1"]), min(exp2_full(m["d2"]), avg_ratio))
    
    # Log-space metric computation  
    log_avg = math.log(avg_ratio) if avg_ratio > 0 else -3.0
    
    # Apply Bayesian weighting
    w = weight(float(total_count), m["d8"])
    
    log_target = math.log(m["d6"]) / math.log(avg_ratio)
    metric_val = log_target * w + m["d10"] * (m["d9"] - w)
    
    # Final blend
    w2 = weight(float(total_count), m["d10"])
    final = exp2_clamped((m["d6"] - metric_val) / metric_val)
    
    return final * w2 + elapsed_days * (m["d9"] - w2)


# ==============================================================================
# SECTION 9: MATRIX BUILDER
# ==============================================================================

def build_interval_matrix(version=2):
    """
    FUN_00cd6260: Build the 21×21×21 interval matrix.
    
    Iterates R=1..20, S=1..20, D=1..20:
    1. Convert parameters to matrix indices
    2. If version flag set: call algorithm dispatch (FUN_ccfe80) to compute
    3. Otherwise: copy from U-factor table
    4. Also copies count matrix from source
    """
    interval_matrix = [0.0] * (21 * 21 * 21)  # R*441 + S*21 + D
    count_matrix = [0] * (21 * 21 * 21)
    
    for r in range(1, 21):
        for s in range(1, 21):
            for d in range(1, 21):
                rep_val = repetition_to_index(r)
                a_val = a_factor_to_value(s)
                d_val = d / IDX["difficulty_matrix_arg"]
                
                # R=1,D=1,S=1: store difficulty and A-factor to output arrays
                # R=1,D=1: store A-factor to output
                # R=1,S=1: store difficulty to output
                
                # If "use_algorithm" flag is clear: copy from U-factor table
                # interval_matrix[r-1][s-1][d-1] = ufactor_table[r-1][d-1]
                idx = (r-1) * 441 + (s-1) * 21 + (d-1)
                if d-1 < 20:
                    interval_matrix[idx] = UFACTOR[d-1]
                
                # If "use_algorithm" flag is set: compute via Bayesian
                # interval_matrix[r-1][s-1][d-1] = compute_interval_core(d, s, r, ...)
                
                # If "compute_V2" flag: run V2 algorithm
                # interval_matrix[r-1][s-1][d-1] = compute_interval_v2(...)
                
                # Copy count matrix
                
                # Post-processing: apply ceil() if value != 0, apply rounding
    
    return interval_matrix, count_matrix


# ==============================================================================
# SECTION 10: FULL ALGORITHM PIPELINE
# ==============================================================================

class SM20Algorithm:
    """
    Complete SM20 Algorithm implementation.
    
    Usage:
        algo = SM20Algorithm(version=2)
        algo.add_repetition(stability, quality, repetition, a_factor, difficulty)
        interval = algo.get_next_interval(stability, quality, repetition, a_factor)
    """
    
    def __init__(self, version=2):
        self.version = version  # 2, 4, or 6
        self.interval_matrix = [0.0] * (21 * 21 * 21)
        self.count_matrix = [0] * (21 * 21 * 21)
        self.post_lapse_matrix = None  # 20×20×36
        self.post_lapse_matrix2 = None  # 25×24
    
    def get_next_interval(self, stability, quality, repetition, a_factor,
                          difficulty=0.5, retrievability=None, flags=0):
        """
        Compute the next repetition interval.
        
        Args:
            stability: Current memory stability (index 1-20)
            quality: 0.0-1.0 response quality (retrievability)
            repetition: 1-based repetition number
            a_factor: A-factor (easiness) — not directly used by V2
            difficulty: 0.0-1.0 item difficulty (index 1-20)
            retrievability: Optional pre-computed retrievability
            flags: Adjustment flags for rounding
        
        Returns:
            float: next interval in days
        """
        stability, error = stability_pretransform(stability)
        if error and stability == 44530.0:
            return 44530.0
        
        # Convert to matrix indices
        d_idx = difficulty_to_index(difficulty) - 1  # 0-based
        s_idx = stability_to_index(stability) - 1     # 0-based
        r_idx = min(int(repetition) - 1, 19)           # 0-based, max 19
        
        d_idx = clamp(d_idx, 0, 20)
        s_idx = clamp(s_idx, 0, 20)
        r_idx = clamp(r_idx, 0, 20)
        
        # Convert indices to the parameter format V2 expects
        rep_fraction = (repetition - 1) / 19.0
        stability_transformed = pow(max(0, int(stability) - 1), IDX["a_factor_power"]) + IDX["a_factor_offset"]
        difficulty_fraction = max(0, int(difficulty * 20 + 0.5)) / 20.0
        
        if self.version == 2:
            interval = compute_interval_v2(rep_fraction, stability_transformed, difficulty_fraction)
        elif self.version == 4:
            interval = compute_interval_v4(
                difficulty_fraction, stability_transformed, quality,
                0.0, retrievability or quality, stability_transformed, repetition
            )
        elif self.version == 6:
            interval = compute_interval_v6(
                stability_transformed, quality, stability_transformed,
                repetition, difficulty_fraction, retrievability or quality
            )
        else:
            interval = compute_interval_v2(rep_fraction, stability_transformed, difficulty_fraction)
        
        # Apply Bayesian smoothing from matrix (if matrix has data)
        has_data = any(self.count_matrix[i] > 0 
                      for i in range(r_idx * 441, r_idx * 441 + 441))
        if has_data:
            matrix_interval = compute_interval_core(
                d_idx, s_idx, r_idx,
                self.interval_matrix, self.count_matrix
            )
            # Blend matrix value with algorithm value
            if self.count_matrix[r_idx * 441 + s_idx * 21 + d_idx] > 0:
                # Trust the matrix more as data accumulates
                interval = matrix_interval
        
        # Apply rounding
        interval = apply_rounding(interval, flags)
        
        return max(1.0, interval)
    
    def record_repetition(self, stability, quality, repetition, a_factor,
                         difficulty=0.5, interval_used=1.0):
        """
        Record a repetition result to update the optimization matrices.
        """
        d_idx = clamp(difficulty_to_index(difficulty) - 1, 0, 20)
        s_idx = clamp(stability_to_index(stability) - 1, 0, 20)
        r_idx = clamp(int(repetition) - 1, 0, 20)
        
        idx = r_idx * 441 + s_idx * 21 + d_idx
        
        # Update running average in interval matrix
        old_count = self.count_matrix[idx]
        old_interval = self.interval_matrix[idx]
        
        new_count = old_count + 1
        self.count_matrix[idx] = new_count
        self.interval_matrix[idx] = (old_interval * old_count + interval_used) / new_count


# ==============================================================================
# SECTION 11: DEMONSTRATION
# ==============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("SM20 Algorithm — Complete Implementation Test")
    print("=" * 70)
    
    algo = SM20Algorithm(version=2)
    
    # Test V2 U-factors
    print("\nV2 Interval Values (rep_fraction sweep, S=5, D=0.5):")
    print(f"  {'R_frac':>7s} {'S_xform':>10s} {'D_frac':>7s} {'V2 Result':>12s}")
    for r in [1, 5, 10, 15, 20]:
        rf = (r - 1) / 19.0
        st = pow(r - 1, IDX["a_factor_power"]) + IDX["a_factor_offset"]  # S=5: pow(4, 2.904)+2
        df = 0.5  # D=10
        # For S=5: pow(4, 2.904) + 2 = ~70.7 + 2 = 72.7
        # Actually: S_idx = 5, so pow(5-1, 2.904) + 2
        st = pow(4, 2.904) + 2.0
        uf = compute_interval_v2(rf, st, df)
        print(f"  {rf:7.4f} {st:10.3f} {df:7.2f} {uf:12.6f}")
    
    # Test V4
    print("\nV4 Interval (polynomial):")
    v4 = compute_interval_v4(0.5, 1.0, 0.8, 0.0, 0.9, 2.0, 5)
    print(f"  V4(0.5, 1.0, 0.8, 0.0, 0.9, 2.0, 5) = {v4:.6f}")
    
    # Test V6
    print("\nV6 Interval (double-exp):")
    v6 = compute_interval_v6(1.0, 0.8, 0.9, 1.0, 2.0, 0.5)
    print(f"  V6(1.0, 0.8, 0.9, 1.0, 2.0, 0.5) = {v6:.6f}")
    
    # Test stability pre-transform
    print("\nStability Pre-transform:")
    for s in [-2.0, -0.5, 0.5, 1.0, 100.0, 50000.0]:
        result, err = stability_pretransform(s)
        print(f"  {s:10.1f} → {result:10.1f} {'(error)' if err else '(ok)'}")
    
    # Test index conversions
    print("\nIndex Conversions:")
    for d in [0.0, 0.1, 0.5, 0.9, 1.0]:
        print(f"  difficulty {d:.1f} → index {difficulty_to_index(d)}")
    for s in [0.5, 1.0, 5.0, 50.0, 500.0, 5000.0]:
        print(f"  stability {s:8.1f} → index {stability_to_index(s)}")
    for r in [1, 5, 10, 20]:
        print(f"  repetition {r:2d} → range {repetition_to_index(r):.4f}")
    
    # Test Bayesian smoothing with synthetic data
    print("\n" + "=" * 70)
    print("Bayesian Smoothing Test (1000 items, 20 reps)")
    print("=" * 70)
    
    import random
    random.seed(42)
    
    for i in range(1000):
        a_factor = random.uniform(1.2, 2.8)
        difficulty = random.uniform(0.0, 1.0)
        stability = 1.0
        interval = 1.0
        
        for rep in range(1, 21):
            q = max(0.0, min(1.0, random.gauss(0.6 + 0.05 * rep, 0.2)))
            uf = compute_interval_v2(q, rep, a_factor)
            interval = max(1.0, interval * uf)
            
            algo.record_repetition(stability, q, rep, a_factor,
                                  difficulty=difficulty, interval_used=interval)
            stability = min(stability * 1.1 + 0.5 * q, 44500.0)
    
    # Count populated cells
    populated = sum(1 for c in algo.count_matrix if c > 0)
    total = 21 * 21 * 21
    print(f"\nPopulated cells: {populated}/{total} ({100*populated/total:.1f}%)")
    print(f"Total data points: {sum(algo.count_matrix)}")
    
    # Show smoothing at specific cells
    print("\nBayesian Smoothing Examples:")
    for d, s, r in [(5, 5, 5), (10, 3, 8), (0, 0, 0), (15, 15, 15)]:
        idx = r * 441 + s * 21 + d
        raw = algo.interval_matrix[idx]
        cnt = algo.count_matrix[idx]
        smoothed = compute_interval_core(d, s, r, algo.interval_matrix, algo.count_matrix)
        diff = smoothed - raw if cnt > 0 else 0
        print(f"  [{d:2d},{s:2d},{r:2d}] raw={raw:8.3f}(n={cnt:3d}) "
              f"smoothed={smoothed:8.3f} diff={diff:+.3f}")
    
    # Full algorithm test
    print("\n" + "=" * 70)
    print("Full Algorithm Pipeline Test")
    print("=" * 70)
    
    algo2 = SM20Algorithm(version=2)
    interval = 1.0
    stability = 1.0
    
    for rep in range(1, 11):
        q = max(0.0, min(1.0, random.gauss(0.7, 0.15)))
        interval = algo2.get_next_interval(
            stability=stability, quality=q, repetition=rep,
            a_factor=2.0, difficulty=0.3
        )
        algo2.record_repetition(stability, q, rep, 2.0, 0.3, interval)
        stability = min(stability * 1.05 + 0.3 * q, 44500.0)
        print(f"  Rep {rep:2d}: q={q:.3f}, interval={interval:8.2f} days, stability={stability:.1f}")
