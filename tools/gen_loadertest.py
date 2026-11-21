"""Generate a loader test that instantiates every reconstructed form so that
each LFM is really streamed through LCL's component reader."""
import json, os

BASE = r'F:\Projects\逆向\sm19src'
man = json.load(open(os.path.join(BASE, 'manifest.json'), encoding='utf-8'))
units = [m['unit'] for m in man]
rows = ["  (Name: '%s'; Cls: %s)" % (m['cls'], m['cls']) for m in man]

src = '''program loadertest;
{$mode objfpc}{$H+}

uses
  Interfaces, Forms, SysUtils, Classes,
  %s;

type
  TEntry = record
    Name: string;
    Cls: TFormClass;
  end;

const
  Entries: array[0..%d] of TEntry = (
%s
  );

var
  i: Integer;
  f: TForm;
  okCount, failCount: Integer;
begin
  Application.Initialize;
  okCount := 0;
  failCount := 0;
  for i := 0 to High(Entries) do
  begin
    try
      f := nil;
      Application.CreateForm(Entries[i].Cls, f);
      try
        WriteLn('OK   ', Entries[i].Name, ' comps=', f.ComponentCount);
        Inc(okCount);
      finally
        f.Free;
      end;
    except
      on E: Exception do
      begin
        WriteLn('FAIL ', Entries[i].Name, ' :: ', E.ClassName, ': ', E.Message);
        Inc(failCount);
      end;
    end;
  end;
  WriteLn('SUMMARY ok=', okCount, ' fail=', failCount);
end.
''' % (',\n  '.join(units), len(man) - 1, ',\n'.join(rows))

open(os.path.join(BASE, 'tools', 'loadertest.lpr'), 'w', encoding='utf-8', newline='\r\n').write(src)

lpi = '''<?xml version="1.0" encoding="UTF-8"?>
<CONFIG>
  <ProjectOptions>
    <Version Value="12"/>
    <General>
      <SessionStorage Value="InProjDir"/>
      <MainUnit Value="0"/>
      <Title Value="loadertest"/>
      <ResourceType Value="res"/>
    </General>
    <BuildModes Count="1">
      <Item1 Name="Default" Default="True"/>
    </BuildModes>
    <RequiredPackages Count="2">
      <Item1><PackageName Value="FCL"/></Item1>
      <Item2><PackageName Value="LCL"/></Item2>
    </RequiredPackages>
    <Units Count="1">
      <Unit0><Filename Value="loadertest.lpr"/><IsPartOfProject Value="True"/></Unit0>
    </Units>
  </ProjectOptions>
  <CompilerOptions>
    <Version Value="11"/>
    <Target><Filename Value="bin/loadertest"/></Target>
    <SearchPaths>
      <UnitOutputDirectory Value="bin"/>
      <IncludeFiles Value="../units"/>
      <OtherUnitFiles Value="../units;.."/>
    </SearchPaths>
    <Parsing><SyntaxOptions><SyntaxMode Value="ObjFpc"/></SyntaxOptions></Parsing>
    <Linking><Options><Win32><GraphicApplication Value="False"/></Win32></Options></Linking>
  </CompilerOptions>
</CONFIG>
'''
open(os.path.join(BASE, 'tools', 'loadertest.lpi'), 'w', encoding='utf-8', newline='\n').write(lpi)
print('wrote loadertest project, forms:', len(man))
