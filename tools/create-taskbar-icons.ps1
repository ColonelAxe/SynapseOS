$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$converter='C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe'
foreach($kind in @('start','taskview','network','volume','notifications')){
    $b=[Drawing.Bitmap]::new(128,128);$g=[Drawing.Graphics]::FromImage($b);$g.SmoothingMode='AntiAlias'
    $pen=[Drawing.Pen]::new([Drawing.Color]::FromArgb(238,240,246,250),5)
    $brush=[Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(238,240,246,250))
    switch($kind){
        'start' {foreach($x in @(16,68)){foreach($y in @(16,68)){$g.FillRectangle($brush,$x,$y,44,44)}}}
        'taskview' {$g.DrawRectangle($pen,24,27,67,74);$g.DrawLine($pen,10,38,10,90);$g.DrawLine($pen,108,38,108,90)}
        'network' {$g.DrawRectangle($pen,15,21,98,65);$g.DrawLine($pen,64,86,64,105);$g.DrawLine($pen,41,106,87,106)}
        'volume' {$g.FillPolygon($brush,[Drawing.Point[]]@([Drawing.Point]::new(12,48),[Drawing.Point]::new(34,48),[Drawing.Point]::new(58,25),[Drawing.Point]::new(58,103),[Drawing.Point]::new(34,80),[Drawing.Point]::new(12,80)));$g.DrawArc($pen,52,39,45,50,-70,140);$g.DrawArc($pen,53,20,65,88,-65,130)}
        'notifications' {$g.DrawLines($pen,[Drawing.Point[]]@([Drawing.Point]::new(18,23),[Drawing.Point]::new(110,23),[Drawing.Point]::new(110,91),[Drawing.Point]::new(51,91),[Drawing.Point]::new(32,111),[Drawing.Point]::new(32,91),[Drawing.Point]::new(18,91),[Drawing.Point]::new(18,23)))}
    }
    $pen.Dispose();$brush.Dispose();$g.Dispose()
    $png=Join-Path $root ('addons/core/ui/taskbar_'+$kind+'_ca.png');$b.Save($png,[Drawing.Imaging.ImageFormat]::Png);$b.Dispose()
    & $converter $png ($png -replace '\.png$','.paa');if($LASTEXITCODE -ne 0){throw 'Taskbar icon conversion failed'}
    Copy-Item -LiteralPath $png -Destination (Join-Path $root ('preview/assets/taskbar-'+$kind+'.png')) -Force
}
