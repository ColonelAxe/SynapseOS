param([string]$Source)
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$original=Join-Path $root 'addons/core/ui/synapse_wallpaper_source.png'
if ($Source) {Copy-Item -LiteralPath $Source -Destination $original -Force}
$image=[Drawing.Image]::FromFile($original)
foreach($kind in @('tablet','phone')) {
    $aspect=if($kind -eq 'phone'){2.081}else{1.738}
    $cropW=$image.Width;$cropH=$cropW/$aspect
    if($cropH -gt $image.Height){$cropH=$image.Height;$cropW=$cropH*$aspect}
    $bitmap=[Drawing.Bitmap]::new(2048,1024);$graphics=[Drawing.Graphics]::FromImage($bitmap)
    $graphics.InterpolationMode=[Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $srcRect=[Drawing.RectangleF]::new(($image.Width-$cropW)/2,($image.Height-$cropH)/2,$cropW,$cropH)
    $graphics.DrawImage($image,[Drawing.RectangleF]::new(0,0,2048,1024),$srcRect,[Drawing.GraphicsUnit]::Pixel)
    $graphics.Dispose();$png=Join-Path $root ('addons/core/ui/wallpaper_'+$kind+'_ca.png')
    $bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png);$bitmap.Dispose()
    & 'C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe' $png ($png -replace '\.png$','.paa')
    if ($LASTEXITCODE -ne 0) {throw 'Wallpaper conversion failed'}
}
$image.Dispose()
Copy-Item -LiteralPath $original -Destination (Join-Path $root 'preview/assets/synapse-wallpaper.png') -Force
