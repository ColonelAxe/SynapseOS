$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$bitmap=[Drawing.Bitmap]::new(128,128);$graphics=[Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias
$background=[Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255,17,43,57))
$foreground=[Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255,191,226,241))
$graphics.FillEllipse($background,0,0,128,128)
$points=for($i=0;$i -lt 32;$i++){
    $radius=if(($i%4) -in @(1,2)){47}else{37}
    $angle=$i*[Math]::PI/16
    [Drawing.PointF]::new(64+$radius*[Math]::Cos($angle),64+$radius*[Math]::Sin($angle))
}
$graphics.FillPolygon($foreground,[Drawing.PointF[]]$points)
$graphics.FillEllipse($background,47,47,34,34)
$graphics.Dispose();$foreground.Dispose();$background.Dispose()
$png=Join-Path $root 'addons/core/ui/settings_app_ca.png'
$bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png);$bitmap.Dispose()
Copy-Item -LiteralPath $png -Destination (Join-Path $root 'preview/assets/settings-app.png') -Force
& 'C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe' $png ($png -replace '\.png$','.paa')
if ($LASTEXITCODE -ne 0) {throw 'Settings icon conversion failed'}
