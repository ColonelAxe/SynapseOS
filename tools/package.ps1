param([string]$InstallFolder = '@ATLAS-beta2',[string]$Version='0.12.0-beta.2')
$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$buildPbo = Join-Path $projectRoot '.hemttout/build/addons/sics_core.pbo'
if ($Version -notmatch '^\d+\.\d+\.\d+(-[A-Za-z0-9.]+)?$' -or $InstallFolder -notmatch '^@[A-Za-z0-9_.-]+$'){throw 'Invalid package name'}
if (!(Test-Path -LiteralPath $buildPbo)) { throw 'Run hemtt build --no-bin before packaging.' }
$modRoot = Join-Path (Join-Path $projectRoot 'dist') $InstallFolder
New-Item -ItemType Directory -Force (Join-Path $modRoot 'addons') | Out-Null
$installedPbo = Join-Path $modRoot 'addons/sics_core.pbo'
$samePbo = (Test-Path -LiteralPath $installedPbo) -and ((Get-FileHash -LiteralPath $installedPbo).Hash -eq (Get-FileHash -LiteralPath $buildPbo).Hash)
if (!$samePbo) { Copy-Item -LiteralPath $buildPbo -Destination $installedPbo -Force }
$signatures=@(Get-ChildItem -LiteralPath (Split-Path $buildPbo) -Filter '*.bisign')
$publicKeys=@(Get-ChildItem -LiteralPath (Join-Path $projectRoot '.hemttout/build/keys') -Filter '*.bikey' -ErrorAction SilentlyContinue)
if ($signatures.Count -eq 0 -or $publicKeys.Count -eq 0){throw 'Run tools/sign-beta.ps1 after the final build before packaging.'}
New-Item -ItemType Directory -Force (Join-Path $modRoot 'keys') | Out-Null
$signatures | Copy-Item -Destination (Join-Path $modRoot 'addons') -Force
$publicKeys | Copy-Item -Destination (Join-Path $modRoot 'keys') -Force
foreach ($name in @('mod.cpp','README.md','LICENSE')) {
    $source=Join-Path $projectRoot $name
    $destination=Join-Path $modRoot $name
    $sameFile=(Test-Path -LiteralPath $destination) -and ((Get-FileHash -LiteralPath $source).Hash -eq (Get-FileHash -LiteralPath $destination).Hash)
    if (!$sameFile) { Copy-Item -LiteralPath $source -Destination $destination -Force }
}
foreach ($name in @('docs','examples','preview')) { Copy-Item -LiteralPath (Join-Path $projectRoot $name) -Destination $modRoot -Recurse -Force }
$native=Join-Path $projectRoot 'native/build/atlas_media_x64.dll'
if (!(Test-Path -LiteralPath $native)){throw 'Run tools/build-native.ps1 before packaging photo support'}
Copy-Item -LiteralPath $native -Destination $modRoot -Force
$archive = Join-Path $projectRoot ('dist/ATLAS-'+$Version+'.zip')
# Archive from a fresh staging copy; Arma locks its loaded PBO against the
# exclusive file open used by Compress-Archive.
$packageRoot = Join-Path $projectRoot ('dist/package-stage-'+$Version+'/@ATLAS')
New-Item -ItemType Directory -Force (Join-Path $packageRoot 'addons') | Out-Null
Copy-Item -LiteralPath $buildPbo -Destination (Join-Path $packageRoot 'addons/sics_core.pbo') -Force
Copy-Item -LiteralPath $native -Destination $packageRoot -Force
New-Item -ItemType Directory -Force (Join-Path $packageRoot 'keys') | Out-Null
$signatures | Copy-Item -Destination (Join-Path $packageRoot 'addons') -Force
$publicKeys | Copy-Item -Destination (Join-Path $packageRoot 'keys') -Force
foreach ($name in @('mod.cpp','README.md','LICENSE')) { Copy-Item -LiteralPath (Join-Path $projectRoot $name) -Destination $packageRoot -Force }
foreach ($name in @('docs','examples','preview')) { Copy-Item -LiteralPath (Join-Path $projectRoot $name) -Destination $packageRoot -Recurse -Force }
$manifest=@("ATLAS $Version",'SHA256 / runtime binaries')
foreach($file in @(Get-ChildItem -LiteralPath (Join-Path $packageRoot 'addons') -File)+@(Get-ChildItem -LiteralPath (Join-Path $packageRoot 'keys') -File)+@(Get-Item -LiteralPath (Join-Path $packageRoot 'atlas_media_x64.dll'))){$relative=$file.FullName.Substring($packageRoot.Length+1);$manifest+=((Get-FileHash -LiteralPath $file.FullName).Hash+'  '+$relative)}
$manifest | Set-Content -LiteralPath (Join-Path $packageRoot 'SHA256SUMS.txt') -Encoding utf8
Copy-Item -LiteralPath (Join-Path $packageRoot 'SHA256SUMS.txt') -Destination $modRoot -Force
Compress-Archive -LiteralPath $packageRoot -DestinationPath $archive -Force
$sourceStage=Join-Path $projectRoot ('dist/source-'+$Version)
New-Item -ItemType Directory -Force $sourceStage,(Join-Path $sourceStage 'tools'),(Join-Path $sourceStage 'native') | Out-Null
foreach($name in @('.hemtt','addons','examples','preview','docs','README.md','LICENSE','mod.cpp','.gitignore')){Copy-Item -LiteralPath (Join-Path $projectRoot $name) -Destination $sourceStage -Recurse -Force}
Get-ChildItem -LiteralPath (Join-Path $projectRoot 'tools') -File | Copy-Item -Destination (Join-Path $sourceStage 'tools') -Force
Get-ChildItem -LiteralPath (Join-Path $projectRoot 'native') -File | Copy-Item -Destination (Join-Path $sourceStage 'native') -Force
New-Item -ItemType Directory -Force (Join-Path $sourceStage 'tests/runtime') | Out-Null
foreach($name in @('.hemtt','addons')){Copy-Item -LiteralPath (Join-Path $projectRoot ('tests/runtime/'+$name)) -Destination (Join-Path $sourceStage 'tests/runtime') -Recurse -Force}
Compress-Archive -LiteralPath (Get-ChildItem -LiteralPath $sourceStage | Select-Object -ExpandProperty FullName) -DestinationPath (Join-Path $projectRoot ('dist/ATLAS-'+$Version+'-source.zip')) -Force
Get-FileHash -LiteralPath (Join-Path $modRoot 'addons/sics_core.pbo') -Algorithm SHA256 | Format-List
Write-Output "Packaged $archive"
