$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'create-tablet-frame.ps1')
foreach($state in @('normal','over','pressed','disabled')) {
    $bitmap=New-Object Drawing.Bitmap(512,128)
    $g=[Drawing.Graphics]::FromImage($bitmap)
    $g.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([Drawing.Color]::Transparent)
    $shade=switch($state){'over'{'#dedede'} 'pressed'{'#777777'} 'disabled'{'#555555'} default{'#a8a8a8'}}
    Layer @(2,2,508,124) 18 $shade '#f4f4f4' 2
    $png=Join-Path $outDir ('button_'+$state+'_ca.png')
    $bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose();$bitmap.Dispose()
    & $converter $png (Join-Path $outDir ('button_'+$state+'_ca.paa'))
}
foreach($page in @('tactical','c2','messages')) {
    $bitmap=New-Object Drawing.Bitmap(2048,1024)
    $g=[Drawing.Graphics]::FromImage($bitmap)
    $g.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([Drawing.Color]::Transparent);$g.ScaleTransform(1.28,1.024)
    Layer @(67,128,1466,73) 10 '#0b1823' '#203746' 1
    $cards=switch($page){
        'c2' {@(@(67,210,410,623),@(483,210,634,623),@(1123,210,410,623))}
        'messages' {@(@(67,210,362,623),@(435,210,698,692),@(1139,210,394,623))}
        default {@(@(67,210,253,623),@(323,210,850,623),@(1179,210,354,623))}
    }
    foreach($card in $cards){Layer $card 10 '#0c1a25' '#2a4253' 1.2}
    $png=Join-Path $outDir ('surface_'+$page+'_ca.png')
    $bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose();$bitmap.Dispose()
    & $converter $png (Join-Path $outDir ('surface_'+$page+'_ca.paa'))
}

if (Test-Path (Join-Path $outDir 'tablet_photoreal_source.png')) { . (Join-Path $PSScriptRoot 'import-device-textures.ps1') }
