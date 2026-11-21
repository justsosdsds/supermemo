#!/usr/bin/env python3
"""
SM20 Algorithm — Corrected U-Factor Understanding
===================================================
FUN_00ccf070 computes a U-FACTOR (multiplier), not an absolute interval.
The actual next interval = previous_interval * U-factor.

Quality is 0.0-1.0 (recall probability):
- 0.0 = complete failure (lapse)
- 1.0 = perfect recall
"""

import math

def exp2_clamped(x):
    return 2.0 ** max(-38.0, min(38.0, x))

def compute_ufactor_v2(quality, repetition, a_factor):
    """
    FUN_00ccf070: Compute U-factor for next interval.
    
    Parameters:
        quality: 0.0-1.0 (recall probability)
        repetition: 1-based repetition number
        a_factor: A-factor (easiness)
    
    Returns:
        U-factor to multiply with previous interval
    """
    c1, c2, c3 = 9.29, 1.3, 1.0
    c4, c5 = -0.08, -0.31
    c6, c7 = 1.04, 0.07
    c8, c9, c10 = -1.88, 1.58, 600.0
    
    # Step 1: Stability/repetition scaling
    # When quality=0 (lapse): scale=9.29 (max, lots of adjustment needed)
    # When quality=1 (perfect): scale=1.3 (min, keep current interval)
    scale = c2 + (c1 - c2) * (c3 - quality)
    
    # Step 2: Repetition factor (power function)
    rep_param = c4 + quality * (c5 - c4)
    # = -0.08 - 0.23*quality
    # For quality=0: param=-0.08 (slight growth)
    # For quality=1: param=-0.31 (more decay of rep factor)
    rep = max(1, repetition)
    rep_factor = math.pow(rep, max(0.001, rep_param))
    
    # Step 3: Base U-factor
    base = (scale - c6) * rep_factor + c7
    # = (scale - 1.04) * rep_factor + 0.07
    
    # Step 4: Quality penalty/exponent
    penalty = min(c10, quality * c8 + c9)
    # = min(600, -1.88*quality + 1.58)
    # quality=0: 1.58, quality=1: -0.3
    
    # Step 5: exp2(negated_penalty * a_factor)
    # XOR with -0.0 flips sign
    exp_arg = -penalty * a_factor
    exp_result = exp2_clamped(exp_arg)
    
    return base * exp_result


def simulate_learning(num_items=100, quality_fn=None, seed=42):
    """
    Simulate SM20 learning with U-factors.
    """
    import random
    random.seed(seed)
    
    results = []
    
    for item in range(num_items):
        a_factor = random.uniform(1.2, 2.8)
        interval = 1.0  # initial interval
        
        item_log = []
        for rep in range(1, 21):
            # Generate quality (simulate learning curve)
            if quality_fn:
                q = quality_fn(rep, a_factor)
            else:
                # Default: improving recall with noise
                base_recall = min(1.0, 0.3 + 0.08 * rep + 0.05 * (a_factor - 2.0))
                q = max(0.0, min(1.0, base_recall + random.gauss(0, 0.15)))
            
            # Compute U-factor and update interval
            uf = compute_ufactor_v2(q, rep, a_factor)
            interval = max(1.0, interval * uf)
            
            item_log.append({
                'rep': rep,
                'quality': q,
                'ufactor': uf,
                'interval': interval,
                'a_factor': a_factor,
            })
        
        results.append(item_log)
    
    return results


print("=" * 70)
print("SM20 V2 U-Factor Analysis")
print("=" * 70)

# U-factor for different quality levels
print("\nU-Factors at rep=1, a_factor=2.0:")
for q in [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]:
    uf = compute_ufactor_v2(q, 1, 2.0)
    print(f"  quality={q:.1f}: U-factor={uf:.6f}")

print("\nU-Factors at rep=5, a_factor=2.0:")
for q in [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]:
    uf = compute_ufactor_v2(q, 5, 2.0)
    print(f"  quality={q:.1f}: U-factor={uf:.6f}")

print("\nU-Factors at rep=10, a_factor=2.0:")
for q in [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]:
    uf = compute_ufactor_v2(q, 10, 2.0)
    print(f"  quality={q:.1f}: U-factor={uf:.6f}")

# A-factor sensitivity
print("\nA-factor sensitivity (quality=0.8, rep=5):")
for af in [1.0, 1.5, 2.0, 2.5, 3.0, 4.0]:
    uf = compute_ufactor_v2(0.8, 5, af)
    print(f"  a_factor={af:.1f}: U-factor={uf:.6f}")

# Simulated learning curve
print("\n" + "=" * 70)
print("Simulated Learning Curve (single item, a_factor=2.0)")
print("=" * 70)
results = simulate_learning(1, seed=42)
item = results[0]
for entry in item[:15]:
    print(f"  Rep {entry['rep']:2d}: q={entry['quality']:.3f}, "
          f"UF={entry['ufactor']:.4f}, interval={entry['interval']:8.2f} days")

# Aggregate statistics
print("\n" + "=" * 70)
print("Aggregate Statistics (100 items, 20 reps each)")
print("=" * 70)
all_results = simulate_learning(100, seed=42)

for rep in [1, 2, 3, 5, 10, 15, 20]:
    intervals = [item[rep-1]['interval'] for item in all_results if rep-1 < len(item)]
    avg = sum(intervals) / len(intervals) if intervals else 0
    mn = min(intervals) if intervals else 0
    mx = max(intervals) if intervals else 0
    print(f"  Rep {rep:2d}: avg_interval={avg:8.2f} days, min={mn:.1f}, max={mx:.1f}")
