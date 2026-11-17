param([string]$Source)
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$original=Join-Path $root 'addons/core/ui/atlas_app_source.png'
if ($Source) {Copy-Item -LiteralPath $Source -Destination $original -Force}
$inputImage=[Drawing.Image]::FromFile($original)
$bitmap=[Drawing.Bitmap]::new(512,512)
$graphics=[Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([Drawing.Color]::Transparent)
$graphics.InterpolationMode=[Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$scale=[Math]::Min(512/$inputImage.Width,512/$inputImage.Height)
$width=[int]($inputImage.Width*$scale);$height=[int]($inputImage.Height*$scale)
$graphics.DrawImage($inputImage,[int]((512-$width)/2),[int]((512-$height)/2),$width,$height)
$inputImage.Dispose();$graphics.Dispose()
$png=Join-Path $root 'addons/core/ui/atlas_app_ca.png'
$bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png);$bitmap.Dispose()
Copy-Item -LiteralPath $png -Destination (Join-Path $root 'preview/assets/atlas-app.png') -Force
& 'C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe' $png (Join-Path $root 'addons/core/ui/atlas_app_ca.paa')
if ($LASTEXITCODE -ne 0) {throw 'ATLAS app icon conversion failed'}
