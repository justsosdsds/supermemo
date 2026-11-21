# SM-18 vs SM-20: Algorithm Comparison

A detailed technical comparison of the spaced repetition algorithms in SuperMemo 18 and SuperMemo 20. These are **fundamentally different algorithms** — not incremental improvements but a ground-up rewrite.

## Architecture Differences

| Property | SM-18 | SM-20 |
|----------|-------|-------|
| **Binary** | sm18.exe | sm20.exe |
| **Size** | 12MB (12,366,848 bytes) | 27MB (28,311,552 bytes) |
| **Format** | PE32 i386 (32-bit) | PE32+ AMD64 (64-bit) |
| **Compiler** | Borland C++ Builder / Delphi | Embarcadero Delphi (x86-64) |
| **Functions** | ~16,446 | ~44,478 |
| **ImageBase** | — | `0x400000` (no ASLR) |
| **FPU** | x87 80-bit extended precision | SSE2/AVX 64-bit double |
| **Data format** | External `sm8opt.dat` file | In-memory matrices (no files) |
| **Algorithm versions** | Single version | Three variants (V2/V4/V6) |
| **Quality scale** | 0–5 (grade) | 0.0–1.0 (retrievability) |
| **Difficulty range** | [1, 20] grades | [1, 10] indices |
| **Matrix dimensions** | 20³ = 8,000 SInc cells | 21³ = 9,261 interval cells |
| **Optimization data** | sm8opt.dat (18,876 bytes) | Runtime-allocated matrices |

## Algorithm Flow Comparison

### SM-18 Flow

```
Review item → Grade (0-5)
  ├─ Map grade to retrievability R (hardcoded: 0→0.0, 3→0.9, 5→0.99)
  ├─ Compute bin indices:
  │   D_bin = quantile_lookup(D_raw)              → [1, 20]
  │   S_bin = quantile_lookup(S)                  → [1, 20]
  │   R_bin = quantile_lookup(R)                  → [1, 20]
  ├─ SInc lookup (FUN_008adc74):
  │   ├─ If no data: SInc = 0.07
  │   └─ If data: weighted regression across R bins using sm8opt.dat count arrays
  ├─ S_new = S_old × SInc
  ├─ D_new = f × RepDiff + (1-f) × D_old         (trailing average)
  │   where RepDiff = grade_based_deviation
  ├─ Interval = S × ln(FI) / ln(0.9)             (FI = forgetting index)
  └─ Post-lapse:
      ├─ S_new = max(S × 0.87 / (1 + 0.1×lapses), 0.5)
      └─ Interval = 2.4
```

### SM-20 Flow

```
Review item → Quality (0.0-1.0)
  ├─ Compute bin indices:
  │   D_idx = floor(D × 19) + 1                   → [1, 10]
  │   S_idx = floor((S - 2.0)^(1/2.904)) + 1       → [1, 20]
  │   R_idx = floor(exp2(R × 20.0))                → [0, 20]
  ├─ Stability pre-transform: clamp S to [0.7, 44530]
  ├─ Dispatch based on version byte:
  │   ├─ V2 (FUN_00ccf070): polynomial × exp2 — receives (rep_frac, stab_xform, diff_frac)
  │   ├─ V4 (FUN_00ccd8e0): 7-parameter polynomial
  │   └─ V6 (FUN_00ccfde0): double-exponential FSRS-style
  ├─ Matrix lookup with Bayesian smoothing (FUN_00ce1250):
  │   ├─ Convert indices: rep_frac=(R-1)/19, stab_xform=pow(S-1,2.904)+2, diff_frac=D/20
  │   ├─ Get initial value from FUN_00ce1900(rep_frac, stab_xform, diff_frac)
  │   ├─ Read target cell (interval, count) from 21³ matrix
  │   ├─ Accumulate 3×3×3 neighbor cube
  │   ├─ Compute Bayesian weights (prior=500, min_count=10)
  │   └─ Weighted blend: initial + target + neighbors
  ├─ Apply rounding adjustment (FUN_00ce8dd0)
  └─ Post-lapse:
      ├─ Use post-lapse table 1 (20×20×36) or table 2 (25×24)
      └─ Separate matrix builders for each post-lapse scenario
```

## Key Formula Differences

### Retrievability

| | SM-18 | SM-20 |
|---|---|---|
| **Formula** | `R = 0.9^(t/S)` | Same mathematical model |
| **Implementation** | `exp(t × ln(0.9) / S)` | Same, but stored as 0.0–1.0 directly |
| **Source** | Hardcoded `ln(0.9)` as 80-bit x87 constant | Same formula, SSE2 double |
| **Input** | Computed from grade → R mapping | Quality IS retrievability (0.0–1.0) |

SM-20 skips the grade→R mapping step entirely. The quality parameter is already the retrievability probability.

### Stability Update

| | SM-18 | SM-20 (V2) |
|---|---|---|
| **Formula** | `S_new = S_old × SInc` | `SInc = compute_interval_v2(rep_frac, stab_xform, diff_frac)` |
| **SInc source** | Weighted regression from sm8opt.dat counts | Algorithm formula (polynomial × exp2) + Bayesian matrix smoothing |
| **No-data fallback** | `SInc = 0.07` | FUN_00ce1900 initial value (same formula, different constants) |
| **Complexity** | Simple multiplication | Multi-step: index conversion → formula → Bayesian blend |

SM-18's SInc is looked up from an optimization table. SM-20's V2 computes SInc from first principles using `(rep_fraction, stability_transformed, difficulty_fraction)` as parameters — then the Bayesian core blends it with accumulated matrix data from actual reviews. The first parameter (rep_fraction = (R-1)/19) drives the repetition-dependent behavior, not quality as initially assumed.

### Difficulty Update

| | SM-18 | SM-20 |
|---|---|---|
| **Formula** | `D_new = f × RepDiff + (1-f) × D_old` | `D_idx = floor(D × 19) + 1` |
| **Type** | Continuous trailing average | Binned to [1, 10] |
| **Range** | [1, 20] grades | [1, 10] indices |
| **Granularity** | Fine (20 bins) | Coarser (10 bins) |
| **Update method** | Exponential moving average | Direct floor computation |

SM-18 continuously updates difficulty using an exponential moving average of recent response deviations. SM-20 simply bins the difficulty value — the update mechanism is elsewhere in the binary (not in the core interval functions decompiled).

### Interval Computation

| | SM-18 | SM-20 (V2) |
|---|---|---|
| **Formula** | `Interval = S × ln(FI) / ln(0.9)` | `SInc = base × exp2(-penalty × diff_frac)` where base depends on (rep_frac, stab_xform) |
| **Output** | Absolute interval (days) | Stability increase factor (SInc), blended via Bayesian core |
| **Key params** | Grade → R mapping | (rep_fraction, stability_transformed, difficulty_fraction) |
| **Post-lapse** | `max(S × 0.87 / (1 + 0.1×lapses), 0.5)`, interval=2.4 | Separate post-lapse tables (20×20×36, 25×24) |

SM-18 computes absolute intervals from stability and forgetting index. SM-20 V2 computes a SInc (stability increase factor) for each (R,S,D) cell, which the Bayesian core blends with accumulated data before being used to update stability.

## Data Storage Differences

### SM-18: sm8opt.dat

External binary file, 18,876 bytes (0x49BC), stored in the collection directory:

| Offset | Field | Size | Description |
|--------|-------|------|-------------|
| 0x0000 | A-factor grid | 20×20 uint16 | Optimization values |
| 0x0320 | A-factor grid (dup) | 20×20 uint16 | Duplicate |
| 0x2f6 | R-factor table | uint16 | Per (S,D) |
| 0x2f8 | D-factor opt values | uint16×20 | Regression data |
| 0x616 | Case counts | uint16 | Reviews per (S,D) |
| 0x808 | SInc count array 1 | 8000 bytes | 20×20×20 byte counts (numerator) |
| 0x2748 | SInc count array 2 | 8000 bytes | 20×20×20 byte counts (denominator) |
| 0x4826 | D-quantile boundaries | 120 bytes | 3×uint16×20 |
| 0x48a2 | S-quantile values | 40 bytes | uint16×20 |
| 0x4980 | Study counts | 40 bytes | uint16×20 |

The two byte count arrays at 0x808 and 0x2748 are the core optimization data. Their ratio (count1/count2) drives the weighted regression for SInc.

### SM-20: In-Memory Matrices

All data lives in process memory, allocated at runtime:

| Address | Matrix | Size | Type |
|---------|--------|------|------|
| 0x011240a8 | Interval matrix | 9261 doubles | 21³ (R×S×D) |
| 0x011228c8 | Count matrix | 9261 int32s | 21³ (R×S×D) |
| 0x01124138 | U-factor table | 441 doubles | 21×21 |
| 0x011238e8 | Post-lapse 1 | 14400 doubles | 20×20×36 |
| 0x011250c8 | Post-lapse 2 | 600 doubles | 25×24 |

No external files. Matrices are built at startup from algorithm computation and populated as reviews accumulate.

## Precision Differences

### SM-18: x87 80-bit Extended Precision

The 32-bit x87 FPU uses 80-bit registers:

```
Sign: 1 bit
Exponent: 15 bits (bias 16383)
Mantissa: 64 bits (explicit integer bit)
Precision: ~19 decimal digits
```

Key constants are encoded as 80-bit values inline in x87 instructions:
- `FLDZ` / `FLD1` / `FLDL2E` etc.
- 80-bit immediate values pushed directly onto the x87 stack
- Results maintained at 80-bit precision until stored to memory (truncated to 64-bit double)

This gives SM-18 slightly higher intermediate precision for multi-step calculations, though the final results are still 64-bit doubles when stored.

### SM-20: SSE2 64-bit Double

The 64-bit x86-64 ABI uses SSE2 for all floating-point:

```
Sign: 1 bit
Exponent: 11 bits (bias 1023)
Mantissa: 52 bits (implicit integer bit)
Precision: ~15-16 decimal digits
```

All intermediate and final values are 64-bit doubles. No extended precision is available — SSE2 doesn't support it. The `exp2` and `pow2` functions in SM-20 use software implementations (Cody-Waite range reduction) rather than x87 hardware.

### Practical Impact

For the algorithms in question (polynomials, exp2, weighted averages), the precision difference is negligible. The dominant error source is the discretization into matrix bins, not floating-point rounding.

## Quality / Grade Scale

This is the most user-visible difference:

| Grade | SM-18 Grade | SM-18 R | SM-20 Quality |
|-------|-------------|---------|---------------|
| Complete blackout | 0 | 0.0 | 0.0 |
| Failed | 1 | 0.0 | 0.0 |
| Very hard | 2 | 0.0 | ~0.1–0.3 |
| Hard | 3 | 0.9 | ~0.5–0.7 |
| Good | 4 | 0.95 | ~0.8–0.9 |
| Bright / Perfect | 5 | 0.99 | 1.0 |

SM-18 maps discrete grades (0-5) to fixed R values via a hardcoded lookup. SM-20 uses quality as a continuous 0.0–1.0 parameter — likely computed from response time and other heuristics, not just button press.

**Implication**: SM-20 can distinguish between "barely remembered" (R=0.91) and "confidently remembered" (R=0.99) — both map to grade 5 in SM-18.

## Bayesian Smoothing

### SM-18: Weighted Regression Across R Bins

```
For each (S_bin, D_bin):
  For each R_bin 1..20:
    interval = quantile_table_lookup(S_bin, R_bin)
    ratio = count_0x808[S,D,R] / count_0x2748[S,D,R]
    log_ratio = ln(ratio), clamped >= -2.125
  SInc = -weighted_regression(intervals, log_ratios, counts)
```

SM-18 performs a **weighted linear regression** of log-ratios against intervals across all retrievability bins. The regression slope gives the decay rate, which determines SInc.

### SM-20: 3×3×3 Neighbor Cube Bayesian Blend

```
For cell (R, S, D):
  rep_frac = (R-1)/19
  stab_xform = pow(S-1, 2.904) + 2.0
  diff_frac = D / 20.0
  initial = FUN_00ce1900(rep_frac, stab_xform, diff_frac)  [formula prior]
  target = matrix[R,S,D]                  (cell value)
  neighbors = Σ matrix[nr,ns,nd]×count[nr,ns,nd]  (3×3×3 cube)
  w_target = (count / (count + 500)) × 10
  w_neighbor = (total_count / (total + 1000)) × 3
  result = (initial + target×w_target + avg×w_neighbor×3) / (w_target + 1 + w_neighbor×3)
```

SM-20 uses **Bayesian smoothing** with a strong prior (weight=500) and neighbor averaging. The prior value comes from FUN_00ce1900 — a modified V2 formula with different constants (iv1=15, iv2=3, iv6=-2, iv7=2.25) that computes a "first-principles" interval for each cell.

| Property | SM-18 | SM-20 |
|----------|-------|-------|
| Method | Weighted regression | Bayesian neighbor averaging |
| Prior weight | None (pure regression) | 500 (strong prior) |
| Neighbor contribution | None (cell-independent) | 3×3×3 cube averaging |
| Sparse data handling | Falls back to 0.07 | Falls back to FUN_00ce1900 formula (no table) |
| Count arrays | Two byte arrays (8000 bytes each) | Single int32 array (37KB) |

## Post-Lapse Behavior

### SM-18

```python
S_new = max(S * 0.87 / (1 + 0.1 * lapses), 0.5)
interval = 2.4  # Fixed post-lapse interval
```

Simple and deterministic. Stability decays by 13% per lapse (modified by lapse count). Always restarts at 2.4 days.

### SM-20

Two separate post-lapse tables:
- **Table 1** (20×20×36 = 14,400 cells): indexed by (R, S, D) with a 36-entry sub-dimension
- **Table 2** (25×24 = 600 cells): indexed by (R, S) with different dimensions

Built by separate functions (`FUN_00cd41d0`, `FUN_00cd7b60`) with dedicated helpers. The post-lapse interval depends on the item's current state (R, S, D) rather than being a fixed constant.

| Property | SM-18 | SM-20 |
|----------|-------|-------|
| Formula | Deterministic (S×0.87/(1+0.1×lapses)) | Table lookup |
| Post-lapse interval | Fixed 2.4 days | Variable (from table) |
| Lapse counting | Explicit lapse counter | Implicit in matrix indices |
| Tables | None | 2 tables (14,400 + 600 cells) |

## What Changed and Why (SM-17 → 18 → 19 → 20 Evolution)

### SM-17 → SM-18

- **Minor refinements** to the SM-17 algorithm
- Same sm8opt.dat structure, same DSR model, same grade scale
- Improved optimization algorithm (better regression)
- This was an incremental update, not a rewrite

### SM-18 → SM-19 (V2 in SM-20)

- **Quality scale change**: 0-5 grades → 0.0-1.0 retrievability
  - Reason: Continuous quality enables finer-grained interval adjustment
- **U-factor computation**: Instead of SInc from sm8opt.dat, compute from first principles
  - Reason: Reduce dependence on collection-specific optimization data
- **DSR model retained**: Still uses Difficulty/Stability/Retrievability
- **V2 in SM-20 is the SM-19 algorithm** — it was included for backward compatibility

### SM-19 → SM-20 (V4 and V6 in SM-20)

- **V4 (7-parameter polynomial)**: Clean mathematical formulation
  - Reason: More interpretable parameters, easier to optimize
  - Formula: `(p3*p5 + 1)*(p1*p7 + p2) + p4`
- **V6 (double-exponential)**: Inspired by FSRS (Free Spaced Repetition Scheduler)
  - Reason: Better fit to empirical forgetting curve data
  - Formula: `p4 + p1*exp2(p6)*exp2(-p3*p5)`
- **In-memory matrices**: No more sm8opt.dat
  - Reason: Delphi x86-64 uses different serialization; matrices built at runtime
- **21³ matrix**: Expanded from 20³ to 21³ (9261 cells)
  - Reason: Extra row/column for boundary handling
- **Bayesian smoothing**: Replaced weighted regression
  - Reason: More robust to sparse data, better mathematical properties
- **Difficulty [1,10]**: Halved from [1,20]
  - Reason: 10 bins sufficient for DSR model; reduces matrix sparsity
- **SSE2 math**: Replaced x87 FPU
  - Reason: x86-64 ABI mandates SSE2; no x87 available in 64-bit mode

### Summary of Philosophical Shift

| Aspect | SM-18 Philosophy | SM-20 Philosophy |
|--------|-----------------|-----------------|
| **Data** | Collection-specific optimization files | Universal in-memory computation |
| **Quality** | Discrete grades (human input) | Continuous retrievability (computed) |
| **Smoothing** | Statistical regression | Bayesian with strong prior |
| **Extensibility** | Single algorithm | Three switchable variants |
| **Precision** | x87 extended (backward compat) | SSE2 (modern) |
| **Complexity** | Moderate (regression + binning) | High (Bayesian + multi-version) |

SM-18 trusts the optimization data (sm8opt.dat) to personalize intervals per collection. SM-20 trusts the algorithm formula more and uses Bayesian smoothing to handle sparse data, making it more portable but potentially less personalized for well-trained collections.

## Quick Reference: Key Constants Side-by-Side

| Concept | SM-18 | SM-20 |
|---------|-------|-------|
| Default SInc / initial | 0.07 | FUN_00ce1900 formula (per-cell computation) |
| Post-lapse stability mod | 0.87 | Separate tables |
| Post-lapse interval | 2.4 days | Variable (from table) |
| Forgetting index target | 0.10 (90% retention) | 0.90 (R target) |
| Bayesian prior | None | 500 (strong prior per cell) |
| Prior source | N/A | FUN_00ce1900 (modified V2 with iv constants) |
| Min count for weighting | 0 | 10 |
| Matrix dimensions | 20³ | 21³ |
| Difficulty grades | 20 | 10 |
| Quality values | 6 (0-5) | Continuous (0.0-1.0) |
| Max stability | Unlimited | 44,530 days (~122 years) |
| Stability valid range | Any positive | [0.7, 44530] |
| Runtime BSS constant | None | DAT_0127cb08 = 2.904 (stability power) |