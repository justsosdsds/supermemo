unit smengine;

{ Scheduling engine: turns a card state plus the collection's real matrix into
  the next review interval. Uses the SM-19 on-disk StabilityIncrease matrix
  (which contains the same U-factor table the SM-20 binary uses). }

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Math, sm20alg, smcollection;

type
  TCardState = record
    Stability: Double;      // days
    Difficulty: Double;     // 0..1
    Repetition: Integer;    // 1-based
    Interval: Double;       // current interval in days
    Retrievability: Double; // 0..1, estimate at review time
  end;

  TNextResult = record
    Interval: Double;       // next interval in days
    UFactor: Double;        // multiplier taken from the matrix
    FormulaInterval: Double;// what the reconstructed V2 formula would give
    RIndex, SIndex, DIndex: Integer;
    CellCases: Integer;
    Source: string;         // 'matrix' or 'formula'
  end;

function DefaultCard: TCardState;
function ComputeNext(const C: TSMCollection; const St: TCardState;
  Quality: Double; Version: Integer = 2): TNextResult;
procedure RecordRepetition(C: TSMCollection; const UFactorUsed: Double;
  const St: TCardState);

implementation

function DefaultCard: TCardState;
begin
  Result.Stability := 12.4;
  Result.Difficulty := 0.32;
  Result.Repetition := 5;
  Result.Interval := 12.4;
  Result.Retrievability := 0.87;
end;

function ComputeNext(const C: TSMCollection; const St: TCardState;
  Quality: Double; Version: Integer): TNextResult;
var
  repFraction, stabilityTransformed, difficultyFraction: Double;
  qualityClamped: Double;
begin
  FillChar(Result, SizeOf(Result), 0);

  Result.RIndex := EnsureRange(St.Repetition - 1, 0, 20);
  Result.SIndex := EnsureRange(StabilityToIndex(St.Stability) - 1, 0, 20);
  Result.DIndex := EnsureRange(DifficultyToIndex(St.Difficulty) - 1, 0, 20);

  repFraction := (St.Repetition - 1) / 19.0;
  stabilityTransformed := SafePower(Max(0, Trunc(St.Stability) - 1), IDX_AFACTOR_POWER)
    + IDX_AFACTOR_OFFSET;
  difficultyFraction := Max(0, Trunc(St.Difficulty * 20 + 0.5)) / 20.0;
  qualityClamped := EnsureRange(Quality, 0.0, 1.0);

  case Version of
    4: Result.FormulaInterval := ComputeIntervalV4(difficultyFraction, stabilityTransformed,
         qualityClamped, 0.0, St.Retrievability, stabilityTransformed, St.Repetition);
    6: Result.FormulaInterval := ComputeIntervalV6(stabilityTransformed, qualityClamped,
         stabilityTransformed, St.Repetition, difficultyFraction, St.Retrievability);
  else
    Result.FormulaInterval := ComputeIntervalV2(repFraction, stabilityTransformed, difficultyFraction);
  end;

  { the on-disk matrix is authoritative when it has data for this cell }
  Result.UFactor := C.StabilityIncrease(Result.RIndex, Result.SIndex, Result.DIndex);
  Result.CellCases := C.Cases(Result.RIndex, Result.SIndex, Result.DIndex);

  if Result.UFactor > 0 then
  begin
    Result.Interval := St.Interval * Result.UFactor;
    Result.Source := 'matrix';
  end
  else
  begin
    Result.Interval := Result.FormulaInterval;
    Result.Source := 'formula';
  end;

  Result.Interval := EnsureRange(Result.Interval, 1.0, 44530.0);
end;

procedure RecordRepetition(C: TSMCollection; const UFactorUsed: Double;
  const St: TCardState);
var
  r, s, d, oldCases: Integer;
  oldValue, newValue: Double;
const
  LEARNING_RATE = 0.10;   { new observations nudge the table, they do not replace it }
begin
  r := EnsureRange(St.Repetition - 1, 0, 20);
  s := EnsureRange(StabilityToIndex(St.Stability) - 1, 0, 20);
  d := EnsureRange(DifficultyToIndex(St.Difficulty) - 1, 0, 20);

  oldCases := C.Cases(r, s, d);
  oldValue := C.StabilityIncrease(r, s, d);

  if UFactorUsed <= 0 then
    Exit;

  if oldValue <= 0 then
    newValue := UFactorUsed
  else
    newValue := oldValue * (1.0 - LEARNING_RATE) + UFactorUsed * LEARNING_RATE;

  C.SetStabilityIncrease(r, s, d, newValue);
  C.SetCases(r, s, d, oldCases + 1);
end;

end.
