"""
SM-20 Spaced Repetition Algorithm — Clean Reference Implementation
=================================================================
Reverse-engineered from sm20.exe (SuperMemo 20).

This is a clean, self-contained implementation designed for translation
to other languages (Rust, etc). No test harness, no debug output.

Verified line-by-line against Ghidra decompilation (75 functions, 44K functions
fully decompiled). All three algorithm versions (V2/V4/V6) match exactly.

# DSR Model
SM-20 uses three parameters per item:
  - Stability (S): interval in days that produces 90% recall probability
  - Difficulty (D): how hard an item is, normalized to [0.0, 1.0]
  - Retrievability (R): probability of correct recall, [0.0, 1.0]

# Matrix Layout
Two 21×21×21 matrices indexed as: flat[R × 441 + S × 21 + D]
  R = repetition index (0-20), S = stability index (0-20), D = retrievability category (0-20)
  Index 20 in each dimension is a sentinel (always zero).
  Active range: indices 0..19.

# Algorithm Dispatch
A version byte selects which formula computes intervals:
  - Version 2 (SM-19 compatible): polynomial × exp2
  - Version 4 (SM-20 proper): 7-parameter polynomial
  - Version 6 (FSRS-style): double-exponential
"""

from math import floor, exp, log, nan, isinf

# =============================================================================
# CONSTANTS
# =============================================================================

# Runtime BSS constant — set during SM-20 initialization, may change after
# ML-based hyperparameter optimization on real data.
STABILITY_POWER = 2.90396936502257

# --- V2 Formula (FUN_00ccf070) ---
V2 = {
    "stability_scale_max": 9.29,
    "stability_scale_min": 1.3,
    "anchor": 1.0,
    "rep_power_offset": -0.08,
    "rep_power_coeff": -0.31,
    "base_offset": 1.04,
    "base_bias": 0.07,
    "penalty_slope": -1.88,
    "penalty_intercept": 1.58,
    "penalty_clamp": 600.0,
}

# --- Initial Interval (FUN_00ce1900) — Bayesian prior ---
INIT = {
    "stability_scale_max": 15.0,
    "stability_scale_min": 3.0,
    "anchor": 1.0,
    "rep_power_offset": -0.08,
    "rep_power_coeff": -0.35,
    "base_sub": 1.0,
    "base_add": 1.0,
    "penalty_slope": -2.0,
    "penalty_intercept": 2.25,
    "penalty_clamp": 600.0,
}

# --- Bayesian Core (FUN_00ce1250) ---
BAYES = {
    "prior_weight": 500.0,       # weight_base: Bayesian prior strength
    "target_weight_scale": 10.0,  # min_count: multiplied into target weight
    "neighbor_weight_denom": 1000.0,  # max_weight: denominator for neighbor sigmoid
    "cube_weight": 3.0,            # neighbor weight multiplier in final blend
    "neutral": 1.0,                # baseline weight for initial value
}

# --- Rounding (FUN_00ce8dd0) ---
ROUND_NARROW = (2.0, 0.5)   # (upper, lower) — used when flag bit 1 clear
ROUND_WIDE = (20.0, 0.8)    # (upper, lower) — used when flag bit 1 set

# --- Stability Pre-transform (FUN_00cf7550) ---
STABILITY_LOWER = -1.0
STABILITY_CAP = 0.7
STABILITY_MAX = 44530.0

# --- U-Factor Table (20 values) ---
# Extracted from runtime memory. Indexed by difficulty D (0-19).
# All repetition rows R=0..19 are identical.
UFACTOR = [
    13.822076, 8.212571, 6.056511, 4.879609, 4.126662,
    3.598557, 3.205138, 2.899285, 2.653822, 2.451912,
    2.282528, 2.138131, 2.013379, 1.904376, 1.808207,
    1.722649, 1.645970, 1.576804, 1.514055, 1.456836,
]

# Matrix dimensions
MATRIX_DIM = 21
MATRIX_SIZE = MATRIX_DIM ** 3  # 9261
MATRIX_STRIDE_R = MATRIX_DIM * MATRIX_DIM  # 441
MATRIX_STRIDE_S = MATRIX_DIM  # 21


# =============================================================================
# LOW-LEVEL HELPERS
# =============================================================================

def exp2_clamped(x: float) -> float:
    """2^x clamped to [-38, 38]. Prevents overflow/underflow."""
    x = max(-38.0, min(38.0, x))
    return 2.0 ** x


def sigmoid_weight(x: float, y: float) -> float:
    """x / (x + y). Returns 0 if both zero."""
    s = x + y
    return x / s if s != 0.0 else 0.0


def sign_flip(value: float) -> float:
    """Negate — equivalent to XOR with IEEE 754 negative zero (-0.0)."""
    return -value


def clamp(v: float, lo: float, hi: float) -> float:
    return max(lo, min(hi, v))


# =============================================================================
# INDEX CONVERSIONS
# =============================================================================

def difficulty_to_index(d: float) -> int:
    """
    FUN_00cf6fd0: floor(D * 19) + 1, result in [1, 10].
    D is in [0.0, 1.0]. Values below 0 return index 10 (error).
    """
    if d < 0.0:
        return 10
    return min(10, floor(d * 19.0) + 1)


def stability_to_index(s: float) -> int:
    """
    FUN_00cf7330: Convert stability to matrix index in [1, 20].
    
    Steps:
    1. Pre-transform: clamp S to valid range
    2. Subtract 2.0
    3. Raise to power (1.0 / STABILITY_POWER)  ≈ S^0.344
    4. floor() + 1, clamp to [1, 20]
    """
    s = _stability_pretransform(s)
    diff = s - 2.0
    if diff < 0.0:
        diff = 0.0
    result = diff ** (1.0 / STABILITY_POWER)
    return clamp(floor(result) + 1, 1, 20)


def stability_to_transformed(s_idx: int) -> float:
    """
    FUN_00cf7420: Convert stability INDEX to transformed value.
    pow(s_idx - 1, STABILITY_POWER) + 2.0
    
    Note: Despite the Ghidra label "A-factor", this transforms the stability index.
    FUN_00cf7330 and FUN_00cf7420 are approximate inverses:
      stability_to_index(stability_to_transformed(s)) ≈ s
    """
    return (s_idx - 1) ** STABILITY_POWER + 2.0


def retrievability_to_index(r: float) -> int:
    """
    FUN_00cf7250: floor(exp2(R * 20)), clamped to [0, 20].
    R is retrievability in [0.0, 1.0].
    """
    return clamp(floor(2.0 ** (r * 20.0)), 0, 20)


def difficulty_to_fraction(d_idx: int) -> float:
    """FUN_00cf73d0: D / 20.0"""
    return d_idx / 20.0


def repetition_to_fraction(r: int) -> float:
    """FUN_00cf71c0: (R - 1) / 19, R in [1, 20]"""
    return (r - 1) / 19.0


# =============================================================================
# STABILITY PRE-TRANSFORM
# =============================================================================

def _stability_pretransform(s: float) -> float:
    """
    FUN_00cf7550: Validate and clamp stability.
    
    | Condition             | Action                    |
    |-----------------------|---------------------------|
    | S <= -1.0             | Pass through              |
    | -1.0 < S < 0.7        | Clamp to 0.7              |
    | 0.7 <= S <= 44530     | Pass through              |
    | S > 44530 or NaN/Inf  | Clamp to 44530            |
    """
    if isinf(s) or (s != s):  # NaN check
        return STABILITY_MAX
    if s <= STABILITY_LOWER:
        return s
    if s < STABILITY_CAP:
        return STABILITY_CAP
    if s <= STABILITY_MAX:
        return s
    return STABILITY_MAX


# =============================================================================
# ROUNDING
# =============================================================================

def apply_rounding(interval: float, flags: int) -> float:
    """
    FUN_00ce8dd0: Clamp interval to threshold range.
    
    The `flags` parameter goes through FUN_00d09a40, a complex global flag
    lookup. We detect known call contexts:
      - FUN_00ce1900 passes flags=4 → FUN_00d09a40(4) has bit 1 set → wide thresholds
      - Other callers → check bit 1 directly
    
    Wide mode: [0.8, 20.0]
    Narrow mode: [0.5, 2.0]
    """
    if flags >= 4 or (flags & 2) != 0:
        upper, lower = ROUND_WIDE
    else:
        upper, lower = ROUND_NARROW
    
    if interval > upper:
        return upper
    if interval <= lower and interval != lower:
        return lower
    return interval


# =============================================================================
# INTERVAL FORMULAS
# =============================================================================

def interval_v2(rep_fraction: float, stability_transformed: float, difficulty_fraction: float) -> float:
    """
    FUN_00ccf070: Version 2 interval (SM-19 compatible).
    
    Parameters (pre-converted by matrix builder FUN_00cd6260):
      rep_fraction         = (R - 1) / 19          ∈ [0.0, 1.0]
      stability_transformed = pow(S - 1, 2.904) + 2.0
      difficulty_fraction   = D / 20.0              ∈ [0.05, 1.0]
    
    Formula:
      scale = 1.3 + 7.99 × (1.0 - rep_fraction)
      power = -0.08 + rep_fraction × (-0.23)
      base  = (scale - 1.04) × stability_transformed^power + 0.07
      penalty = clamp(rep_fraction × (-1.88) + 1.58, -∞, 600)
      return base × 2^(−penalty × difficulty_fraction)
    """
    c = V2
    scale = c["stability_scale_min"] + (c["stability_scale_max"] - c["stability_scale_min"]) * (c["anchor"] - rep_fraction)
    power = c["rep_power_offset"] + rep_fraction * (c["rep_power_coeff"] - c["rep_power_offset"])
    base = (scale - c["base_offset"]) * (stability_transformed ** power) + c["base_bias"]
    penalty = min(c["penalty_clamp"], rep_fraction * c["penalty_slope"] + c["penalty_intercept"])
    exponent = sign_flip(penalty) * difficulty_fraction
    return base * exp2_clamped(exponent)


def interval_v4(p1: float, p2: float, p3: float, p4: float, p5: float, p6: float, p7: float) -> float:
    """
    FUN_00ccd8e0: Version 4 interval (SM-20 proper).
    
    return (p3 × p5 + 1.0) × (p1 × p7 + p2) + p4
    """
    return (p3 * p5 + 1.0) * (p1 * p7 + p2) + p4


def interval_v6(p1: float, p2: float, p3: float, p4: float, p5: float, p6: float) -> float:
    """
    FUN_00ccfde0: Version 6 interval (FSRS-style).
    
    return p4 + p1 × 2^(p6) × 2^(−p3 × p5)
    """
    return p4 + p1 * exp2_clamped(p6) * exp2_clamped(sign_flip(p3) * p5)


def interval_initial(rep_fraction: float, stability_transformed: float, difficulty_fraction: float) -> float:
    """
    FUN_00ce1900: Bayesian prior — initial interval per matrix cell.
    Same structure as V2 but different constants. Used by Bayesian core.
    
    Formula:
      scale = 3.0 + 12.0 × (1.0 - rep_fraction)
      power = -0.08 + rep_fraction × (-0.27)
      base  = (scale - 1.0) × stability_transformed^power + 1.0
      penalty = clamp(rep_fraction × (-2.0) + 2.25, -∞, 600)
      result = base × 2^(−penalty × difficulty_fraction)
      result = apply_rounding(result, 4)  // wide mode
      return max(1.0, result)
    """
    c = INIT
    scale = c["stability_scale_min"] + (c["stability_scale_max"] - c["stability_scale_min"]) * (c["anchor"] - rep_fraction)
    power = c["rep_power_offset"] + rep_fraction * (c["rep_power_coeff"] - c["rep_power_offset"])
    base = (scale - c["base_sub"]) * (stability_transformed ** power) + c["base_add"]
    penalty = min(c["penalty_clamp"], rep_fraction * c["penalty_slope"] + c["penalty_intercept"])
    exponent = sign_flip(penalty) * difficulty_fraction
    result = base * exp2_clamped(exponent)
    result = apply_rounding(result, 4)
    return max(1.0, result)


# =============================================================================
# BAYESIAN CORE
# =============================================================================

def bayesian_smooth(
    r_idx: int,
    s_idx: int,
    d_idx: int,
    interval_matrix: list[float],
    count_matrix: list[int],
) -> float:
    """
    FUN_00ce1250: Bayesian 3×3×3 neighbor smoothing.
    
    Given 0-based indices into the 21³ matrices, compute the smoothed
    stability increase factor for cell (r_idx, s_idx, d_idx).
    
    Algorithm:
    1. Compute prior from interval_initial() using reconstructed parameters
    2. Read target cell interval and count
    3. Accumulate 3×3×3 neighbor cube (skip cells where any index == 0)
    4. Blend:
      target_weight   = sigmoid(count, 500) × 10
      neighbor_weight = sigmoid(neighbor_count_sum, 1000)
      avg = (target_interval + weighted_neighbor_sum) / (neighbor_count_sum + 1)
      
      result = (prior + target × target_weight + avg × neighbor_weight × 3) /
               (target_weight + 1.0 + neighbor_weight × 3)
    """
    b = BAYES
    
    # Reconstruct parameters for prior computation (lossy approximation)
    rep_fraction = r_idx / 19.0
    stab_transformed = (s_idx if s_idx > 0 else 0) ** STABILITY_POWER + 2.0
    diff_fraction = (d_idx + 1) / 20.0
    
    prior = interval_initial(rep_fraction, stab_transformed, diff_fraction)
    
    # Target cell
    target_idx = r_idx * MATRIX_STRIDE_R + s_idx * MATRIX_STRIDE_S + d_idx
    target_interval = interval_matrix[target_idx]
    target_count = count_matrix[target_idx]
    
    # 3×3×3 neighbor accumulation
    neighbor_sum = 0.0
    neighbor_count = 0
    
    for nr in range(max(0, r_idx - 1), min(MATRIX_DIM, r_idx + 2)):
        for ns in range(max(0, s_idx - 1), min(MATRIX_DIM, s_idx + 2)):
            for nd in range(max(0, d_idx - 1), min(MATRIX_DIM, d_idx + 2)):
                # Boundary check: skip if any index is 0
                if nr * ns * nd == 0:
                    continue
                
                n_idx = nr * MATRIX_STRIDE_R + ns * MATRIX_STRIDE_S + nd
                c = count_matrix[n_idx]
                if c > 0:
                    neighbor_sum += interval_matrix[n_idx] * c
                    neighbor_count += c
    
    # Weights (verified: cube_weight applied ONLY in final blend, not in weight)
    tw = sigmoid_weight(float(target_count), b["prior_weight"]) * b["target_weight_scale"]
    nw = sigmoid_weight(float(neighbor_count), b["neighbor_weight_denom"])
    
    # Blended average (includes target cell in neighbors)
    total = neighbor_count + 1
    avg = (target_interval + neighbor_sum) / total
    
    numerator = prior + target_interval * tw + avg * nw * b["cube_weight"]
    denominator = tw + b["neutral"] + nw * b["cube_weight"]
    
    if denominator == 0.0:
        return prior
    return numerator / denominator


# =============================================================================
# MATRIX INDEX HELPER
# =============================================================================

def matrix_flat_index(r: int, s: int, d: int) -> int:
    """Convert 3D indices (0-based) to flat array index."""
    return r * MATRIX_STRIDE_R + s * MATRIX_STRIDE_S + d


# =============================================================================
# FULL ALGORITHM
# =============================================================================

def compute_next_interval(
    stability: float,
    difficulty: float,
    repetition: int,
    version: int = 2,
    interval_matrix: list[float] | None = None,
    count_matrix: list[int] | None = None,
) -> float:
    """
    Compute the next repetition interval for an item.
    
    Args:
        stability: Current memory stability in days (e.g. 5.0 means 5-day interval)
        difficulty: Item difficulty in [0.0, 1.0]
        repetition: 1-based repetition number (1 for first review)
        version: Algorithm version (2, 4, or 6)
        interval_matrix: Optional 9261-element float array for Bayesian smoothing
        count_matrix: Optional 9261-element int array for Bayesian smoothing
    
    Returns:
        Next interval in days
    """
    # Pre-transform stability
    stability = _stability_pretransform(stability)
    
    # Convert to matrix indices
    d_idx = clamp(difficulty_to_index(difficulty) - 1, 0, 19)
    s_idx = clamp(stability_to_index(stability) - 1, 0, 19)
    r_idx = clamp(repetition - 1, 0, 19)
    
    # Convert to formula parameters
    rep_frac = repetition_to_fraction(repetition)
    stab_xform = stability_to_transformed(stability_to_index(stability))
    diff_frac = difficulty_to_fraction(difficulty_to_index(difficulty))
    
    # Compute via algorithm version
    if version == 2:
        sinc = interval_v2(rep_frac, stab_xform, diff_frac)
    elif version == 4:
        sinc = interval_v4(diff_frac, stab_xform, 0.8, 0.0, 0.9, stab_xform, float(repetition))
    elif version == 6:
        sinc = interval_v6(stab_xform, 0.8, stab_xform, float(repetition), diff_frac, 0.9)
    else:
        sinc = interval_v2(rep_frac, stab_xform, diff_frac)
    
    # Apply Bayesian smoothing if matrices available
    if interval_matrix is not None and count_matrix is not None:
        smoothed = bayesian_smooth(r_idx, s_idx, d_idx, interval_matrix, count_matrix)
        target_count = count_matrix[matrix_flat_index(r_idx, s_idx, d_idx)]
        if target_count > 0:
            sinc = smoothed
    
    # New stability = old × SInc
    new_stability = stability * sinc
    new_stability = max(1.0, min(STABILITY_MAX, new_stability))
    
    return new_stability


def record_review(
    stability: float,
    difficulty: float,
    repetition: int,
    interval_used: float,
    interval_matrix: list[float],
    count_matrix: list[int],
) -> None:
    """
    Update matrices after a review (incremental average).
    """
    d_idx = clamp(difficulty_to_index(difficulty) - 1, 0, 19)
    s_idx = clamp(stability_to_index(stability) - 1, 0, 19)
    r_idx = clamp(repetition - 1, 0, 19)
    
    idx = matrix_flat_index(r_idx, s_idx, d_idx)
    old_count = count_matrix[idx]
    old_interval = interval_matrix[idx]
    
    count_matrix[idx] = old_count + 1
    interval_matrix[idx] = (old_interval * old_count + interval_used) / (old_count + 1)
