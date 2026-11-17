$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$outDir=Join-Path $root 'addons/core/ui'
New-Item -ItemType Directory -Force $outDir | Out-Null
$bitmap=New-Object Drawing.Bitmap(2048,1024)
$g=[Drawing.Graphics]::FromImage($bitmap)
$g.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([Drawing.Color]::Transparent)
$g.ScaleTransform(1.28,1.024)
function RoundPath([single]$x,[single]$y,[single]$w,[single]$h,[single]$r){
    $p=New-Object Drawing.Drawing2D.GraphicsPath
    $d=$r*2
    $p.AddArc($x,$y,$d,$d,180,90);$p.AddArc($x+$w-$d,$y,$d,$d,270,90)
    $p.AddArc($x+$w-$d,$y+$h-$d,$d,$d,0,90);$p.AddArc($x,$y+$h-$d,$d,$d,90,90);$p.CloseFigure()
    return $p
}
function Layer($rect,$radius,$fill,$stroke,$width){
    $p=RoundPath $rect[0] $rect[1] $rect[2] $rect[3] $radius
    $b=New-Object Drawing.SolidBrush([Drawing.ColorTranslator]::FromHtml($fill))
    $g.FillPath($b,$p)
    if($stroke){$pen=[Drawing.Pen]::new([Drawing.ColorTranslator]::FromHtml($stroke),[single]$width);$g.DrawPath($pen,$p);$pen.Dispose()}
    $b.Dispose();$p.Dispose()
}
Layer @(20,24,1560,952) 48 '#11181d' '#69747b' 2
Layer @(28,32,1544,936) 42 '#2a3237' '#070d11' 3
Layer @(40,43,1520,914) 32 '#080e13' '#495860' 1
Layer @(52,54,1496,892) 22 '#07131b' '#1b3c50' 1
$lens=New-Object Drawing.SolidBrush([Drawing.ColorTranslator]::FromHtml('#02070a'))
$g.FillEllipse($lens,795,35,10,10)
$highlight=New-Object Drawing.SolidBrush([Drawing.ColorTranslator]::FromHtml('#24485b'))
$g.FillEllipse($highlight,798,37,3,3)
$g.FillEllipse($highlight,1517,961,4,4)
$font=New-Object Drawing.Font('Segoe UI',8,[Drawing.FontStyle]::Regular)
$g.DrawString('S I C S   /   F I E L D   T A B L E T',$font,$highlight,680,958)
$png=Join-Path $outDir 'tablet_frame_ca.png'
$bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png)
$g.Dispose();$bitmap.Dispose();$lens.Dispose();$highlight.Dispose();$font.Dispose()
$converter='C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe'
& $converter $png (Join-Path $outDir 'tablet_frame_ca.paa')
if (!(Test-Path (Join-Path $outDir 'tablet_frame_ca.paa'))) {throw 'PAA conversion did not produce a texture.'}
