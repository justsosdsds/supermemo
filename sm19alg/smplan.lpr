program smplan;
{$mode objfpc}{$H+}

{ Workload forecast for a collection.

  Simulates N days of study using the real stability matrix from the
  collection: every card starts as a new element, gets reviewed when due,
  and the engine computes the next interval. Prints how many reviews land on
  each day plus the resulting interval distribution. }

uses
  Classes, SysUtils, Math, sm20alg, smcollection, smengine;

const
  DEFAULT_DAYS = 30;

type
  TCardSim = record
    DueDay: Integer;
    Interval: Double;
    Stability: Double;
    Repetitions: Integer;
    Reviews: Integer;
  end;

var
  Cards: array of TCardSim;

procedure InitCards(const Count: Integer);
var
  i: Integer;
begin
  SetLength(Cards, Count);
  for i := 0 to Count - 1 do
  begin
    Cards[i].DueDay := 0;
    Cards[i].Interval := 1.0;
    Cards[i].Stability := 1.0;
    Cards[i].Repetitions := 1;
    Cards[i].Reviews := 0;
  end;
end;

function Simulate(const Root: string; Days: Integer; Grade: Integer;
  out TotalReviews: Integer; out FinalAvgInterval, FinalMaxInterval: Double): Boolean;
var
  C: TSMCollection;
  els: TSMElements;
  day, i, done_: Integer;
  St: TCardState;
  R: TNextResult;
  dayCount: array of Integer;
  quality: Double;
  sumInterval: Double;
  maxInterval: Double;
begin
  Result := False;
  TotalReviews := 0;
  FinalAvgInterval := 0;
  FinalMaxInterval := 0;

  C := TSMCollection.Create(Root);
  try
    if not C.Load then
    begin
      WriteLn('ERROR: cannot load collection matrices from ', Root);
      Exit;
    end;
    els := C.Elements;
    if Length(els) = 0 then
    begin
      WriteLn('ERROR: collection has no elements');
      Exit;
    end;

    InitCards(Length(els));
    SetLength(dayCount, Days);
    for i := 0 to Days - 1 do
      dayCount[i] := 0;

    quality := Grade / 5.0;

    for day := 0 to Days - 1 do
    begin
      done_ := 0;
      for i := 0 to High(Cards) do
      begin
        if Cards[i].DueDay > day then
          Continue;

        St.Stability := Cards[i].Stability;
        St.Difficulty := 0.3;
        St.Repetition := Min(Cards[i].Repetitions, 20);
        St.Interval := Cards[i].Interval;
        St.Retrievability := quality;

        R := ComputeNext(C, St, quality);
        { the raw matrix value is a stability-growth multiplier and explodes for
          fresh cards; blend it with the V2 formula so the forecast stays sane }
        if (R.Interval > 120) or (R.Interval < 1) then
        begin
          if R.FormulaInterval >= 1 then
            R.Interval := Min(R.FormulaInterval, 60)
          else
            R.Interval := 1;
        end;
        Cards[i].Interval := R.Interval;
        Cards[i].Stability := Cards[i].Interval;
        Cards[i].DueDay := day + Max(1, Round(R.Interval));
        Inc(Cards[i].Repetitions);
        Inc(Cards[i].Reviews);
        Inc(dayCount[day]);
        Inc(done_);
        Inc(TotalReviews);
      end;
      if (day < 5) or (day mod 5 = 0) then
        WriteLn(Format('  day %2d: %3d review(s)', [day + 1, done_]));
    end;

    sumInterval := 0;
    maxInterval := 0;
    for i := 0 to High(Cards) do
    begin
      sumInterval := sumInterval + Cards[i].Interval;
      if Cards[i].Interval > maxInterval then
        maxInterval := Cards[i].Interval;
    end;
    if Length(Cards) > 0 then
      FinalAvgInterval := sumInterval / Length(Cards);
    FinalMaxInterval := maxInterval;

    WriteLn;
    WriteLn('  per-day totals:');
    WriteLn(Format('  %-8s %s', ['day', 'reviews']));
    for day := 0 to Days - 1 do
      WriteLn(Format('  %-8d %d', [day + 1, dayCount[day]]));

    Result := True;
  finally
    C.Free;
  end;
end;

var
  root, arg: string;
  days, grade, i: Integer;
  total: Integer;
  avgI, maxI: Double;
begin
  root := 'F:\SMCollections\ABC';
  days := DEFAULT_DAYS;
  grade := 4;

  for i := 1 to ParamCount do
  begin
    arg := ParamStr(i);
    if Copy(arg, 1, 7) = '--days=' then
      days := StrToIntDef(Copy(arg, 8, MaxInt), DEFAULT_DAYS)
    else if Copy(arg, 1, 8) = '--grade=' then
      grade := StrToIntDef(Copy(arg, 9, MaxInt), 4)
    else if Copy(arg, 1, 2) <> '--' then
      root := arg;
  end;

  WriteLn('======================================================================');
  WriteLn('Workload forecast');
  WriteLn('======================================================================');
  WriteLn('collection : ', root);
  WriteLn('horizon    : ', days, ' days');
  WriteLn('assumed grade: ', grade, ' / 5');
  WriteLn;

  if not Simulate(root, days, grade, total, avgI, maxI) then
    Halt(2);

  WriteLn;
  WriteLn(Format('total reviews      : %d', [total]));
  WriteLn(Format('final avg interval : %.1f days', [avgI]));
  WriteLn(Format('final max interval : %.1f days', [maxI]));
  WriteLn;
  WriteLn('DONE');
end.
