"""Emit a Lazarus project file (.lpi) for command-line lazbuild."""
import json, os

BASE = r'F:\Projects\逆向\sm19src'
man = json.load(open(os.path.join(BASE, 'manifest.json'), encoding='utf-8'))

units = [''] * (len(man) + 1)


def esc(s):
    return s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')


head = '''<?xml version="1.0" encoding="UTF-8"?>
<CONFIG>
  <ProjectOptions>
    <Version Value="12"/>
    <General>
      <Flags>
        <MainUnitHasCreateFormStatements Value="True"/>
        <MainUnitHasTitleStatement Value="True"/>
        <MainUnitHasScaledStatement Value="False"/>
      </Flags>
      <SessionStorage Value="InProjectDir"/>
      <MainUnit Value="0"/>
      <Title Value="sm19"/>
      <ResourceType Value="res"/>
      <UseXPManifest Value="False"/>
      <Icon Value="0"/>
    </General>
    <BuildModes Count="1">
      <Item1 Name="Default" Default="True"/>
    </BuildModes>
    <RequiredPackages Count="2">
      <Item1>
        <PackageName Value="FCL"/>
      </Item1>
      <Item2>
        <PackageName Value="LCL"/>
      </Item2>
    </RequiredPackages>
    <Units Count="%d">''' % (len(man) + 1)

body = []
body.append('      <Unit0>\n        <Filename Value="sm19.lpr"/>\n        <IsPartOfProject Value="True"/>\n      </Unit0>')
for i, m in enumerate(man, 1):
    body.append('      <Unit%d>\n        <Filename Value="units/%s.pas"/>\n        <IsPartOfProject Value="True"/>\n        <UnitName Value="%s"/>\n      </Unit%d>' % (
        i, m['unit'], m['unit'], i))

tail = '''
    </Units>
  </ProjectOptions>
  <CompilerOptions>
    <Version Value="11"/>
    <Target>
      <Filename Value="sm19"/>
    </Target>
    <SearchPaths>
      <UnitOutputDirectory Value="lib"/>
      <IncludeFiles Value="units"/>
      <OtherUnitFiles Value="units"/>
      <UnitOutputDirectory Value="lib"/>
    </SearchPaths>
    <Parsing>
      <SyntaxOptions>
        <SyntaxMode Value="ObjFpc"/>
      </SyntaxOptions>
    </Parsing>
    <Other>
      <CustomOptions Value="-Se10"/>
    </Other>
    <CodeGeneration>
      <SmartLinkUnit Value="True"/>
      <Optimizations>
        <OptimizationLevel Value="0"/>
      </Optimizations>
    </CodeGeneration>
    <Linking>
      <Debugging>
        <GenerateDebugInfo Value="False"/>
      </Debugging>
      <LinkSmart Value="True"/>
      <Options>
        <Win32>
          <GraphicApplication Value="True"/>
        </Win32>
      </Options>
    </Linking>
  </CompilerOptions>
</CONFIG>
'''

open(os.path.join(BASE, 'sm19.lpi'), 'w', encoding='utf-8', newline='\n').write(
    head + '\n' + '\n'.join(body) + tail)
print('wrote', os.path.join(BASE, 'sm19.lpi'), 'units', len(man) + 1)
