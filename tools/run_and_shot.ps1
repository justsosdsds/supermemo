Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$exe = 'F:\Projects\逆向\sm19src\sm19.exe'
$p = Start-Process -FilePath $exe -PassThru
Start-Sleep -Seconds 6
$alive = -not $p.HasExited
$title = ''
if ($alive) { $p.Refresh(); $title = $p.MainWindowTitle }
$bounds = [System.Windows.Forms.SystemInformation]::VirtualScreen
$bmp = New-Object System.Drawing.Bitmap($bounds.Width, $bounds.Height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
$out = 'F:\Projects\逆向\work\sm19_run.png'
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
"alive=$alive pid=$($p.Id) title=[$title]"
if ($alive) { Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue; 'killed' }
"screenshot=$out"
