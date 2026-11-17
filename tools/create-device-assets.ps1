$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$assetRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../addons/core/ui'))
$previewRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../preview/assets'))
New-Item -ItemType Directory -Force $assetRoot,$previewRoot | Out-Null
$converter='C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe'
function Color($hex){[Drawing.ColorTranslator]::FromHtml($hex)}
function Round($x,$y,$w,$h,$r){
    $p=New-Object Drawing.Drawing2D.GraphicsPath;$d=[single]($r*2)
    $p.AddArc([single]$x,[single]$y,$d,$d,180,90);$p.AddArc([single]($x+$w-$d),[single]$y,$d,$d,270,90)
    $p.AddArc([single]($x+$w-$d),[single]($y+$h-$d),$d,$d,0,90);$p.AddArc([single]$x,[single]($y+$h-$d),$d,$d,90,90);$p.CloseFigure();$p
}
function Panel($x,$y,$w,$h,$r,$fill,$stroke='#070b0e',$thickness=2){
    $p=Round $x $y $w $h $r;$b=[Drawing.SolidBrush]::new((Color $fill));$g.FillPath($b,$p);$b.Dispose()
    $pen=[Drawing.Pen]::new((Color $stroke),[single]$thickness);$g.DrawPath($pen,$p);$pen.Dispose();$p.Dispose()
}
function Screw($x,$y,$size){
    $b=[Drawing.SolidBrush]::new((Color '#080b0c'));$g.FillEllipse($b,[single]($x-$size/2),[single]($y-$size/2),[single]$size,[single]$size);$b.Dispose()
    $pen=[Drawing.Pen]::new((Color '#68706b'),[single]2);$g.DrawEllipse($pen,[single]($x-$size/3),[single]($y-$size/3),[single]($size*2/3),[single]($size*2/3));$g.DrawLine($pen,[single]($x-$size/6),[single]$y,[single]($x+$size/6),[single]$y);$pen.Dispose()
}
foreach($kind in @('tablet','phone','portable','vehicle')){
    $portrait=$kind -in @('phone','portable');$logicalW=if($portrait){if($kind-eq'phone'){900}else{1100}}else{1600};$logicalH=if($portrait){1600}else{1000}
    $bitmap=[Drawing.Bitmap]::new($(if($portrait){1024}else{2048}),$(if($portrait){2048}else{1024}))
    $g=[Drawing.Graphics]::FromImage($bitmap);$g.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias;$g.Clear([Drawing.Color]::Transparent)
    $g.ScaleTransform($bitmap.Width/$logicalW,$bitmap.Height/$logicalH)
    $w=$logicalW;$h=$logicalH
    # Floating rubber edge, metal subframe, bevel and recessed glass.
    Panel 8 8 ($w-16) ($h-16) 62 '#101414' '#030607' 6
    Panel 18 18 ($w-36) ($h-36) 50 '#303a36' '#758077' 2
    Panel 32 30 ($w-64) ($h-60) 37 '#18201f' '#070b0d' 4
    Panel ($w*.038) ($h*.047) ($w*.924) ($h*.89) 25 '#050c11' '#5b6b69' 2
    Panel ($w*.045) ($h*.055) ($w*.91) ($h*.875) 19 '#07131b' '#152d38' 2
    # Reinforced corner bumpers and recessed fasteners.
    foreach($cx in @(0,1)){foreach($cy in @(0,1)){
        $x=if($cx){$w-92}else{0};$y=if($cy){$h-92}else{0}
        Panel $x $y 92 92 23 '#222b25' '#0a100d' 4
        Screw ($x+46) ($y+46) 26
    }}
    # Moulded side grip ribs live outside the active glass.
    $pen=[Drawing.Pen]::new((Color '#546159'),[single]3)
    foreach($side in @(19,($w-19))){for($i=0;$i-lt 9;$i++){$y=$h*.31+$i*($h*.035);$g.DrawLine($pen,[single]($side-5),[single]$y,[single]($side+5),[single]($y+12))}}
    $pen.Dispose()
    $brush=[Drawing.SolidBrush]::new((Color '#030708'));$g.FillEllipse($brush,[single]($w*.5-10),[single]($h*.026),20,20);$brush.Dispose()
    $brush=[Drawing.SolidBrush]::new((Color '#245563'));$g.FillEllipse($brush,[single]($w*.5-3),[single]($h*.026+4),6,6);$brush.Dispose()
    # Physical hotkeys, protected power key, status lamp and engraved identity.
    $buttonY=$h*.951;$bw=if($portrait){$w*.105}else{76}
    for($i=0;$i-lt 3;$i++){Panel ($w*.19+$i*($bw+9)) $buttonY $bw ($h*.024) 6 '#171f20' '#53615c' 1}
    Panel ($w*.79) $buttonY ($w*.075) ($h*.024) 6 '#171f20' '#53615c' 1
    $font=[Drawing.Font]::new('Segoe UI',$(if($portrait){18}else{15}),[Drawing.FontStyle]::Bold)
    $brush=[Drawing.SolidBrush]::new((Color '#9cac9f'));$g.DrawString('S I C S',$font,$brush,[single]($w*.47),[single]($h*.95));$brush.Dispose();$font.Dispose()
    $brush=[Drawing.SolidBrush]::new((Color '#37dba6'));$g.FillEllipse($brush,[single]($w*.89),[single]($h*.958),7,7);$brush.Dispose()
    if($kind-eq'vehicle'){
        foreach($x in @(($w*.12),($w*.87))){Panel $x 1 24 42 4 '#4c5552' '#070b0c' 2;Panel $x ($h-43) 24 42 4 '#4c5552' '#070b0c' 2}
    }
    $png=Join-Path $assetRoot ($kind+'_frame_ca.png');$bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png);$g.Dispose();$bitmap.Dispose()
    & $converter $png (Join-Path $assetRoot ($kind+'_frame_ca.paa'))
    Copy-Item -LiteralPath $png -Destination (Join-Path $previewRoot ($kind+'-frame.png')) -Force
}
# Original SICS insignia: a shield, split S and four navigation bearings.
$svg=@'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256"><path d="M128 12 222 62v102l-94 80-94-80V62Z" fill="#091b26" stroke="#52d7d0" stroke-width="9"/><path d="M178 70H91L70 94l18 35h67l12 20-17 20H78v25h88l31-40-26-49H106l-9-13h81Z" fill="#e9f6f7"/><path d="m128 0 8 17h-16Zm128 128-17 8v-16ZM128 256l-8-17h16ZM0 128l17-8v16Z" fill="#52d7d0"/></svg>
'@
Set-Content -LiteralPath (Join-Path $previewRoot 'sics-logo.svg') -Value $svg -Encoding UTF8
$bitmap=[Drawing.Bitmap]::new(512,512);$g=[Drawing.Graphics]::FromImage($bitmap);$g.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias;$g.Clear([Drawing.Color]::Transparent);$g.ScaleTransform(2,2)
$shield=[Drawing.PointF[]]@([Drawing.PointF]::new(128,12),[Drawing.PointF]::new(222,62),[Drawing.PointF]::new(222,164),[Drawing.PointF]::new(128,244),[Drawing.PointF]::new(34,164),[Drawing.PointF]::new(34,62))
$b=[Drawing.SolidBrush]::new((Color '#091b26'));$g.FillPolygon($b,$shield);$b.Dispose();$pen=[Drawing.Pen]::new((Color '#52d7d0'),9);$g.DrawPolygon($pen,$shield);$pen.Dispose()
$points=[Drawing.PointF[]]@([Drawing.PointF]::new(178,70),[Drawing.PointF]::new(91,70),[Drawing.PointF]::new(70,94),[Drawing.PointF]::new(88,129),[Drawing.PointF]::new(155,129),[Drawing.PointF]::new(167,149),[Drawing.PointF]::new(150,169),[Drawing.PointF]::new(78,169),[Drawing.PointF]::new(78,194),[Drawing.PointF]::new(166,194),[Drawing.PointF]::new(197,154),[Drawing.PointF]::new(171,105),[Drawing.PointF]::new(106,105),[Drawing.PointF]::new(97,92),[Drawing.PointF]::new(178,92))
$b=[Drawing.SolidBrush]::new((Color '#e9f6f7'));$g.FillPolygon($b,$points);$b.Dispose()
$png=Join-Path $assetRoot 'sics_logo_ca.png';$bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png);$g.Dispose();$bitmap.Dispose();& $converter $png (Join-Path $assetRoot 'sics_logo_ca.paa')
Write-Output 'Generated SICS identity and four rugged device frames.'
