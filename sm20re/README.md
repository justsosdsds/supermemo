# SuperMemo SM-20 Reverse Engineering

Complete reverse engineering of the spaced repetition algorithm in SuperMemo 20 (`sm20.exe`).

## What This Is

- **Target**: sm20.exe (27MB, PE32+ x86-64, Delphi, ~44k functions)
- **Methods**: Ghidra 12.x decompilation, Capstone disassembly, `/proc/pid/mem` runtime extraction, Bayesian smoothing analysis
- **Status**: Core algorithm fully decoded, all three versions (V2/V4/V6) reconstructed in Python

## Algorithm Versions

The binary contains three algorithm variants dispatched from `FUN_00ccfe80` based on a version byte:

| Version | Function | Description | Formula |
|---------|----------|-------------|---------|
| V2 | `FUN_00ccf070` | SM-19 compatible | Polynomial + exp2 |
| V4 | `FUN_00ccd8e0` | SM-20 proper | 7-parameter polynomial |
| V6 | `FUN_00ccfde0` | FSRS-style | Double exponential |

## Quick Start

```bash
# Run the complete implementation with tests
python3 sm20_algorithm.py

# View extracted constants
python3 sm20_constants.py

# U-factor analysis
python3 sm20_ufactor.py

# Bayesian smoothing simulation
python3 sm20_simulation.py
```

## DSR Model

All three versions operate on the **DSR (Difficulty/Stability/Retrievability)** three-component model of long-term memory:

- **Stability (S)**: Inter-repetition interval producing 90% recall probability
- **Retrievability (R)**: Expected probability of recall at time t
- **Difficulty (D)**: Maximum possible stability increase, mapped to [0,1]

## Key Findings

- Quality parameter is **0.0–1.0** (retrievability), not 0–5
- The V2 formula computes a **U-factor** (multiplier on previous interval), not absolute intervals
- Optimal quality for interval growth is **~0.6** (U-factor ≈ 1.89), consistent with 90% retention target
- Quality=1.0 gives U≈0.50 (shrink) and quality=0.0 gives U≈0.93 (shrink)
- The **21³ matrix** stores stability-increase data indexed by [Repetition × Stability × Difficulty]
- **3×3×3 Bayesian neighbor smoothing** with weight_base=500 prevents sparse data corruption
- XOR "obfuscation" is trivial: just `-0.0` (sign bit flip)
- All constants stored in Delphi's `.data` section, accessible at static addresses via `PE_VA = Ghidra_addr - 0x400000`

## Repository Structure

```
sm20-re/
├── README.md                         # This file
├── REVERSE_ENGINEERING_REPORT.md     # Full technical writeup (370+ lines)
├── COMPARISON.md                     # SM-18 vs SM-20 detailed comparison
├── sm20_algorithm.py                 # Complete Python implementation (764 lines)
├── sm20_constants.py                 # All extracted constants with addresses
├── sm20_ufactor.py                   # U-factor analysis and verification
├── sm20_simulation.py                # Bayesian smoothing simulation
├── sm20_decompiled/                  # 75 Ghidra decompiled C functions
│   ├── func_000000ccf070.c           #   V2 interval computation
│   ├── func_000000ccd8e0.c           #   V4 interval computation
│   ├── func_000000ccfde0.c           #   V6 interval computation
│   ├── func_000000ccfe80.c           #   Algorithm dispatch
│   ├── func_000000ce1250.c           #   Core Bayesian smoothing
│   ├── func_000000cd6260.c           #   Matrix builder (21³)
│   ├── ...                           #   + 69 more functions
│   └── (batch 2 files with descriptive names also in this dir)
└── audit_functions.py                # Analysis utilities
```

## Documentation

- **[REVERSE_ENGINEERING_REPORT.md](REVERSE_ENGINEERING_REPORT.md)** — Full technical writeup covering:
  - Binary analysis methodology (Ghidra, Wine, /proc/pid/mem)
  - All three algorithm formulas with exact constants
  - U-factor table (20 values)
  - Matrix layout (21³ = 9,261 cells)
  - Bayesian smoothing algorithm
  - Key function table (75 functions with addresses)
  - PE memory layout
  - Challenges and solutions

- **[COMPARISON.md](COMPARISON.md)** — Detailed SM-18 vs SM-20 comparison:
  - Architecture differences (32-bit vs 64-bit, x87 vs SSE2)
  - Algorithm flow side-by-side
  - Formula differences (SInc vs U-factor, regression vs Bayesian)
  - Data storage (sm8opt.dat vs in-memory matrices)
  - Quality scale (0-5 grades vs 0.0-1.0 retrievability)
  - Post-lapse behavior
  - Evolution from SM-17 through SM-20

## Methodology

1. **Ghidra 12.x + pyghidra 3.x** on remote x86 Linux (Ubuntu, 31GB RAM)
2. **RTTI adjacency heuristic** for finding code refs (Ghidra can't xref .rsrc strings)
3. **`/proc/pid/mem` runtime extraction** under Wine (GDB can't read Wine memory)
4. **Capstone RIP-relative disassembly** for constant mining
5. **Constant mapping**: `PE_VA = Ghidra_addr - 0x400000`
6. **75 decompiled functions** across two batches (55 + 20)
7. **100% constant extraction** — all doubles, ints, and flags identified

## Binary Analysis Notes

- Ghidra could not find xrefs to .rsrc section strings (Delphi RTTI has no direct code references)
- RTTI adjacency heuristic: scan .rsrc for code pointers within ±1024 bytes of method name strings
- Linux GDB cannot read Wine process memory (ptrace interception) — raw `/proc/pid/mem` works perfectly
- Capstone disassembler with `X86_REG_RIP` base detection for RIP-relative addressing
- Constants are in `.data` section, not `.rsrc` — Ghidra addresses include ImageBase offset
- XOR obfuscation with `-0.0` is just sign-bit flip (negation) — not real encryption