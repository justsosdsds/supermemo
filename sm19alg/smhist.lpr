program smhist;
{$mode objfpc}{$H+}

{ Print the learning history of a collection (info/RepetitionHistory.dat).

  Record layout, 39 bytes each:
    +0  int32   element id
    +4  int32   repetition number for that element
    +10 double  TDateTime of the review
    +25 uint16  0xffff on a first repetition
    +27 int32   grade (1..5)
    +38 byte    trailing marker

  Usage: smhist <collection> [--element=N] }

uses
  Classes, SysUtils, smcollection;

var
  root, arg: string;
  only: Integer;
  i: Integer;
  C: TSMCollection;
  reps: TSMRepetitions;
  grades: array[1..5] of Integer;
  total: Integer;
begin
  root := 'F:\SMCollections\ABC';
  only := 0;
  for i := 1 to ParamCount do
  begin
    arg := ParamStr(i);
    if Copy(arg, 1, 10) = '--element=' then
      only := StrToIntDef(Copy(arg, 11, MaxInt), 0)
    else if Copy(arg, 1, 2) <> '--' then
      root := arg;
  end;

  C := TSMCollection.Create(root);
  try
    reps := C.RepetitionHistory;
    WriteLn('======================================================================');
    WriteLn('Learning history');
    WriteLn('======================================================================');
    WriteLn('collection : ', root);
    WriteLn('records    : ', Length(reps));
    WriteLn;
    if Length(reps) = 0 then
    begin
      WriteLn('no repetition history yet — study a few cards in the original program');
      Halt(0);
    end;

    WriteLn(Format('%-4s %-6s %-4s %-20s %-6s %s',
      ['#', 'elem', 'rep', 'when', 'grade', 'first?']));

    for i := 1 to 5 do
      grades[i] := 0;
    total := 0;
    for i := 0 to High(reps) do
    begin
      if (only > 0) and (reps[i].ElementId <> only) then
        Continue;
      Inc(total);
      if (reps[i].Grade >= 1) and (reps[i].Grade <= 5) then
        Inc(grades[reps[i].Grade]);
      WriteLn(Format('%-4d %-6d %-4d %-20s %-6d %s',
        [i + 1, reps[i].ElementId, reps[i].Rep,
         FormatDateTime('yyyy-mm-dd hh:nn:ss', reps[i].When),
         reps[i].Grade,
         BoolToStr(reps[i].Marker = $FFFF, 'yes', 'no')]));
    end;

    WriteLn;
    WriteLn(Format('shown: %d record(s)', [total]));
    WriteLn(Format('grade distribution: 1=%d 2=%d 3=%d 4=%d 5=%d',
      [grades[1], grades[2], grades[3], grades[4], grades[5]]));
    WriteLn;
    WriteLn('DONE');
  finally
    C.Free;
  end;
end.
