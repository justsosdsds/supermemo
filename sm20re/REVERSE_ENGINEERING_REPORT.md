# SuperMemo SM-20 Algorithm — Reverse Engineering Report

## Overview

Complete reverse engineering of the SM-20 spaced repetition algorithm from `sm20.exe` (27MB PE32+ x86-64 Delphi). This binary represents a **fundamentally different algorithm** from SM-18 — a ground-up rewrite with a DSR (Difficulty/Stability/Retrievability) model, three algorithm variants, in-memory Bayesian-smoothed matrices, and a 0.0–1.0 quality scale.

**Target binary**: sm20.exe (SuperMemo 20)
**Binary size**: 28,311,552 bytes (27MB)
**Architecture**: PE32+ AMD64 (64-bit x86-64)
**Compiler**: Embarcadero Delphi (x86-64 target)
**Total functions**: ~44,478 (massive Delphi runtime)
**ImageBase**: `0x400000` (no ASLR)
**Data section**: `.data` at high VA (0x01000000+)

## Methodology

### Static Analysis (Ghidra 12.x + pyghidra 3.x)

1. **Initial import**: Ghidra on remote x86 Linux (Ubuntu, 31GB RAM). Delphi binaries produce enormous function counts (~44K) due to verbose RTL codegen.
2. **RTTI adjacency heuristic**: Delphi stores method names in `.rsrc` string tables but Ghidra cannot cross-reference them to code. Solution: scan `.rsrc` for pointers within ±1024 bytes of method name strings to locate class VMTs, then follow VMT pointers to method addresses.
3. **pyghidra headless decompilation**: 75+ functions across two batches (55 initial + 20 extra), totaling 100K+ lines of C pseudocode.
4. **PE address mapping**: `PE_VA = Ghidra_addr - 0x400000`. Ghidra's default image base is 0x100000; SM20 uses 0x400000. All function addresses reported are Ghidra addresses; subtract 0x400000 for PE file offsets.

### Runtime Analysis (Wine + /proc/pid/mem)

5. **Wine execution**: sm20.exe runs under Wine 11.5 on Linux x86-64 with Xvfb for headless display.
6. **GDB limitation**: Linux `ptrace` cannot attach to Wine processes for memory inspection. GDB's `x/` commands fail.
7. **`/proc/pid/mem` workaround**: Direct `pread()` on `/proc/<pid>/mem` at known VA offsets reads Wine process memory correctly. Used to extract:
   - U-factor table (21×20 doubles at `0x01124138`)
   - Interval matrix (21³ = 9261 doubles at `0x011240a8`)
   - Count matrix (21³ = 9261 int32s at `0x011228c8`)
   - Post-lapse tables at `0x011238e8` and `0x011250c8`
   - All algorithm constants at their static addresses

### Disassembly (Capstone)

8. **RIP-relative addressing**: x86-64 code uses `[rip + displacement]` extensively. Capstone with `X86_REG_RIP` base detection resolves these to absolute VA addresses.
9. **Constant mining**: Iterated through all `movsd xmm, [rip+disp]` instructions in algorithm functions to extract every embedded double constant.

## Algorithm Summary

### DSR Model

SM-20 uses the **Difficulty/Stability/Retrievability** (DSR) model — a three-component representation of long-term memory:

- **Stability (S)**: Inter-repetition interval producing 90% recall probability (in days)
- **Retrievability (R)**: Current expected probability of recall at time `t`
- **Difficulty (D)**: Maximum possible stability increase, normalized to [0.0, 1.0]

### Algorithm Dispatch

A single version byte at `DAT_0122e192` (default: 2, set by `FUN_00ccd1e0`) selects which algorithm variant computes intervals. `FUN_00ccfe80` reads this byte and dispatches:

| Version | Function | Name | Description |
|---------|----------|------|-------------|
| V2 | `FUN_00ccf070` | SM-19 compatible | Polynomial stability_scale × exp2 quality penalty |
| V4 | `FUN_00ccd8e0` | SM-20 proper | 7-parameter polynomial |
| V6 | `FUN_00ccfde0` | FSRS-style | Double-exponential with sign-flip |

### Quality Scale

**Critical difference from SM-18**: Quality is **0.0 to 1.0** (retrievability probability), not 0–5 (grade scale).

### Version 2 Formula (FUN_00ccf070)

The V2 formula computes the **stability increase factor** (SInc) for each matrix cell. It is NOT called directly with quality/retrievability — instead, the matrix builder (FUN_00cd6260) calls it with pre-converted parameters:

```
param_1 = FUN_00cf71c0(R) = (R - 1) / 19          [repetition fraction, 0.0 to 1.0]
param_2 = FUN_00cf7420(S) = pow(S - 1, 2.904) + 2.0 [transformed stability index]
param_3 = FUN_00cf73d0(D) = D / 20.0                [difficulty fraction, 0.0 to 1.0]
```

Where R, S, D are discrete indices (1–20 each) that enumerate the matrix axes.

The formula itself:

```
stability_scale = c2 + (c1 - c2) × (c3 - param_1)        [c1=9.29, c2=1.3, c3=1.0]
rep_power       = c4 + param_1 × (c5 - c4)               [c4=-0.08, c5=-0.31]
rep_factor      = param_2^max(0.001, rep_power)
base            = (stability_scale - c6) × rep_factor + c7   [c6=1.04, c7=0.07]
penalty         = min(c10, param_1 × c8 + c9)             [c8=-1.88, c9=1.58, c10=600]
exponent        = -penalty × param_3                      (XOR sign flip with -0.0)
result          = base × exp2(exponent)
```

**Key insight**: `param_1` (repetition fraction) drives the formula, not quality. Higher repetitions → smaller `param_1` range → shorter stability increases. The formula computes how much stability grows per repetition, indexed by (R, S, D).

**Note on DAT_0127cb08**: The stability power exponent `2.904` in `FUN_00cf7420` is a **runtime BSS constant** (zero-initialized in the binary, set during SM-20 initialization or optimization). Extracted via `/proc/pid/mem`.

### Version 4 Formula (FUN_00ccd8e0)

A clean 7-parameter polynomial:

```
result = (p3 × p5 + 1) × (p1 × p7 + p2) + p4
```

Parameters map to DSR model variables (D, S, R, quality, a_factor, etc.). The `+1` is a constant at Ghidra address `0x00ccd908`.

### Version 6 Formula (FUN_00ccfde0)

FSRS-inspired double-exponential:

```
e1     = exp2(p6)
e2     = exp2(-p3 × p5)          (sign flip via XOR -0.0)
result = p4 + p1 × e1 × e2
```

### Initial Interval (FUN_00ce1900)

For the Bayesian prior (initial value) in each matrix cell. Same formula structure as V2 but different constants:

```
param_1 = rep_frac = (R-1)/19          [repetition fraction]
param_2 = pow(S-1, 2.904) + 2.0        [transformed stability]  
param_3 = D/20.0                        [difficulty fraction]

stability_scale = 3.0 + 12.0 × (1.0 - param_1)
rep_power       = -0.08 + param_1 × (-0.35 + 0.08) = -0.08 + param_1 × (-0.27)
base            = (stability_scale - 1.0) × param_2^rep_power + 1.0
penalty         = min(600, param_1 × (-2.0) + 2.25)
result          = base × exp2(-penalty × param_3)    [after rounding adjustment]
```

Note: This function is called from `FUN_00ce1250` (the Bayesian core) for each cell, not just for "initial" items.

### Initial Interval Constants (FUN_00ce1900)

Before matrix lookup, stability is validated and clamped:

| Condition | Action |
|-----------|--------|
| stability ≤ -1.0 | Pass through unchanged |
| -1.0 < stability < 0.7 | Clamp to 0.7 (mark error) |
| 0.7 ≤ stability ≤ 44530 | Pass through unchanged |
| stability > 44530 | Clamp to 44530 (mark error) |
| NaN or Inf | Clamp to 44530 (mark error) |

Valid range: [0.7, 44530]. Stability values below 0.7 are rare but possible for newly created items.

## Matrix Layout

### Primary Interval Matrix (21³)

Built by `FUN_00cd6260`, stored at runtime address `0x011240a8`:

- **Dimensions**: 21 × 21 × 21 = **9,261 cells** (double-precision floats, 74,088 bytes)
- **Indexing**: `flat[R × 441 + S × 21 + D]` — R slowest, D fastest
- **Ranges**: R = 0..20, S = 0..20, D = 0..20 (index 20 is sentinel, value 0)
- **Active range**: indices 0..19 for all dimensions

### Primary Count Matrix (21³)

Parallel to the interval matrix, stored at `0x011228c8`:

- **Dimensions**: 21 × 21 × 21 = **9,261 cells** (int32, 37,044 bytes)
- **Same indexing**: `flat[R × 441 + S × 21 + D]`

### Post-Lapse Tables

| Table | Dimensions | Size | Address | Builder Function |
|-------|-----------|------|---------|-----------------|
| Post-lapse 1 | 20 × 20 × 36 | 14,400 doubles | `0x011238e8` | `FUN_00cd41d0` |
| Post-lapse 2 | 25 × 24 | 600 doubles | `0x011250c8` | `FUN_00cd7b60` |

## Bayesian Smoothing (FUN_00ce1250)

The core computation applies 3×3×3 neighbor cube Bayesian smoothing to prevent sparse-data corruption:

```
For cell (R, S, D):
  1. Get initial value from FUN_00ce1900 (same formula as V2 with different constants):
       rep_frac = (R-1)/19, stab_xform = pow(S-1, 2.904)+2, diff_frac = D/20
       initial = FUN_00ce1900(rep_frac, stab_xform, diff_frac)
  2. Read target cell: (target_interval, target_count) = matrix[R,S,D]
  3. Accumulate 3×3×3 neighbor cube:
     - Iterate nr ∈ [R-1, R+1], ns ∈ [S-1, S+1], nd ∈ [D-1, D+1]
     - Skip cells where (nr+1)(ns+1)(nd+1) == 0 (boundary)
     - Accumulate: sum += interval[nr,ns,nd] × count[nr,ns,nd]
     - count_sum += count[nr,ns,nd]
  4. Compute Bayesian weights:
     target_weight   = (target_count / (target_count + 500)) × 10
     neighbor_weight = (count_sum / (count_sum + 1000)) × 3
  5. Weighted blend:
     numerator   = initial + target_interval × target_weight + avg × neighbor_weight × 3
     denominator = target_weight + 1 + neighbor_weight × 3
     result      = numerator / denominator
```

**Parameters**:

| Parameter | Value | Address | Description |
|-----------|-------|---------|-------------|
| weight_base | 500.0 | `0xce1820` | Bayesian prior weight |
| min_count | 10.0 | `0xce1828` | Minimum count for target weight |
| max_weight | 1000.0 | `0xce1830` | Maximum neighbor weight denominator |
| cube_weight | 3.0 | `0xce1838` | 3×3×3 neighbor cube weight multiplier |
| neutral_weight | 1.0 | `0xce1840` | Baseline weight (denominator offset) |

## U-Factor Table

20 values indexed by difficulty (D = 0..19). All repetition rows R = 0..19 are identical; R = 20 is all zeros (terminator).

Extracted from runtime memory at `PTR_DAT_0x01124138`:

| D | U-Factor | D | U-Factor | D | U-Factor |
|---|----------|---|----------|---|----------|
| 0 | 13.822076 | 7 | 2.899285 | 14 | 1.808207 |
| 1 | 8.212571 | 8 | 2.653822 | 15 | 1.722649 |
| 2 | 6.056511 | 9 | 2.451912 | 16 | 1.645970 |
| 3 | 4.879609 | 10 | 2.282528 | 17 | 1.576804 |
| 4 | 4.126662 | 11 | 2.138131 | 18 | 1.514055 |
| 5 | 3.598557 | 12 | 2.013379 | 19 | 1.456836 |
| 6 | 3.205138 | 13 | 1.904376 | | |

These represent the expected interval growth factor for each difficulty bin. D=0 (easiest) grows intervals by 13.8×; D=19 (hardest) by only 1.46×.

## Index Conversions

SM-20 converts continuous DSR values to discrete matrix indices:

| Conversion | Function | Formula | Range |
|-----------|----------|---------|-------|
| Difficulty → Index | `FUN_00cf6fd0` | `floor(D × 19) + 1` | [1, 10] |
| Stability → Index | `FUN_00cf7330` | `floor((S - 2.0)^(1.0/2.904)) + 1` | [1, 20] |
| Repetition → 0..1 | `FUN_00cf71c0` | `(rep - 1) / 19` | [0.0, ~1.0] |
| Repetition → 0..1 (alt) | `FUN_00cf71f0` | `(rep - 1) / 23` | [0.0, ~1.0] |
| Stability → Value | `FUN_00cf7420` | `pow(S - 1, 2.904) + 2.0` | varies |
| Retrievability → Index | `FUN_00cf7250` | `floor(exp2(R × 20.0))` | [0, 20] |
| Difficulty → Fraction | `FUN_00cf73d0` | `D / 20.0` | [0.05, 1.0] |

Note: SM-18 difficulty maps to [1, 20] grades; SM-20 maps to [1, 10] (halved granularity).
Note: `FUN_00cf7420` (previously labeled "A-factor → value") actually transforms the **stability index** S, not the A-factor. The power exponent 2.904 is a runtime BSS constant (`DAT_0127cb08`).
Note: `FUN_00cf7330` uses the inverse power `1.0/2.904 ≈ 0.344` for converting stability to matrix index.

## Exact Constants (from static binary)

### Version 2 (FUN_00ccf070)

| Constant | Value | Ghidra Address | IEEE 754 (double) |
|----------|-------|---------------|-------------------|
| c1 (stability_scale max) | 9.29 | `0x00ccf150` | — |
| c2 (stability_scale min) | 1.3 | `0x00ccf158` | — |
| c3 (param_1 anchor) | 1.0 | `0x00ccf160` | `0x3ff0000000000000` |
| c4 (rep power offset) | -0.08 | `0x00ccf168` | — |
| c5 (rep power param_1 coeff) | -0.31 | `0x00ccf170` | — |
| c6 (base interval offset) | 1.04 | `0x00ccf178` | — |
| c7 (base interval bias) | 0.07 | `0x00ccf180` | `0x3fc1eb851eb851ec` |
| c8 (penalty slope) | -1.88 | `0x00ccf188` | — |
| c9 (penalty intercept) | 1.58 | `0x00ccf190` | — |
| c10 (penalty clamp) | 600.0 | `0x00ccf198` | `0x4082c00000000000` |

### Initial Interval (FUN_00ce1900)

| Constant | Value | Ghidra Address |
|----------|-------|---------------|
| iv1 (stability_scale max) | 15.0 | `0x00ce1a00` |
| iv2 (stability_scale min) | 3.0 | `0x00ce1a08` |
| iv3 (quality anchor) | 1.0 | `0x00ce1a10` |
| iv4 (rep power offset) | -0.08 | `0x00ce1a18` |
| iv5 (rep power quality coeff) | -0.35 | `0x00ce1a20` |
| iv6 (base interval offset) | -2.0 | `0x00ce1a28` |
| iv7 (base interval bias) | 2.25 | `0x00ce1a30` |
| iv8 (quality penalty clamp) | 600.0 | `0x00ce1a38` |

### Core Bayesian Computation (FUN_00ce1250)

| Constant | Value | Ghidra Address |
|----------|-------|---------------|
| weight_base | 500.0 | `0x00ce1820` |
| min_count | 10.0 | `0x00ce1828` |
| max_weight | 1000.0 | `0x00ce1830` |
| cube_weight | 3.0 | `0x00ce1838` |
| neutral_weight | 1.0 | `0x00ce1840` |

### Stability Pre-Transform (FUN_00cf7550)

| Constant | Value | Ghidra Address |
|----------|-------|---------------|
| lower threshold | -1.0 | `0x00cf7560` |
| clamp to | 0.7 | `0x00cf7568` |
| max stability | 44530.0 | `0x00cf7570` |

Valid range: [0.7, 44530]. Values below 0.7 are clamped (newly created items).

### Runtime BSS Constants

Zero-initialized in the binary (BSS section), set at runtime by SM-20's initialization or optimization:

| Constant | Value | Ghidra Address | Used By | Description |
|----------|-------|---------------|---------|-------------|
| stability_power | 2.90396936502257 | `0x0127cb08` | `FUN_00cf7330`, `FUN_00cf7420` | Power exponent for stability↔index conversion |

⚠️ **This value may change** after SM-20's ML-based hyperparameter optimization runs on real repetition data. The extracted value (2.904) is from a fresh collection with no training history.

### Rounding Adjustment (FUN_00ce8dd0)

| Constant | Value | Condition |
|----------|-------|-----------|
| flag0_upper | 2.0 | bit 2 clear, interval > 2.0 |
| flag0_lower | 0.5 | bit 2 clear, interval ≤ 0.5 |
| flag2_upper | 20.0 | bit 2 set, interval > 20.0 |
| flag2_lower | 0.8 | bit 2 set, interval ≤ 0.8 |

### Version Dispatch

| Value | Constant | Address | Description |
|-------|----------|---------|-------------|
| -0.0 | `-0.0` | `0x00ccfe70` | V6 XOR key (sign bit flip) |
| 1.0 | `1.0` | `0x00ccd908` | V4 constant added to (p3*p5+...) |

### Metric Computation (FUN_00cf9070)

| Constant | Value | Description |
|----------|-------|-------------|
| d1 | 0.9999 | Max retrievability ratio |
| d2 | 0.1 | Minimum ratio |
| d3 | 0.0 | Zero threshold |
| d4 | 0.99 | Good ratio threshold |
| d5 | 0.07 | Time power |
| d6 | 0.9 | Target FI |
| d7 | 365.0 | Days per year |
| d8 | 100.0 | Weight denominator |
| d9 | 1.0 | Weight base |
| d10 | 50.0 | Final blend weight |

## Key Decompiled Functions

### Core Algorithm

| Ghidra Address | Descriptive Name | Size | Description |
|---------------|-----------------|------|-------------|
| `0x00ccfe80` | Algorithm dispatch | ~5.6KB | Reads version byte, calls V2/V4/V6 |
| `0x00ccd1e0` | Set version (V2) | ~420B | Sets `DAT_0122e192 = 2` |
| `0x00ccf070` | V2 interval | ~560B | SM-19 compatible polynomial+exp2 |
| `0x00ccd8e0` | V4 interval | ~260B | 7-parameter polynomial |
| `0x00ccfde0` | V6 interval | ~330B | Double-exponential FSRS-style |
| `0x00ccb8d0` | Version selector | ~160B | Pre-dispatch version check |

### Matrix Construction

| Ghidra Address | Descriptive Name | Size | Description |
|---------------|-----------------|------|-------------|
| `0x00cd6260` | Matrix builder | ~13KB | Builds 21³ interval+count matrices |
| `0x00cd47e0` | Matrix helper | ~5KB | Index conversion for matrix |
| `0x00ce1250` | Core Bayesian | ~12KB | 3×3×3 neighbor smoothing |
| `0x00cd87f0` | Post-lapse helper 2 | ~11KB | Builds U-factor table |
| `0x00cd4160` | Fill post-lapse | ~260B | Fills post-lapse array |

### Post-Lapse

| Ghidra Address | Descriptive Name | Size | Description |
|---------------|-----------------|------|-------------|
| `0x00cd41d0` | Post-lapse 1 builder | ~10KB | Builds 20×20×36 table |
| `0x00cd7b60` | Post-lapse 2 builder | ~6KB | Builds 25×24 table |
| `0x00cd7f70` | Post-lapse 2 helper | ~6.7KB | Helper for post-lapse 2 |
| `0x00cd8280` | Post-lapse 2 init | ~1KB | Initializes post-lapse 2 |

### Index Conversions

| Ghidra Address | Descriptive Name | Size | Description |
|---------------|-----------------|------|-------------|
| `0x00cf6fd0` | Difficulty → index | ~40B | `floor(D*19)+1`, range [1,10] |
| `0x00cf7330` | Stability → index | ~40B | `floor((S-2.0)^(1/2.904))+1`, range [1,20] |
| `0x00cf71c0` | Repetition → 0..1 | ~40B | `(rep-1)/19` |
| `0x00cf71f0` | Repetition → 0..1 (alt) | ~40B | `(rep-1)/23` |
| `0x00cf7420` | Stability → value | ~40B | `pow(S-1, 2.904)+2.0` (NOT A-factor despite name) |
| `0x00cf7250` | R → index | ~40B | `floor(exp2(R*20))`, [0,20] |
| `0x00cf73d0` | D → fraction | ~40B | `D / 20.0` |
| `0x00cf6f90` | Index clamping | ~40B | General bounds check |
| `0x00cf6fc0` | Index clamping | ~40B | General bounds check |

### Interval Helpers

| Ghidra Address | Descriptive Name | Size | Description |
|---------------|-----------------|------|-------------|
| `0x00ce1900` | Bayesian prior interval | ~760B | FUN_00ce1900 called from Bayesian core for each cell's initial value |
| `0x00ce8dd0` | Rounding adjustment | ~570B | Clamp interval to thresholds |
| `0x00ce2910` | Metric result | ~3.1KB | Algorithm accuracy metric |
| `0x00cf7550` | Stability pre-transform | ~650B | Validate/clamp stability |
| `0x00cf9070` | Metric computation | ~6.3KB | Cross-algorithm comparison metric |

### Math Primitives

| Ghidra Address | Descriptive Name | Size | Description |
|---------------|-----------------|------|-------------|
| `0x00f614b0` | exp2 clamped | ~1.2KB | `2^x` clamped to [-38, 38] |
| `0x0040b0e0` | exp2 full | ~1KB | Software exp2 with Cody-Waite |
| `0x004772a0` | pow2 | ~560B | `x^y` via `2^(y*log2(x))` |
| `0x00f6ae80` | sigmoid weight | ~170B | `x / (x + y)` |

### Delphi RTL / Utility

| Ghidra Address | Descriptive Name | Size | Description |
|---------------|-----------------|------|-------------|
| `0x0040c140` | Delphi RTL | — | Runtime library |
| `0x004140a0` | Delphi RTL | — | Runtime library |
| `0x00414730` | Delphi RTL | — | Runtime library |
| `0x00477180` | Delphi RTL | — | Runtime library |
| `0x005d8470` | String handling | — | Delphi string ops |
| `0x009affb0` | Delphi RTL | — | Runtime library |
| `0x00b6ff90` | Exception handler | — | Delphi exception frame |
| `0x00c04160` | Memory allocator | — | Delphi heap management |
| `0x00c05ae0` | Memory allocator | — | Delphi heap management |
| `0x00c06090` | Memory allocator | — | Delphi heap management |
| `0x00c07370` | Memory allocator | — | Delphi heap management |
| `0x00c07f40` | Memory allocator | — | Delphi heap management |
| `0x00c08ab0` | Memory allocator | — | Delphi heap management |
| `0x00d55170` | Float formatting | — | Delphi float-to-string |
| `0x00d672f0` | Float formatting | — | Delphi float-to-string |
| `0x00d6d520` | Float formatting | — | Delphi float-to-string |
| `0x00d6ddb0` | Float formatting | — | Delphi float-to-string |
| `0x00d6e2f0` | Float formatting | — | Delphi float-to-string |
| `0x00d6e310` | Float formatting | — | Delphi float-to-string |
| `0x00d70e80` | Float formatting | — | Delphi float-to-string |
| `0x00d75fd0` | Float formatting | — | Delphi float-to-string |
| `0x00d7d4c0` | Float formatting | — | Delphi float-to-string |

## PE Memory Layout under Wine

```
0x00400000  ┌─────────────────────┐
            │  .text (code)       │  All algorithm functions here
            │  ~50MB executable   │
            │                     │
0x01000000  │  .data section      │  All constants (doubles, ints)
            │  Interval matrices  │  Allocated at runtime in BSS-like region
            │  Count matrices     │
0x011228c8  │  Count matrix       │  int32[9261] (21³)
0x011238e8  │  Post-lapse table 1 │  double[14400] (20×20×36)
0x011239f0  │  Matrix 2           │  int32[9261] or similar
0x011240a8  │  Interval matrix    │  double[9261] (21³)
0x01124138  │  U-factor table     │  double[441] (21×21)
0x011250c8  │  Alt table          │  double[600] (25×24)
            │  .rsrc (resources)  │  Delphi RTTI, form data, string tables
            │  .reloc             │  Relocations (minimal with fixed base)
            └─────────────────────┘
```

No ASLR — Wine loads PE at ImageBase 0x400000. All addresses are deterministic.

## XOR Obfuscation

The binary uses a trivial sign-bit flip as "obfuscation":

```python
# XOR with -0.0 (0x8000000000000000) = negate sign bit
def sign_flip_xor(value, xor_key=-0.0):
    return -value  # That's it. That's the "encryption".
```

This appears in V2 (quality penalty exponent), V6 (sign flip on p3), and the initial interval function. The constant `-0.0` is IEEE 754 negative zero — its only effect when XOR'd with a double is to flip bit 63 (the sign bit).

## Key Challenges and Solutions

### Challenge 1: Ghidra Cannot xref .rsrc Strings
Delphi stores class method names in the `.rsrc` section (resource string tables), but these have no direct code references. Ghidra's cross-reference analysis finds zero callers.

**Solution**: RTTI adjacency heuristic — scan `.rsrc` for pointers that land within ±1024 bytes of known algorithm code. Follow VMT (Virtual Method Table) pointers from class descriptors to locate methods.

### Challenge 2: Linux GDB Cannot Read Wine Process Memory
Wine intercepts `ptrace` syscalls, preventing GDB from attaching to Windows processes running under Wine. Standard `x/` memory inspection fails silently.

**Solution**: Direct `/proc/<pid>/mem` reads via `pread()` at known VA offsets. This bypasses ptrace entirely and reads the process's virtual memory directly. Works perfectly for extracting runtime matrices and constants.

### Challenge 3: 44,478 Functions — Needle in a Haystack
The Delphi runtime generates enormous numbers of tiny wrapper functions, string handlers, and exception frames. Manual browsing is impractical.

**Solution**: 
1. Constant-pattern search: `movsd xmm, [rip+disp]` instructions with recognizable values (0.07, 1.04, 500.0, etc.)
2. Cross-reference from known functions outward
3. Batch decompilation of candidate regions

### Challenge 4: RIP-Relative Addressing
x86-64 code uses `[rip + displacement]` for all memory references. The displacement is relative to the *next* instruction's address, not the current one.

**Solution**: Capstone disassembler with `X86_REG_RIP` base detection. For each `movsd`, extract the displacement, add the next instruction's RIP, and resolve to an absolute VA.

### Challenge 5: No External Data Files
Unlike SM-18 (which reads `sm8opt.dat` from disk), SM-20 stores all optimization data in memory. There are no collection-specific data files to parse.

**Solution**: Extract matrices from runtime memory after opening a collection in SM-20. The matrices are allocated in the BSS-like region above 0x01120000.

## Files

| File | Description |
|------|-------------|
| `sm20_algorithm.py` | Complete algorithm implementation (764 lines, all 3 versions) |
| `sm20_constants.py` | All extracted constants with Ghidra addresses |
| `sm20_ufactor.py` | U-factor analysis and verification |
| `sm20_simulation.py` | Bayesian smoothing simulation |
| `sm20_decompiled/` | 75 Ghidra decompiled C functions (55 batch 1 + 20 batch 2) |
| `REVERSE_ENGINEERING_REPORT.md` | This document |
| `COMPARISON.md` | SM-18 vs SM-20 algorithm comparison |

## Remaining Gaps

1. **V4 parameter mapping** — The exact mapping of the 7 parameters (p1..p7) to DSR model variables needs runtime tracing. The formula is confirmed but the parameter order is inferred from the calling convention.
2. **Post-lapse full logic** — The post-lapse tables (20×20×36 and 25×24) have been located and sized but the exact computation within `FUN_00cd41d0` and `FUN_00cd7b60` has simplified approximations.
3. **Metric computation** — `FUN_00cf9070` is complex (6.3KB) and the exact weighting scheme for cross-algorithm comparison needs further validation.
4. **Optimization step** — How the matrices are updated after each review session is partially decoded but the full incremental update algorithm in `FUN_00cd6260` has simplifications.
5. **BSS constant mutability** — `DAT_0127cb08` (stability power = 2.904) is set at runtime and may change after ML optimization. Verify with a trained collection.

## Audit History

### 2026-04-11: Comprehensive Audit — Bugs Found and Fixed

Cross-referenced all 75 decompiled functions against `sm20_algorithm.py`:

**Bug 1 (Critical): V2 parameter mapping was inverted.** V2 receives `(rep_fraction, stability_transformed, difficulty_fraction)` from the matrix builder — NOT `(quality, stability, a_factor)`. The first parameter drives repetition-dependent behavior (not quality-dependent). This affected V2, FUN_00ce1900, and the Bayesian core initial value computation.

**Bug 2 (Critical): Missing BSS runtime constant.** `DAT_0127cb08 = 2.904` (stability power denominator) is a BSS global that was zero in the static binary and undetectable via static analysis. Extracted by spawning SM-20 as a child process and reading `/proc/pid/mem` at the correct runtime address.

**Bug 3 (Moderate): FUN_00cf7420 mislabeled.** Previously described as "A-factor → value" conversion. Actually transforms the **stability index** S: `pow(S-1, 2.904) + 2.0`. This feeds into V2's second parameter and FUN_00cf7330's inverse conversion.

**Verified correct**: Matrix indexing (R×S×D, R slowest), all static constants, Bayesian smoothing weights, XOR obfuscation, post-lapse dimensions, V4/V6 formula structures.