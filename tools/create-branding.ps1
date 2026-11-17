$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$assetRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../addons/core/ui'))
$previewRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../preview/assets'))
$converter='C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe'
if (!(Test-Path (Join-Path $assetRoot 'synapse_logo_ca.paa'))){Copy-Item -LiteralPath (Join-Path $assetRoot 'sics_logo_ca.paa') -Destination (Join-Path $assetRoot 'synapse_logo_ca.paa')}
$bitmap=[Drawing.Bitmap]::new(512,512);$g=[Drawing.Graphics]::FromImage($bitmap);$g.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias;$g.Clear([Drawing.Color]::Transparent)
$brush=[Drawing.SolidBrush]::new([Drawing.ColorTranslator]::FromHtml('#0c222c'));$g.FillEllipse($brush,25,25,462,462);$brush.Dispose()
$pen=[Drawing.Pen]::new([Drawing.ColorTranslator]::FromHtml('#54d8cf'),10);$g.DrawEllipse($pen,25,25,462,462);$pen.Dispose()
$points=[Drawing.PointF[]]@([Drawing.PointF]::new(256,92),[Drawing.PointF]::new(410,395),[Drawing.PointF]::new(316,351),[Drawing.PointF]::new(256,218),[Drawing.PointF]::new(196,351),[Drawing.PointF]::new(102,395))
$brush=[Drawing.SolidBrush]::new([Drawing.ColorTranslator]::FromHtml('#e4f8f5'));$g.FillPolygon($brush,$points);$brush.Dispose()
$pen=[Drawing.Pen]::new([Drawing.ColorTranslator]::FromHtml('#54d8cf'),17);$g.DrawLine($pen,198,365,314,365);$pen.Dispose()
$png=Join-Path $assetRoot 'atlas_logo_ca.png';$bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png);$g.Dispose();$bitmap.Dispose();& $converter $png (Join-Path $assetRoot 'atlas_logo_ca.paa')
Copy-Item -LiteralPath $png -Destination (Join-Path $previewRoot 'atlas-logo.png') -Force
$svg='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><circle cx="256" cy="256" r="231" fill="#0c222c" stroke="#54d8cf" stroke-width="10"/><path d="M256 92 410 395 316 351 256 218 196 351 102 395Z" fill="#e4f8f5"/><path d="M198 365H314" stroke="#54d8cf" stroke-width="17"/></svg>'
Set-Content -LiteralPath (Join-Path $previewRoot 'atlas-logo.svg') -Value $svg -Encoding UTF8
Write-Output 'Created replaceable ATLAS application icon; retained SynapseOS identity.'
