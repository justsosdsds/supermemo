unit smcollection;

{ Reader for a SuperMemo collection directory.

  Layout (verified against a collection produced by the original binary):
    <name>.Kno                  index blob
    <name>/collection.ini       INI settings
    <name>/info/*.dat           element/component records
    <name>/alg17/*.dat          algorithm matrices (little-endian)
    <name>/registry/<R>.*       text pools (.rtx/.lst/.ptr/.mem)

  Matrices (all flat[R*441 + S*21 + D], 21x21x21):
    StabilityIncrease.dat       9261 doubles
    StabilityIncreaseCases.dat  9261 int32
    Recall.dat                  9261 int32
    RecallCases.dat             9261 int32 }

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  SM_DIM = 21;
  SM_CELLS = SM_DIM * SM_DIM * SM_DIM;
  SM_STRIDE_R = SM_DIM * SM_DIM;
  SM_STRIDE_S = SM_DIM;

type
  TDoubleArray = array of Double;
  TIntArray = array of Integer;

  TSMTextRecord = record
    Text: string;
    A: Integer;
    B: Integer;
  end;
  TSMTextRecords = array of TSMTextRecord;

  { info/ElementInfo.dat: fixed 118-byte records }
  TSMElement = record
    Slot: Integer;
    Flags: Byte;          // +0   (0x04 = root, 0x01 = child)
    Kind: Byte;           // +1
    Id: Integer;          // +2   uint16 element id
    CompOffset: Cardinal; // +6   offset into compon.dat
    CompSize: Integer;    // +10
    Created: TDateTime;   // +20  TDateTime (days since 1899-12-30)
    Ordinal: Integer;     // +40  0-based element ordinal
    Interval: Double;     // +32  interval hint (0 or 2.0 in fresh collections)
  end;
  TSMElements = array of TSMElement;

  { info/contents.dat: 37-byte records forming the element tree }
  TSMContentItem = record
    Ordinal: Integer;      { 1-based, matches element slot + 1 }
    Flags: Byte;
    Parent: Integer;       { +1 }
    FirstChild: Integer;   { +5 }
    LastChild: Integer;    { +9 }
    PrevSibling: Integer;  { +13 }
    NextSibling: Integer;  { +17 }
    ChildCount: Integer;   { +21 }
  end;
  TSMContents = array of TSMContentItem;

  { info/RepetitionHistory.dat: 39-byte records, one per review }
  TSMRepetition = record
    ElementId: Integer;      { +0 }
    Rep: Integer;            { +4 }
    When: TDateTime;         { +10 double }
    Marker: Word;            { +25, 0xffff on the first repetition }
    Grade: Integer;          { +27 }
    Trail: Byte;             { +38 }
  end;
  TSMRepetitions = array of TSMRepetition;

  TSMCollection = class
  private
    FRoot: string;
    FName: string;
    FStabilityIncrease: TDoubleArray;
    FStabilityCases: TIntArray;
    FRecall: TIntArray;
    FLoaded: Boolean;
    function AlgPath(const AFile: string): string;
    function ReadDoubles(const AFile: string; out Data: TDoubleArray): Boolean;
    function ReadInts(const AFile: string; out Data: TIntArray): Boolean;
    function WriteDoubles(const AFile: string; const Data: TDoubleArray): Boolean;
  public
    constructor Create(const ARoot: string);
    function Load: Boolean;
    function SaveStabilityIncrease: Boolean;
    function SaveStabilityCases: Boolean;
    function CellIndex(R, S, D: Integer): Integer;
    function StabilityIncrease(R, S, D: Integer): Double;
    procedure SetStabilityIncrease(R, S, D: Integer; const Value: Double);
    function Cases(R, S, D: Integer): Integer;
    procedure SetCases(R, S, D: Integer; const Value: Integer);
    function TextPool(const ARes: string): TSMTextRecords;
    function Elements: TSMElements;
    function Contents: TSMContents;
    function RepetitionHistory: TSMRepetitions;
    { stats\<name>.dat holds two int32: value for today, value for the total }
    function StatsPair(const AName: string; out AToday, ATotal: Integer): Boolean;
    function StatsToday(const AName: string): Integer;
    function StatsTotal(const AName: string): Integer;
    function ElementIdOfOrdinal(const AOrdinal: Integer): Integer;
    function RootOrdinal: Integer;
    function ChildrenOf(const AOrdinal: Integer): TIntArray;
    function ElementText(const ElemId: Integer): string;
    property Root: string read FRoot;
    property Name: string read FName;
    property Loaded: Boolean read FLoaded;
    property StabilityMatrix: TDoubleArray read FStabilityIncrease;
  end;

implementation

constructor TSMCollection.Create(const ARoot: string);
begin
  inherited Create;
  FRoot := ExcludeTrailingPathDelimiter(ARoot);
  FName := ExtractFileName(FRoot);
  FLoaded := False;
end;

function TSMCollection.AlgPath(const AFile: string): string;
begin
  Result := IncludeTrailingPathDelimiter(FRoot) + 'alg17' + PathDelim + AFile;
end;

function TSMCollection.ReadDoubles(const AFile: string; out Data: TDoubleArray): Boolean;
var
  fs: TFileStream;
  n: Integer;
begin
  Result := False;
  SetLength(Data, 0);
  if not FileExists(AFile) then
    Exit;
  fs := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    n := fs.Size div SizeOf(Double);
    SetLength(Data, n);
    if n > 0 then
      fs.ReadBuffer(Data[0], n * SizeOf(Double));
    Result := True;
  finally
    fs.Free;
  end;
end;

function TSMCollection.ReadInts(const AFile: string; out Data: TIntArray): Boolean;
var
  fs: TFileStream;
  n: Integer;
begin
  Result := False;
  SetLength(Data, 0);
  if not FileExists(AFile) then
    Exit;
  fs := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    n := fs.Size div SizeOf(Integer);
    SetLength(Data, n);
    if n > 0 then
      fs.ReadBuffer(Data[0], n * SizeOf(Integer));
    Result := True;
  finally
    fs.Free;
  end;
end;

function TSMCollection.WriteDoubles(const AFile: string; const Data: TDoubleArray): Boolean;
var
  fs: TFileStream;
begin
  Result := False;
  if Length(Data) = 0 then
    Exit;
  fs := TFileStream.Create(AFile, fmCreate);
  try
    fs.WriteBuffer(Data[0], Length(Data) * SizeOf(Double));
    Result := True;
  finally
    fs.Free;
  end;
end;

function TSMCollection.Load: Boolean;
begin
  Result := ReadDoubles(AlgPath('StabilityIncrease.dat'), FStabilityIncrease)
    and (Length(FStabilityIncrease) >= SM_CELLS);
  ReadInts(AlgPath('StabilityIncreaseCases.dat'), FStabilityCases);
  ReadInts(AlgPath('Recall.dat'), FRecall);
  FLoaded := Result;
end;

function TSMCollection.SaveStabilityIncrease: Boolean;
begin
  Result := WriteDoubles(AlgPath('StabilityIncrease.dat'), FStabilityIncrease);
end;

function TSMCollection.SaveStabilityCases: Boolean;
var
  fs: TFileStream;
begin
  Result := False;
  if Length(FStabilityCases) = 0 then
    Exit;
  fs := TFileStream.Create(AlgPath('StabilityIncreaseCases.dat'), fmCreate);
  try
    fs.WriteBuffer(FStabilityCases[0], Length(FStabilityCases) * SizeOf(Integer));
    Result := True;
  finally
    fs.Free;
  end;
end;

function TSMCollection.CellIndex(R, S, D: Integer): Integer;
begin
  Result := R * SM_STRIDE_R + S * SM_STRIDE_S + D;
end;

function TSMCollection.StabilityIncrease(R, S, D: Integer): Double;
var
  i: Integer;
begin
  i := CellIndex(R, S, D);
  if (i >= 0) and (i < Length(FStabilityIncrease)) then
    Result := FStabilityIncrease[i]
  else
    Result := 0.0;
end;

procedure TSMCollection.SetStabilityIncrease(R, S, D: Integer; const Value: Double);
var
  i: Integer;
begin
  i := CellIndex(R, S, D);
  if (i >= 0) and (i < Length(FStabilityIncrease)) then
    FStabilityIncrease[i] := Value;
end;

function TSMCollection.Cases(R, S, D: Integer): Integer;
var
  i: Integer;
begin
  i := CellIndex(R, S, D);
  if (i >= 0) and (i < Length(FStabilityCases)) then
    Result := FStabilityCases[i]
  else
    Result := 0;
end;

procedure TSMCollection.SetCases(R, S, D: Integer; const Value: Integer);
var
  i: Integer;
begin
  i := CellIndex(R, S, D);
  if (i >= 0) and (i < Length(FStabilityCases)) then
    FStabilityCases[i] := Value;
end;

function TSMCollection.TextPool(const ARes: string): TSMTextRecords;
var
  path: string;
  raw: TStringList;
  fs: TFileStream;
  data: TBytes;
  i, start, zero, a, b: Integer;
  s: string;
  n: Integer;
begin
  SetLength(Result, 0);
  path := IncludeTrailingPathDelimiter(FRoot) + 'registry' + PathDelim + ARes + '.rtx';
  if not FileExists(path) then
    Exit;
  fs := TFileStream.Create(path, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(data, fs.Size);
    if fs.Size > 0 then
      fs.ReadBuffer(data[0], fs.Size);
  finally
    fs.Free;
  end;

  i := 0;
  n := 0;
  while i < Length(data) do
  begin
    start := i;
    zero := -1;
    while (i < Length(data)) and (data[i] <> 0) do
      Inc(i);
    if i >= Length(data) then
      Break;
    zero := i;
    SetLength(s, zero - start);
    if zero > start then
      Move(data[start], s[1], zero - start);

    Inc(i);  // skip NUL
    a := 0;
    b := 0;
    if i + 4 <= Length(data) then
    begin
      Move(data[i], a, 4);
      Inc(i, 4);
    end;
    if i < Length(data) then
    begin
      b := data[i];
      Inc(i);
    end;

    SetLength(Result, n + 1);
    Result[n].Text := s;
    Result[n].A := a;
    Result[n].B := b;
    Inc(n);
  end;
end;

function TSMCollection.Elements: TSMElements;
var
  path: string;
  fs: TFileStream;
  data: TBytes;
  n, i, off: Integer;
begin
  SetLength(Result, 0);
  path := IncludeTrailingPathDelimiter(FRoot) + 'info' + PathDelim + 'ElementInfo.dat';
  if not FileExists(path) then
    Exit;
  fs := TFileStream.Create(path, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(data, fs.Size);
    if fs.Size > 0 then
      fs.ReadBuffer(data[0], fs.Size);
  finally
    fs.Free;
  end;
  n := Length(data) div 118;
  SetLength(Result, n);
  for i := 0 to n - 1 do
  begin
    off := i * 118;
    Result[i].Slot := i;
    Result[i].Flags := data[off];
    Result[i].Kind := data[off + 1];
    Result[i].Id := PWord(@data[off + 2])^;
    Result[i].CompOffset := PCardinal(@data[off + 6])^;
    Result[i].CompSize := PWord(@data[off + 10])^;
    Result[i].Created := PDouble(@data[off + 20])^;
    Result[i].Interval := PDouble(@data[off + 32])^;
    Result[i].Ordinal := PInteger(@data[off + 40])^;
  end;
end;

function TSMCollection.ElementText(const ElemId: Integer): string;
var
  recs: TSMTextRecords;
  i, start: Integer;
begin
  Result := '';
  recs := TextPool('Text');
  for i := 0 to High(recs) do
    if recs[i].A = ElemId then
    begin
      Result := recs[i].Text;
      start := 1;
      while (start <= Length(Result)) and (Result[start] < #32) do
        Inc(start);
      Result := Trim(Copy(Result, start, MaxInt));
      Exit;
    end;
end;



function TSMCollection.Contents: TSMContents;
var
  path: string;
  fs: TFileStream;
  data: TBytes;
  n, i, off: Integer;
begin
  SetLength(Result, 0);
  path := IncludeTrailingPathDelimiter(FRoot) + 'info' + PathDelim + 'contents.dat';
  if not FileExists(path) then
    Exit;
  fs := TFileStream.Create(path, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(data, fs.Size);
    if fs.Size > 0 then
      fs.ReadBuffer(data[0], fs.Size);
  finally
    fs.Free;
  end;
  n := Length(data) div 37;
  SetLength(Result, n);
  for i := 0 to n - 1 do
  begin
    off := i * 37;
    Result[i].Ordinal := i + 1;
    Result[i].Flags := data[off];
    Result[i].Parent := PWord(@data[off + 1])^;
    Result[i].FirstChild := PWord(@data[off + 5])^;
    Result[i].LastChild := PWord(@data[off + 9])^;
    Result[i].PrevSibling := PWord(@data[off + 13])^;
    Result[i].NextSibling := PWord(@data[off + 17])^;
    Result[i].ChildCount := PWord(@data[off + 21])^;
  end;
end;

function TSMCollection.ElementIdOfOrdinal(const AOrdinal: Integer): Integer;
var
  els: TSMElements;
begin
  Result := 0;
  els := Elements;
  if (AOrdinal >= 1) and (AOrdinal <= Length(els)) then
    Result := els[AOrdinal - 1].Id;
end;

function TSMCollection.RootOrdinal: Integer;
var
  c: TSMContents;
  i: Integer;
begin
  Result := 0;
  c := Contents;
  for i := 0 to High(c) do
    if c[i].Parent = 0 then
      Exit(c[i].Ordinal);
  if Length(c) > 0 then
    Result := c[0].Ordinal;
end;

function TSMCollection.ChildrenOf(const AOrdinal: Integer): TIntArray;
var
  c: TSMContents;
  i, cur, guard: Integer;
begin
  SetLength(Result, 0);
  c := Contents;
  if (AOrdinal < 1) or (AOrdinal > Length(c)) then
    Exit;
  cur := c[AOrdinal - 1].FirstChild;
  guard := 0;
  while (cur >= 1) and (cur <= Length(c)) and (guard < 500) do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)] := cur;
    if c[cur - 1].NextSibling = cur then
      Break;
    cur := c[cur - 1].NextSibling;
    Inc(guard);
  end;
end;


function TSMCollection.RepetitionHistory: TSMRepetitions;
const
  REC = 39;
var
  path: string;
  fs: TFileStream;
  data: TBytes;
  n, i, off: Integer;
begin
  SetLength(Result, 0);
  path := IncludeTrailingPathDelimiter(FRoot) + 'info' + PathDelim + 'RepetitionHistory.dat';
  if not FileExists(path) then
    Exit;
  fs := TFileStream.Create(path, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(data, fs.Size);
    if fs.Size > 0 then
      fs.ReadBuffer(data[0], fs.Size);
  finally
    fs.Free;
  end;
  n := Length(data) div REC;
  SetLength(Result, n);
  for i := 0 to n - 1 do
  begin
    off := i * REC;
    Result[i].ElementId := PInteger(@data[off])^;
    Result[i].Rep := PInteger(@data[off + 4])^;
    Result[i].When := PDouble(@data[off + 10])^;
    Result[i].Marker := PWord(@data[off + 25])^;
    Result[i].Grade := PInteger(@data[off + 27])^;
    Result[i].Trail := data[off + 38];
  end;
end;


function TSMCollection.StatsPair(const AName: string; out AToday, ATotal: Integer): Boolean;
var
  path: string;
  fs: TFileStream;
  buf: array[0..7] of Byte;
  n: Integer;
begin
  Result := False;
  AToday := 0;
  ATotal := 0;
  path := IncludeTrailingPathDelimiter(FRoot) + 'stats' + PathDelim + AName + '.dat';
  if not FileExists(path) then
    Exit;
  fs := TFileStream.Create(path, fmOpenRead or fmShareDenyWrite);
  try
    FillChar(buf, SizeOf(buf), 0);
    n := fs.Read(buf, SizeOf(buf));
    if n >= 4 then
      AToday := PInteger(@buf[0])^;
    if n >= 8 then
      ATotal := PInteger(@buf[4])^
    else
      ATotal := AToday;
    Result := True;
  finally
    fs.Free;
  end;
end;

function TSMCollection.StatsToday(const AName: string): Integer;
var
  t, v: Integer;
begin
  if StatsPair(AName, t, v) then
    Result := t
  else
    Result := 0;
end;

function TSMCollection.StatsTotal(const AName: string): Integer;
var
  t, v: Integer;
begin
  if StatsPair(AName, t, v) then
    Result := v
  else
    Result := 0;
end;

end.
