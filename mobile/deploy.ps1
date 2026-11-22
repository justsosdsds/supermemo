# 部署脚本：只做覆盖安装，绝不清数据。
#
# 教训 2026-11-22：用 adb uninstall 部署 M2，删掉了用户已导入的文章。
# uninstall 会移除 /data/data/com.smreader 下的数据库。
# 本脚本只调用 install -r -d -t，不调用 uninstall。

param(
    [string]$Apk = "app\build\outputs\apk\debug\app-debug.apk",
    [string]$Device = ""
)

$ErrorActionPreference = "Stop"
$adb = "F:\Tools\platform-tools\adb.exe"

if (-not (Test-Path $Apk)) { throw "APK not found: $Apk" }

if ($Device -eq "") {
    $found = & $adb devices | Select-String -Pattern "\sdevice$" | ForEach-Object { ($_ -split "\s+")[0] }
    if ($null -eq $found) { throw "no device connected" }
    $Device = @($found)[0]
}
Write-Host "device: $Device"

# 检查现有数据
$probe = & $adb -s $Device shell "run-as com.smreader ls databases/" 2>&1
if ($probe -match "smreader.db") {
    Write-Host "existing data found, doing overwrite install (data preserved)"
} else {
    Write-Host "no existing data, doing fresh install"
}

# 只有这一条安装命令，永不调用 uninstall
& $adb -s $Device install -r -d -t $Apk
if ($LASTEXITCODE -ne 0) { throw "install failed" }

# 安装后校验
$after = & $adb -s $Device shell "run-as com.smreader ls databases/" 2>&1
if ($after -match "smreader.db") {
    $n = & $adb -s $Device shell "run-as com.smreader sqlite3 databases/smreader.db 'SELECT COUNT(*) FROM elements;'" 2>&1
    Write-Host "install ok, database kept, elements: $n"
} else {
    Write-Host "install ok (fresh install, no data yet)"
}

& $adb -s $Device shell am start -n com.smreader/.MainActivity | Out-Null
Write-Host "app started"