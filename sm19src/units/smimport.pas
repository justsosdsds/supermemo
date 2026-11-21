unit smimport;

{ Writes new cards into a collection — the Object Pascal counterpart of
  tools/sm_import.py.

  Formats (all verified against collections produced by the original binary):

    info/ElementInfo.dat  118-byte records  id@+2 comp_off@+6 comp_size@+10
                                           created@+20 (TDateTime) ordinal@+40
    info/contents.dat      37-byte records  parent@+1 first@+5 last@+9
                                           prev@+13 next@+17 kids@+21
    info/compon.dat        fixed blocks cloned from an existing element
    registry/Text.rtx      <utf8 text> NUL <int32 id> <byte 1>
    registry/Text.mem      30-byte records: status, kind=3,
                           (offset+1)<<16, length<<16, id<<16
    registry/Text.ptr      int32 id per record

  Text.lst is intentionally left untouched: testing showed the original
  program accepts appended records without it. }

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, smcollection;

type
  TQAPair = record
    Question: string;
    Answer: string;
  end;
  TQAPairs = array of TQAPair;

function ReadQAFile(const APath: string): TQAPairs;
function ImportQAInto(const ACollectionRoot, AQAPath: string;
  out AddedCount: Integer; out ErrMsg: string): Boolean;

implementation

const
  SM_INFOREC = 118;
  SM_CONTREC = 37;
  SM_MEMREC = 30;

function ReadQAFile(const APath: string): TQAPairs;
var
  sl: TStringList;
  i: Integer;
  s: string;
  pendingQ: string;
  hasQ: Boolean;
begin
  SetLength(Result, 0);
  sl := TStringList.Create;
  try
    sl.LoadFromFile(APath);
    hasQ := False;
    pendingQ := '';
    for i := 0 to sl.Count - 1 do
    begin
      s := Trim(sl[i]);
      if s = '' then
        Continue;
      if (Length(s) > 2) and (UpperCase(Copy(s, 1, 2)) = 'Q:') then
      begin
        pendingQ := Trim(Copy(s, 3, MaxInt));
        hasQ := True;
      end
      else if (Length(s) > 2) and (UpperCase(Copy(s, 1, 2)) = 'A:') and hasQ then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)].Question := pendingQ;
        Result[High(Result)].Answer := Trim(Copy(s, 3, MaxInt));
        hasQ := False;
      end;
    end;
  finally
    sl.Free;
  end;
end;

function LoadStream(const APath: string): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  if FileExists(APath) then
    Result.LoadFromFile(APath);
end;

procedure SaveStream(const APath: string; AStream: TMemoryStream);
begin
  AStream.SaveToFile(APath);
end;

function ImportQAInto(const ACollectionRoot, AQAPath: string;
  out AddedCount: Integer; out ErrMsg: string): Boolean;
var
  root, infoPath, contPath, compPath, rtxPath, memPath, ptrPath: string;
  info, cont, comp, rtx, mem, ptr: TMemoryStream;
  pairs: TQAPairs;
  nElem, nCont, i, maxId, maxOrd, tmplIdx, newId, newOrd: Integer;
  compOff, tmplOff, tmplSize, blobOff, blobLen, newContIdx: Integer;
  rec, crec: array[0..SM_INFOREC - 1] of Byte;
  memRec: array[0..SM_MEMREC - 1] of Byte;
  rootRec: array[0..SM_CONTREC - 1] of Byte;
  tmp: array[0..SM_CONTREC - 1] of Byte;
  txt, tmplBuf: TBytes;
  nul: Byte;
  one: Byte;
  created: Double;
  kids: array of Integer;
  kidCount, cur, guard, lastOrd: Integer;
  q, a, lbl: string;
begin
  Result := False;
  AddedCount := 0;
  ErrMsg := '';
  root := ExcludeTrailingPathDelimiter(ACollectionRoot);
  infoPath := root + PathDelim + 'info' + PathDelim + 'ElementInfo.dat';
  contPath := root + PathDelim + 'info' + PathDelim + 'contents.dat';
  compPath := root + PathDelim + 'info' + PathDelim + 'compon.dat';
  rtxPath := root + PathDelim + 'registry' + PathDelim + 'Text.rtx';
  memPath := root + PathDelim + 'registry' + PathDelim + 'Text.mem';
  ptrPath := root + PathDelim + 'registry' + PathDelim + 'Text.ptr';

  if not FileExists(infoPath) then
  begin
    ErrMsg := 'collection not found: ' + infoPath;
    Exit;
  end;
  pairs := ReadQAFile(AQAPath);
  if Length(pairs) = 0 then
  begin
    ErrMsg := 'no Q:/A: pairs found in ' + AQAPath;
    Exit;
  end;

  info := LoadStream(infoPath);
  cont := LoadStream(contPath);
  comp := LoadStream(compPath);
  rtx := LoadStream(rtxPath);
  mem := LoadStream(memPath);
  ptr := LoadStream(ptrPath);
  try
    nElem := info.Size div SM_INFOREC;
    nCont := cont.Size div SM_CONTREC;
    if nElem = 0 then
    begin
      ErrMsg := 'collection has no elements';
      Exit;
    end;

    maxId := 0;
    maxOrd := 0;
    tmplIdx := -1;
    tmplOff := 0;
    tmplSize := 0;
    for i := 0 to nElem - 1 do
    begin
      info.Position := i * SM_INFOREC;
      info.ReadBuffer(rec, SM_INFOREC);
      if PWord(@rec[2])^ > maxId then
        maxId := PWord(@rec[2])^;
      if PInteger(@rec[40])^ > maxOrd then
        maxOrd := PInteger(@rec[40])^;
      if (PInteger(@rec[6])^ <> -1) and (PWord(@rec[10])^ > 0) then
      begin
        tmplIdx := i;
        tmplOff := PInteger(@rec[6])^;
        tmplSize := PWord(@rec[10])^;
      end;
    end;
    { new ids must also avoid ids already used by the text pool }
    ptr.Position := 0;
    while ptr.Position + 4 <= ptr.Size do
    begin
      ptr.ReadBuffer(i, 4);
      if i > maxId then
        maxId := i;
    end;
    if tmplIdx < 0 then
    begin
      ErrMsg := 'no element with a component block to clone';
      Exit;
    end;

    created := (Now - EncodeDate(1899, 12, 30));

    SetLength(kids, 0);
    cont.Position := 0;
    cont.ReadBuffer(rootRec, SM_CONTREC);
    cur := PWord(@rootRec[5])^;
    guard := 0;
    while (cur >= 1) and (cur <= nCont) and (guard < 500) do
    begin
      SetLength(kids, Length(kids) + 1);
      kids[High(kids)] := cur;
      cont.Position := (cur - 1) * SM_CONTREC + 17;
      cont.ReadBuffer(i, 2);
      cur := i;
      Inc(guard);
    end;

    newId := maxId;
    newOrd := maxOrd;
    for i := 0 to High(pairs) do
    begin
      Inc(newId);
      Inc(newOrd);

      { --- text record --- }
      blobOff := rtx.Size;
      q := pairs[i].Question + ' :: ' + pairs[i].Answer;
      txt := TEncoding.UTF8.GetBytes(q);
      rtx.Position := rtx.Size;
      if Length(txt) > 0 then
        rtx.WriteBuffer(txt[0], Length(txt));
      nul := 0;
      rtx.WriteBuffer(nul, 1);
      rtx.WriteBuffer(newId, 4);
      one := 1;
      rtx.WriteBuffer(one, 1);
      blobLen := rtx.Size - blobOff;

      FillChar(memRec, SM_MEMREC, 0);
      PInteger(@memRec[0])^ := 1;
      PInteger(@memRec[4])^ := 3;
      PInteger(@memRec[8])^ := (blobOff + 1) shl 16;
      PInteger(@memRec[12])^ := blobLen shl 16;
      PInteger(@memRec[16])^ := newId shl 16;
      mem.Position := mem.Size;
      mem.WriteBuffer(memRec, SM_MEMREC);
      ptr.Position := ptr.Size;
      ptr.WriteBuffer(newId, 4);

      { --- element record --- }
      info.Position := tmplIdx * SM_INFOREC;
      info.ReadBuffer(rec, SM_INFOREC);
      rec[0] := 1;
      rec[1] := 1;
      PWord(@rec[2])^ := newId;
      compOff := comp.Size;
      SetLength(tmplBuf, tmplSize);
      comp.Position := tmplOff;
      comp.ReadBuffer(tmplBuf[0], tmplSize);
      { +4 in the component block holds (element ordinal + 1); the cloned block
        still carries the template's value, so rewrite it for this element }
      if tmplSize >= 8 then
        PInteger(@tmplBuf[4])^ := newOrd + 1;
      comp.Position := compOff;
      comp.WriteBuffer(tmplBuf[0], tmplSize);
      PInteger(@rec[6])^ := compOff;
      PWord(@rec[10])^ := tmplSize;
      PDouble(@rec[20])^ := created;
      PInteger(@rec[40])^ := newOrd;
      info.Position := info.Size;
      info.WriteBuffer(rec, SM_INFOREC);

      { --- contents record (appended as last child) --- }
      lastOrd := newOrd;
      FillChar(crec, SM_CONTREC, 0);
      PWord(@crec[1])^ := 1;
      newContIdx := cont.Size div SM_CONTREC;
      cont.Position := cont.Size;
      cont.WriteBuffer(crec, SM_CONTREC);

      SetLength(kids, Length(kids) + 1);
      kids[High(kids)] := lastOrd;
      Inc(AddedCount);
    end;

    { --- rebuild sibling chain + root pointers --- }
    cont.Position := 0;
    cont.ReadBuffer(rootRec, SM_CONTREC);
    PWord(@rootRec[5])^ := kids[0];
    PWord(@rootRec[9])^ := kids[High(kids)];
    PWord(@rootRec[21])^ := Length(kids);
    cont.Position := 0;
    cont.WriteBuffer(rootRec, SM_CONTREC);
    for i := 0 to High(kids) do
    begin
      cont.Position := (kids[i] - 1) * SM_CONTREC;
      cont.ReadBuffer(tmp, SM_CONTREC);
      if i > 0 then
        PWord(@tmp[13])^ := kids[i - 1]
      else
        PWord(@tmp[13])^ := 0;
      if i + 1 <= High(kids) then
        PWord(@tmp[17])^ := kids[i + 1]
      else
        PWord(@tmp[17])^ := 0;
      cont.Position := (kids[i] - 1) * SM_CONTREC;
      cont.WriteBuffer(tmp, SM_CONTREC);
    end;

    SaveStream(infoPath, info);
    SaveStream(contPath, cont);
    SaveStream(compPath, comp);
    SaveStream(rtxPath, rtx);
    SaveStream(memPath, mem);
    SaveStream(ptrPath, ptr);
    Result := True;
  finally
    info.Free;
    cont.Free;
    comp.Free;
    rtx.Free;
    mem.Free;
    ptr.Free;
  end;
end;

end.
