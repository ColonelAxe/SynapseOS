$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$converter='C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe'
function RoundPath {
    $p=[Drawing.Drawing2D.GraphicsPath]::new()
    foreach($arc in @(@(12,12,180),@(180,12,270),@(180,180,0),@(12,180,90))){$p.AddArc($arc[0],$arc[1],64,64,$arc[2],90)}
    $p.CloseFigure();return ,$p
}
foreach($kind in @('tile','atlas','settings','camera','notifications','operations')){
    foreach($variant in @('glyph','app')){
        if($kind -eq 'tile' -and $variant -eq 'glyph'){continue}
        $b=[Drawing.Bitmap]::new(256,256);$g=[Drawing.Graphics]::FromImage($b);$g.SmoothingMode='AntiAlias'
        if($variant -eq 'app'){
            $path=RoundPath;$brush=[Drawing.Drawing2D.LinearGradientBrush]::new([Drawing.Point]::new(0,0),[Drawing.Point]::new(256,256),[Drawing.Color]::FromArgb(255,2,30,43),[Drawing.Color]::FromArgb(255,0,11,18))
            $g.FillPath($brush,$path);$pen=[Drawing.Pen]::new([Drawing.Color]::FromArgb(255,0,217,245),2);$g.DrawPath($pen,$path);$pen.Dispose();$brush.Dispose();$path.Dispose()
        }
        $white=[Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255,224,243,250));$cyan=[Drawing.Pen]::new([Drawing.Color]::FromArgb(255,27,216,240),7)
        if($kind -eq 'atlas'){
            $g.TranslateTransform(128,128);$g.RotateTransform(-21);$g.DrawArc($cyan,-91,-24,182,48,155,230);$g.ResetTransform()
            $p=[Drawing.PointF[]]@([Drawing.PointF]::new(62,194),[Drawing.PointF]::new(125,62),[Drawing.PointF]::new(140,62),[Drawing.PointF]::new(197,190),[Drawing.PointF]::new(168,177),[Drawing.PointF]::new(130,98),[Drawing.PointF]::new(99,159),[Drawing.PointF]::new(147,139),[Drawing.PointF]::new(155,157))
            $g.FillPolygon($white,$p);$g.TranslateTransform(128,128);$g.RotateTransform(-21);$g.DrawArc($cyan,-91,-24,182,48,0,155);$g.ResetTransform()
        }
        if($kind -eq 'settings'){
            $points=for($i=0;$i -lt 32;$i++){$r=if(($i%4) -in @(1,2)){66}else{51};$a=$i*[Math]::PI/16;[Drawing.PointF]::new(128+$r*[Math]::Cos($a),128+$r*[Math]::Sin($a))}
            $gear=[Drawing.Drawing2D.GraphicsPath]::new();$gear.FillMode='Alternate';$gear.AddPolygon([Drawing.PointF[]]$points);$gear.AddEllipse(104,104,48,48);$g.FillPath($white,$gear);$gear.Dispose()
        }
        if($kind -eq 'camera'){
            $pen=[Drawing.Pen]::new([Drawing.Color]::FromArgb(255,224,243,250),9);$g.DrawRectangle($pen,57,94,142,100);$g.DrawLines($pen,[Drawing.Point[]]@([Drawing.Point]::new(84,94),[Drawing.Point]::new(97,70),[Drawing.Point]::new(153,70),[Drawing.Point]::new(166,94)));$g.DrawEllipse($cyan,98,111,61,61);$g.FillEllipse($white,176,106,10,10);$pen.Dispose()
        }
        if($kind -eq 'notifications'){
            $pen=[Drawing.Pen]::new([Drawing.Color]::FromArgb(255,224,243,250),9)
            $g.DrawArc($pen,85,66,86,93,180,180);$g.DrawLines($pen,[Drawing.Point[]]@([Drawing.Point]::new(85,110),[Drawing.Point]::new(82,153),[Drawing.Point]::new(68,176),[Drawing.Point]::new(188,176),[Drawing.Point]::new(174,153),[Drawing.Point]::new(171,110)))
            $g.DrawArc($cyan,112,179,32,27,0,180);$g.FillEllipse($white,120,49,16,16);$pen.Dispose()
        }
        if($kind -eq 'operations'){
            $g.DrawLines($cyan,[Drawing.Point[]]@([Drawing.Point]::new(65,175),[Drawing.Point]::new(115,92),[Drawing.Point]::new(186,133)))
            foreach($p in @(@(65,175),@(115,92),@(186,133))){$g.FillEllipse($white,$p[0]-13,$p[1]-13,26,26)}
            $pen=[Drawing.Pen]::new([Drawing.Color]::FromArgb(255,224,243,250),6);$g.DrawRectangle($pen,49,56,156,144);$pen.Dispose()
        }
        $white.Dispose();$cyan.Dispose();$g.Dispose()
        $name=if($kind -eq 'tile'){'app_tile_ca'}else{$kind+'_'+$variant+'_ca'}
        $png=Join-Path $root ('addons/core/ui/'+$name+'.png');$b.Save($png,[Drawing.Imaging.ImageFormat]::Png);$b.Dispose()
        & $converter $png ($png -replace '\.png$','.paa')
        if($LASTEXITCODE -ne 0){throw 'App icon conversion failed'}
        $preview=if($kind -eq 'tile'){'app-tile.png'}else{$kind+'-'+$variant+'.png'}
        Copy-Item -LiteralPath $png -Destination (Join-Path $root ('preview/assets/'+$preview)) -Force
    }
}
