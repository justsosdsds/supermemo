program smstats;
{$mode objfpc}{$H+}
{ Show the statistics the original program keeps in stats\*.dat }
uses SysUtils, smcollection;
const
  NAMES: array[0..11] of string = (
    'itemtotal', 'itemmemorized', 'itemoutstanding', 'itemreps',
    'topicreps', 'retention', 'Recall', 'burden',
    'reptime', 'total', 'memorized', 'outstanding');
var
  C: TSMCollection;
  root: string;
  i, t, v: Integer;
begin
  root := 'F:\SMCollections\ABC';
  if ParamCount >= 1 then root := ParamStr(1);
  C := TSMCollection.Create(root);
  try
    WriteLn('======================================================================');
    WriteLn('Statistics');
    WriteLn('======================================================================');
    WriteLn('collection : ', root);
    WriteLn;
    WriteLn(Format('%-22s %-10s %-10s', ['metric', 'today', 'total']));
    for i := Low(NAMES) to High(NAMES) do
      if C.StatsPair(NAMES[i], t, v) then
        WriteLn(Format('%-22s %-10d %-10d', [NAMES[i], t, v]));
    WriteLn;
    WriteLn('DONE');
  finally
    C.Free;
  end;
end.
