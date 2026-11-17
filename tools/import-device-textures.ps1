$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$assetRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../addons/core/ui'))
$previewRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../preview/assets'))
$generated='C:/Users/stijn/.codex/generated_images/01a1ca1a-1451-7483-91cc-c574c48279d3'
$sources=@{tablet='exec-7b89008d-cd9f-4288-8547-a9bbe0a395ee.png';phone='exec-fa731aa9-8bca-4344-8381-2f758be45361.png'}
$converter='C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/TexView2/Pal2PacE.exe'
foreach($kind in $sources.Keys){
    $source=Join-Path $assetRoot ($kind+'_photoreal_source.png')
    if (!(Test-Path -LiteralPath $source)){Copy-Item -LiteralPath (Join-Path $generated $sources[$kind]) -Destination $source}
    $sourceImage=[Drawing.Image]::FromFile($source);$bitmap=[Drawing.Bitmap]::new(2048,1024)
    $g=[Drawing.Graphics]::FromImage($bitmap);$g.Clear([Drawing.Color]::Transparent);$g.InterpolationMode=[Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($sourceImage,0,0,2048,1024);$sourceImage.Dispose();$g.Dispose()
    $png=Join-Path $assetRoot ($kind+'_frame_ca.png');$bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png);$bitmap.Dispose()
    & $converter $png (Join-Path $assetRoot ($kind+'_frame_ca.paa'))
    Copy-Item -LiteralPath $png -Destination (Join-Path $previewRoot ($kind+'-frame.png')) -Force
}
foreach($pair in @(@('tablet','vehicle'),@('phone','portable'))){
    foreach($extension in @('png','paa')){Copy-Item -LiteralPath (Join-Path $assetRoot ($pair[0]+'_frame_ca.'+$extension)) -Destination (Join-Path $assetRoot ($pair[1]+'_frame_ca.'+$extension)) -Force}
    Copy-Item -LiteralPath (Join-Path $previewRoot ($pair[0]+'-frame.png')) -Destination (Join-Path $previewRoot ($pair[1]+'-frame.png')) -Force
}
Write-Output 'Imported photoreal rugged tablet and landscape JTAC handset textures.'

