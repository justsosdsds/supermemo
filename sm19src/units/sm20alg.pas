unit sm20alg;

{ SM-20 spaced-repetition algorithm, ported to Object Pascal from the
  reverse-engineered implementation in sm20-re (Ghidra + runtime memory
  extraction of sm20.exe 27MB PE32+ x86-64 Delphi).

  Covers:
    - DSR model core (Difficulty / Stability / Retrievability)
    - V2 formula  (FUN_00ccf070, "SM-19 compatible", complete pipeline)
    - V4 formula  (FUN_00ccd8e0, SM-20 proper, 7-parameter polynomial)
    - V6 formula  (FUN_00ccfde0, FSRS-style double exponential)
    - initial-interval prior (FUN_00ce1900)
    - 21x21x21 stability matrix + count matrix, flat[R*441+S*21+D]
    - 3x3x3 Bayesian neighbour smoothing (FUN_00ce1250)
    - index conversions and interval rounding/clamping

  Precision note: the SM-20 binary uses SSE2 doubles; SuperMemo 19 used x87
  80-bit extended. This unit uses Double so results are bit-comparable with
  the SM-20 reference implementation. }

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

const
  MATRIX_DIM = 21;
  MATRIX_CELLS = MATRIX_DIM * MATRIX_DIM * MATRIX_DIM;   // 9261
  STRIDE_R = MATRIX_DIM * MATRIX_DIM;                    // 441
  STRIDE_S = MATRIX_DIM;                                 // 21

  { --- Version 2 constants (FUN_00ccf070 @ 0xccf150..0xccf198) --- }
  V2_C1 = 9.29;
  V2_C2 = 1.3;
  V2_C3 = 1.0;
  V2_C4 = -0.08;
  V2_C5 = -0.31;
  V2_C6 = 1.04;
  V2_C7 = 0.07;
  V2_C8 = -1.88;
  V2_C9 = 1.58;
  V2_C10 = 600.0;

  { --- Initial interval priors (FUN_00ce1900) --- }
  INIT_IV1 = 15.0;
  INIT_IV2 = 3.0;
  INIT_IV3 = 1.0;
  INIT_IV4 = -0.08;
  INIT_IV5 = -0.35;
  INIT_IV6 = -2.0;
  INIT_IV7 = 2.25;
  INIT_IV8 = 600.0;

  { --- Bayesian core weights (FUN_00ce1250) --- }
  CORE_WEIGHT_BASE = 500.0;
  CORE_MIN_COUNT = 10.0;
  CORE_MAX_WEIGHT = 1000.0;
  CORE_CUBE_WEIGHT = 3.0;
  CORE_NEUTRAL = 1.0;

  { --- stability pre-transform (FUN_00cf7550) --- }
  STAB_LOWER = -1.0;
  STAB_CAP1 = 0.7;
  STAB_CAP2 = 44530.0;

  { --- rounding / clamping (FUN_00ce8dd0) --- }
  ROUND_FLAG0_UPPER = 2.0;
  ROUND_FLAG0_LOWER = 0.5;
  ROUND_FLAG2_UPPER = 20.0;
  ROUND_FLAG2_LOWER = 0.8;

  { --- index conversion constants --- }
  IDX_STABILITY_OFFSET = 2.0;
  IDX_STABILITY_POWER = 1.0;
  IDX_STABILITY_DENOM = 2.90396936502257;   // DAT_0127cb08, runtime BSS constant
  IDX_AFACTOR_OFFSET = 2.0;
  IDX_AFACTOR_POWER = 2.90396936502257;
  IDX_DIFFICULTY_SCALE = 19;
  IDX_REPETITION_DIVISOR = 19.0;
  IDX_RETRIEVABILITY_SCALE = 20.0;

type
  TDoubleArray = array of Double;
  TIntArray = array of Integer;

  { U-factor table: 20 values, identical for every repetition row 0..19 }
  TSM20Matrix = record
    Interval: TDoubleArray;   // MATRIX_CELLS doubles
    Count: TIntArray;         // MATRIX_CELLS int32
  end;

function Exp2Clamped(x: Double): Double;
function SignFlip(v: Double): Double;
function SafePower(base, exponent: Double): Double;
function WeightOf(x, y: Double): Double;
function ClampD(v, lo, hi: Double): Double;

function ComputeIntervalV2(repFraction, stabilityTransformed, difficultyFraction: Double): Double;
function ComputeInitialInterval(repFraction, stabilityTransformed, difficultyFraction: Double): Double;
function ComputeIntervalV4(p1, p2, p3, p4, p5, p6, p7: Double): Double;
function ComputeIntervalV6(p1, p2, p3, p4, p5, p6: Double): Double;

function StabilityPretransform(stability: Double; out wasError: Boolean): Double;
function ApplyRounding(interval: Double; flags: Integer): Double;

function DifficultyToIndex(difficulty: Double): Integer;
function RepetitionToIndex(rep: Integer): Double;
function StabilityToIndex(stability: Double): Integer;
function AFactorToValue(aIndex: Integer): Double;
function RetrievabilityToIndex(retrievability: Double): Integer;
function DifficultyFractionFromIndex(dIndex: Integer): Double;

function ComputeIntervalCore(rIndex, sIndex, dIndex: Integer;
  const M: TSM20Matrix): Double;

function UFactor(const dIndex: Integer): Double;

procedure InitMatrix(out M: TSM20Matrix);
procedure BuildV2Matrix(out M: TSM20Matrix);

implementation

function Exp2Clamped(x: Double): Double;
begin
  { FUN_00f614b0: 2^x clamped to [-38, 38] }
  Result := Power(2.0, ClampD(x, -38.0, 38.0));
end;

function SignFlip(v: Double): Double;
begin
  { the "XOR obfuscation" in the binary is XOR with -0.0 = plain negation }
  Result := -v;
end;

function SafePower(base, exponent: Double): Double;
begin
  if base <= 0 then
    Result := 0.0
  else
    Result := Power(base, exponent);
end;

function WeightOf(x, y: Double): Double;
var
  s: Double;
begin
  { FUN_00f6ae80: x / (x + y) }
  s := x + y;
  if s = 0 then
    Result := 0.0
  else
    Result := x / s;
end;

function ClampD(v, lo, hi: Double): Double;
begin
  if v < lo then
    Result := lo
  else if v > hi then
    Result := hi
  else
    Result := v;
end;

function ComputeIntervalV2(repFraction, stabilityTransformed, difficultyFraction: Double): Double;
var
  stabilityScale, repPower, repFactor, base, penalty, exponent: Double;
begin
  { FUN_00ccf070, parameters come pre-converted from the matrix builder }
  stabilityScale := V2_C2 + (V2_C1 - V2_C2) * (V2_C3 - repFraction);
  repPower := V2_C4 + repFraction * (V2_C5 - V2_C4);
  repFactor := SafePower(stabilityTransformed, repPower);
  base := (stabilityScale - V2_C6) * repFactor + V2_C7;
  penalty := Min(V2_C10, repFraction * V2_C8 + V2_C9);
  exponent := SignFlip(penalty) * difficultyFraction;
  Result := base * Exp2Clamped(exponent);
end;

function ComputeInitialInterval(repFraction, stabilityTransformed, difficultyFraction: Double): Double;
var
  stabilityScale, repPower, repFactor, base, penalty, exponent, interval: Double;
begin
  { FUN_00ce1900 — the Bayesian prior for a matrix cell }
  stabilityScale := INIT_IV2 + (INIT_IV1 - INIT_IV2) * (INIT_IV3 - repFraction);
  repPower := INIT_IV4 + repFraction * (INIT_IV5 - INIT_IV4);
  repFactor := SafePower(stabilityTransformed, repPower);
  base := (stabilityScale - INIT_IV3) * repFactor + INIT_IV3;
  penalty := Min(INIT_IV8, repFraction * INIT_IV6 + INIT_IV7);
  exponent := SignFlip(penalty) * difficultyFraction;
  interval := base * Exp2Clamped(exponent);
  interval := ApplyRounding(interval, 4);
  if interval < 1.0 then
    Result := 1.0
  else
    Result := interval;
end;

function ComputeIntervalV4(p1, p2, p3, p4, p5, p6, p7: Double): Double;
begin
  { FUN_00ccd8e0 — SM-20 proper: (p3*p5 + 1) * (p1*p7 + p2) + p4
    Parameter-to-DSR mapping is still unresolved in the reference project. }
  Result := (p3 * p5 + 1.0) * (p1 * p7 + p2) + p4;
end;

function ComputeIntervalV6(p1, p2, p3, p4, p5, p6: Double): Double;
var
  e1, e2: Double;
begin
  { FUN_00ccfde0 — FSRS-style double exponential }
  e1 := Power(2.0, p6);
  e2 := Power(2.0, SignFlip(p3) * p5);
  Result := p4 + p1 * e1 * e2;
end;

function StabilityPretransform(stability: Double; out wasError: Boolean): Double;
begin
  { FUN_00cf7550: valid range [0.7, 44530] }
  wasError := False;
  if IsNan(stability) or IsInfinite(stability) then
  begin
    wasError := True;
    Result := STAB_CAP2;
    Exit;
  end;
  if stability <= STAB_LOWER then
  begin
    Result := stability;
    Exit;
  end;
  if stability < STAB_CAP1 then
  begin
    wasError := True;
    Result := STAB_CAP1;
    Exit;
  end;
  if stability <= STAB_CAP2 then
  begin
    Result := stability;
    Exit;
  end;
  wasError := True;
  Result := STAB_CAP2;
end;

function ApplyRounding(interval: Double; flags: Integer): Double;
begin
  { FUN_00ce8dd0; the reference project maps flags>=4 (and bit1 set) to the
    wide [0.8, 20.0] window, otherwise [0.5, 2.0] }
  if (flags >= 4) or ((flags and 2) <> 0) then
  begin
    if interval > ROUND_FLAG2_UPPER then
      interval := ROUND_FLAG2_UPPER;
    if (interval <= ROUND_FLAG2_LOWER) and (interval <> ROUND_FLAG2_LOWER) then
      interval := ROUND_FLAG2_LOWER;
  end
  else
  begin
    if interval > ROUND_FLAG0_UPPER then
      interval := ROUND_FLAG0_UPPER;
    if (interval <= ROUND_FLAG0_LOWER) and (interval <> ROUND_FLAG0_LOWER) then
      interval := ROUND_FLAG0_LOWER;
  end;
  Result := interval;
end;

function DifficultyToIndex(difficulty: Double): Integer;
begin
  { FUN_00cf6fd0: floor(d*19)+1, clamped to 1..20 }
  if difficulty < 0.0 then
  begin
    Result := 10;
    Exit;
  end;
  if difficulty > 1.0 then
  begin
    Result := 10;
    Exit;
  end;
  Result := Floor(difficulty * IDX_DIFFICULTY_SCALE) + 1;
end;

function RepetitionToIndex(rep: Integer): Double;
begin
  { FUN_00cf71c0: (rep-1)/19 }
  Result := (rep - 1) / IDX_REPETITION_DIVISOR;
end;

function StabilityToIndex(stability: Double): Integer;
var
  diff, e, res: Double;
  err: Boolean;
  idx: Integer;
begin
  { FUN_00cf7330 -> 1..20 }
  stability := StabilityPretransform(stability, err);
  diff := stability - IDX_STABILITY_OFFSET;
  if diff < 0 then
    diff := 0;
  e := IDX_STABILITY_POWER / IDX_STABILITY_DENOM;
  res := SafePower(diff, e);
  idx := Floor(res) + 1;
  if idx < 1 then
    idx := 1;
  if idx > 20 then
    idx := 20;
  Result := idx;
end;

function AFactorToValue(aIndex: Integer): Double;
begin
  { FUN_00cf7420: pow(index-1, 2.904) + 2 }
  Result := SafePower(aIndex - 1, IDX_AFACTOR_POWER) + IDX_AFACTOR_OFFSET;
end;

function RetrievabilityToIndex(retrievability: Double): Integer;
var
  r: Integer;
begin
  { FUN_00cf7250: floor(exp2(R*20)) clamped to 0..20 }
  r := Floor(Power(2.0, retrievability * IDX_RETRIEVABILITY_SCALE));
  if r < 0 then
    r := 0;
  if r > 20 then
    r := 20;
  Result := r;
end;

function DifficultyFractionFromIndex(dIndex: Integer): Double;
begin
  Result := (dIndex + 1) / 20.0;
end;

function ComputeIntervalCore(rIndex, sIndex, dIndex: Integer; const M: TSM20Matrix): Double;
var
  repFraction, stabTransformed, diffFraction, initial: Double;
  idx, nIdx, nr, ns, nd: Integer;
  targetInterval, targetCount, accumulator, countSum, total: Double;
  targetWeight, neighborWeight, numerator, denominator: Double;
begin
  { FUN_00ce1250 — Bayesian blend of the prior with the 3x3x3 neighbour cube }
  repFraction := rIndex / 19.0;
  stabTransformed := SafePower(sIndex, IDX_AFACTOR_POWER) + IDX_AFACTOR_OFFSET;
  diffFraction := (dIndex + 1) / 20.0;

  initial := ComputeInitialInterval(repFraction, stabTransformed, diffFraction);

  idx := rIndex * STRIDE_R + sIndex * STRIDE_S + dIndex;
  targetInterval := M.Interval[idx];
  targetCount := M.Count[idx];

  accumulator := 0.0;
  countSum := 0.0;
  for nr := Max(0, rIndex - 1) to Min(MATRIX_DIM - 1, rIndex + 1) do
    for ns := Max(0, sIndex - 1) to Min(MATRIX_DIM - 1, sIndex + 1) do
      for nd := Max(0, dIndex - 1) to Min(MATRIX_DIM - 1, dIndex + 1) do
      begin
        if (nr * ns * nd) = 0 then
          Continue;
        nIdx := nr * STRIDE_R + ns * STRIDE_S + nd;
        accumulator := accumulator + M.Interval[nIdx] * M.Count[nIdx];
        countSum := countSum + M.Count[nIdx];
      end;

  total := countSum + 1.0;
  targetWeight := WeightOf(targetCount, CORE_WEIGHT_BASE) * CORE_MIN_COUNT;
  neighborWeight := WeightOf(countSum, CORE_MAX_WEIGHT);

  numerator := initial + targetInterval * targetWeight +
    ((targetInterval + accumulator) / total) * neighborWeight * CORE_CUBE_WEIGHT;
  denominator := targetWeight + CORE_NEUTRAL + neighborWeight * CORE_CUBE_WEIGHT;

  if denominator = 0 then
    Result := initial
  else
    Result := numerator / denominator;
end;

const
  { U-factor per difficulty index 0..19 (identical for every repetition row) }
  UFACTOR_TABLE: array[0..19] of Double = (
    13.822076, 8.212571, 6.056511, 4.879609, 4.126662,
    3.598557, 3.205138, 2.899285, 2.653822, 2.451912,
    2.282528, 2.138131, 2.013379, 1.904376, 1.808207,
    1.722649, 1.645970, 1.576804, 1.514055, 1.456836
  );

function UFactor(const dIndex: Integer): Double;
begin
  if (dIndex < 0) or (dIndex > 19) then
    Result := 0.0
  else
    Result := UFACTOR_TABLE[dIndex];
end;

procedure InitMatrix(out M: TSM20Matrix);
var
  i: Integer;
begin
  SetLength(M.Interval, MATRIX_CELLS);
  SetLength(M.Count, MATRIX_CELLS);
  for i := 0 to MATRIX_CELLS - 1 do
  begin
    M.Interval[i] := 0.0;
    M.Count[i] := 0;
  end;
end;

procedure BuildV2Matrix(out M: TSM20Matrix);
var
  r, s, d, idx: Integer;
  repFrac, stabXform, diffFrac: Double;
begin
  { FUN_00cd6260: fill every cell with the V2 prior }
  InitMatrix(M);
  for r := 0 to 19 do
  begin
    repFrac := RepetitionToIndex(r + 1);
    for s := 0 to 19 do
    begin
      stabXform := AFactorToValue(s + 1);
      for d := 0 to 19 do
      begin
        diffFrac := DifficultyFractionFromIndex(d);
        idx := r * STRIDE_R + s * STRIDE_S + d;
        M.Interval[idx] := ComputeIntervalV2(repFrac, stabXform, diffFrac);
      end;
    end;
  end;
end;

end.
