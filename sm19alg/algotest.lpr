program algotest;
{$mode objfpc}{$H+}

{ Verification harness for the SM-20 algorithm port.
  Prints the same vectors as the Python reference implementation
  (sm20_algorithm.py) so the two can be diffed one-to-one. }

uses
  SysUtils, Math, sm20alg;

var
  M: TSM20Matrix;
  repFracs: array[0..4] of Double = (0.0, 4 / 19, 9 / 19, 14 / 19, 1.0);
  i: Integer;
  stabXform, v: Double;
  err: Boolean;
  idx: Integer;

begin
  WriteLn('======================================================================');
  WriteLn('SM20 Algorithm - Pascal port verification');
  WriteLn('======================================================================');
  WriteLn;

  WriteLn('V2 Interval Values (rep_fraction sweep, S=5, D=0.5):');
  WriteLn('   R_frac    S_xform  D_frac    V2 Result');
  stabXform := AFactorToValue(5);
  for i := 0 to 4 do
  begin
    v := ComputeIntervalV2(repFracs[i], stabXform, 0.5);
    WriteLn(Format('   %8.4f  %9.3f  %8.2f  %12.6f', [repFracs[i], stabXform, 0.5, v]));
  end;
  WriteLn;

  WriteLn('V4 Interval (polynomial):');
  WriteLn(Format('  V4(0.5, 1.0, 0.8, 0.0, 0.9, 2.0, 5) = %.6f',
    [ComputeIntervalV4(0.5, 1.0, 0.8, 0.0, 0.9, 2.0, 5)]));
  WriteLn;

  WriteLn('V6 Interval (double-exp):');
  WriteLn(Format('  V6(1.0, 0.8, 0.9, 1.0, 2.0, 0.5) = %.6f',
    [ComputeIntervalV6(1.0, 0.8, 0.9, 1.0, 2.0, 0.5)]));
  WriteLn;

  WriteLn('Stability Pre-transform:');
  for i := 0 to 5 do
  begin
    case i of
      0: v := -2.0;
      1: v := -0.5;
      2: v := 0.5;
      3: v := 1.0;
      4: v := 100.0;
    else
      v := 50000.0;
    end;
    v := StabilityPretransform(v, err);
    if err then
      WriteLn(Format('  %10.1f -> %10.1f (error)', [v, v]))
    else
      WriteLn(Format('  %10.1f -> %10.1f (ok)', [v, v]));
  end;
  WriteLn;

  WriteLn('Index Conversions:');
  WriteLn(Format('  difficulty 0.0 -> index %d', [DifficultyToIndex(0.0)]));
  WriteLn(Format('  difficulty 0.1 -> index %d', [DifficultyToIndex(0.1)]));
  WriteLn(Format('  difficulty 0.5 -> index %d', [DifficultyToIndex(0.5)]));
  WriteLn(Format('  difficulty 0.9 -> index %d', [DifficultyToIndex(0.9)]));
  WriteLn(Format('  difficulty 1.0 -> index %d', [DifficultyToIndex(1.0)]));
  WriteLn(Format('  stability      0.5 -> index %d', [StabilityToIndex(0.5)]));
  WriteLn(Format('  stability      1.0 -> index %d', [StabilityToIndex(1.0)]));
  WriteLn(Format('  stability      5.0 -> index %d', [StabilityToIndex(5.0)]));
  WriteLn(Format('  stability     50.0 -> index %d', [StabilityToIndex(50.0)]));
  WriteLn(Format('  stability    500.0 -> index %d', [StabilityToIndex(500.0)]));
  WriteLn(Format('  stability   5000.0 -> index %d', [StabilityToIndex(5000.0)]));
  WriteLn(Format('  repetition  1 -> range %.4f', [RepetitionToIndex(1)]));
  WriteLn(Format('  repetition  5 -> range %.4f', [RepetitionToIndex(5)]));
  WriteLn(Format('  repetition 10 -> range %.4f', [RepetitionToIndex(10)]));
  WriteLn(Format('  repetition 20 -> range %.4f', [RepetitionToIndex(20)]));
  WriteLn;

  WriteLn('Matrix build (V2 prior):');
  BuildV2Matrix(M);
  WriteLn(Format('  cells=%d  cell[0,0,0]=%.6f  cell[19,19,19]=%.6f  U(0)=%.6f  U(19)=%.6f',
    [Length(M.Interval), M.Interval[0], M.Interval[19 * 441 + 19 * 21 + 19],
     UFactor(0), UFactor(19)]));
  WriteLn;

  WriteLn('Bayesian core on empty matrix (prior only):');
  for i := 0 to 3 do
  begin
    idx := i * 5;
    WriteLn(Format('  cell[%2d,%2d,%2d] = %.6f', [idx div 5, idx div 5, idx mod 21,
      ComputeIntervalCore(idx div 5, idx div 5, idx mod 21, M)]));
  end;
  WriteLn;
  WriteLn('DONE');
end.
