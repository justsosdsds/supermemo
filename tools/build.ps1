$ErrorActionPreference = 'Stop'
$base = 'F:\Projects\逆向'
$py = 'C:\Users\25335\AppData\Local\Programs\Python\Python312\python.exe'
$laz = 'C:\lazarus\lazbuild.exe'
$env:PYTHONIOENCODING = 'utf-8'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Output '=== 1) regenerate units + lfm from DFM json ==='
& $py "$base\tools\gen_skeleton.py"

Write-Output '=== 2) regenerate propdump project + build + dump LCL props ==='
& $py "$base\tools\gen_propdump.py" | Select-Object -First 1
& $laz --build-all "$base\sm19src\tools\propdump.lpi" 2>&1 | Select-String -Pattern 'Linking|Error|Fatal' | Select-Object -First 3
& "$base\sm19src\tools\bin\propdump.exe" "$base\sm19src\tools\props.txt"

Write-Output '=== 3) prune LFM to LCL-safe properties ==='
& $py "$base\tools\prune_lfm.py" 2>&1 | Select-Object -Last 25

Write-Output '=== 4) regenerate lpi + build project ==='
& $py "$base\tools\gen_lpi.py" | Select-Object -First 1
& $laz --build-all "$base\sm19src\sm19.lpi" 2>&1 | Select-Object -Last 40
