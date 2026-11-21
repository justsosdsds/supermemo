program algodemo;
{$mode objfpc}{$H+}

{ End-to-end check: read the real SuperMemo 19 collection from disk, run the
  scheduling engine on a card state, and print the decision. }

uses
  SysUtils, sm20alg, smcollection, smengine;

const
  COLLECTION = 'F:\SMCollections\ABC';

var
  C: TSMCollection;
  St: TCardState;
  R: TNextResult;
  quality: Double;
  reps: Integer;

begin
  WriteLn('======================================================================');
  WriteLn('SM-19 collection -> scheduling engine (end to end)');
  WriteLn('======================================================================');
  WriteLn;
  WriteLn('collection: ', COLLECTION);

  C := TSMCollection.Create(COLLECTION);
  try
    if not C.Load then
    begin
      WriteLn('FAILED to load StabilityIncrease.dat');
      Halt(1);
    end;
    WriteLn(Format('matrix loaded: %d cells', [Length(C.StabilityMatrix)]));
    WriteLn;

    WriteLn('U-factor row probes (R=0):');
    WriteLn('  S=1 D=0..4 : ' + Format('%.6f %.6f %.6f %.6f %.6f', [
      C.StabilityIncrease(0, 1, 0), C.StabilityIncrease(0, 1, 1),
      C.StabilityIncrease(0, 1, 2), C.StabilityIncrease(0, 1, 3),
      C.StabilityIncrease(0, 1, 4)]));
    WriteLn('  S=0 D=0..4 : ' + Format('%.6f %.6f %.6f %.6f %.6f', [
      C.StabilityIncrease(0, 0, 0), C.StabilityIncrease(0, 0, 1),
      C.StabilityIncrease(0, 0, 2), C.StabilityIncrease(0, 0, 3),
      C.StabilityIncrease(0, 0, 4)]));
    WriteLn;

    St := DefaultCard;
    WriteLn(Format('card: stability=%.2f d  difficulty=%.2f  repetition=%d  interval=%.2f d  R=%.2f',
      [St.Stability, St.Difficulty, St.Repetition, St.Interval, St.Retrievability]));
    WriteLn;

    WriteLn('  quality   Ridx Sidx Didx   U-factor   next interval   source');
    for reps := 0 to 4 do
    begin
      quality := 0.2 + reps * 0.2;
      R := ComputeNext(C, St, quality);
      WriteLn(Format('  %7.2f   %4d %4d %4d   %8.4f   %9.2f days   %s',
        [quality, R.RIndex, R.SIndex, R.DIndex, R.UFactor, R.Interval, R.Source]));
    end;
    WriteLn;

    WriteLn('same card through the reconstructed formulas:');
    for reps := 0 to 4 do
    begin
      quality := 0.2 + reps * 0.2;
      R := ComputeNext(C, St, quality, 2);
      WriteLn(Format('  quality %.2f -> V2 formula interval %.2f d', [quality, R.FormulaInterval]));
    end;
    WriteLn;

    WriteLn('quality sweep on the matrix (V2 as reference):');
    R := ComputeNext(C, St, 0.9, 4);
    WriteLn(Format('  V4 parameter probe -> %.4f', [R.FormulaInterval]));
    R := ComputeNext(C, St, 0.9, 6);
    WriteLn(Format('  V6 parameter probe -> %.4f', [R.FormulaInterval]));
    WriteLn;
    WriteLn('DONE');
  finally
    C.Free;
  end;
end.
