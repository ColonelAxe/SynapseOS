param([string]$Version = '0.12.0-beta.3')
$ErrorActionPreference = 'Stop'

$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$config = Get-Content -LiteralPath (Join-Path $root 'addons/core/config.cpp') -Raw
if ($Version -notmatch '^\d+\.\d+\.\d+-beta\.\d+$') { throw 'Use a version like 0.12.0-beta.3.' }
if ($config -notmatch ('versionStr\s*=\s*"' + [regex]::Escape($Version) + '"')) { throw 'Requested version does not match the addon config.' }

$buildRoot = Join-Path $root '.hemttout/build'
$pbo = Join-Path $buildRoot 'addons/sics_core.pbo'
$signature = Join-Path $buildRoot 'addons/sics_core.pbo.ATLAS_Beta_012.bisign'
$publicKey = Join-Path $buildRoot 'keys/ATLAS_Beta_012.bikey'
$native = Join-Path $root 'native/build/atlas_media_x64.dll'
foreach ($required in @($pbo,$signature,$publicKey,$native)) {
    if (!(Test-Path -LiteralPath $required -PathType Leaf)) { throw "Missing release input: $required. Build, sign and verify the PBO first." }
}
$signatureTool = 'C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/DSSignFile/DSCheckSignatures.exe'
if (!(Test-Path -LiteralPath $signatureTool -PathType Leaf)) { throw 'Arma 3 Tools DSCheckSignatures is required to verify the candidate.' }
& $signatureTool (Join-Path $buildRoot 'addons') (Join-Path $buildRoot 'keys')
if ($LASTEXITCODE -ne 0) { throw 'The candidate PBO signature did not verify.' }

$pboText = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes($pbo))
if ($pboText -match '(?i)cTab_|ItemcTab|ItemAndroid|cTab[A-Z]') { throw 'The production PBO contains a legacy cTab identifier.' }

$candidateRoot = Join-Path $root 'dist/workshop'

$modRoot = Join-Path $candidateRoot 'SynapseOS'
# Keep exactly one previous package, after validating all new inputs.
$backupRoot=Join-Path $root 'dist/backup/SynapseOS'
if (Test-Path -LiteralPath $modRoot) {
    $expected=[IO.Path]::GetFullPath((Join-Path $root 'dist/backup/SynapseOS'))
    if ([IO.Path]::GetFullPath($backupRoot) -ne $expected) {throw 'Unexpected backup path'}
    if (Test-Path -LiteralPath $backupRoot) {Remove-Item -LiteralPath $backupRoot -Recurse -Force}
    New-Item -ItemType Directory -Force (Split-Path $backupRoot) | Out-Null
    Copy-Item -LiteralPath $modRoot -Destination $backupRoot -Recurse
}
New-Item -ItemType Directory -Force (Join-Path $modRoot 'addons'),(Join-Path $modRoot 'keys') | Out-Null
Copy-Item -Force -LiteralPath $pbo -Destination (Join-Path $modRoot 'addons/sics_core.pbo')
Copy-Item -Force -LiteralPath $signature -Destination (Join-Path $modRoot 'addons')
Copy-Item -Force -LiteralPath $publicKey -Destination (Join-Path $modRoot 'keys')
Copy-Item -Force -LiteralPath (Join-Path $root 'mod.cpp') -Destination $modRoot
Copy-Item -Force -LiteralPath (Join-Path $root 'LICENSE') -Destination $modRoot
Copy-Item -Force -LiteralPath $native -Destination $modRoot

$readme = @"
SynapseOS $Version — beta candidate, not a public release

Requirements: Arma 3 and CBA_A3. cTab is not required. ACE is optional.
This candidate is compiled and signed, but has not passed a clean Arma launch or in-game acceptance. Do not publish it or use it on a live server until the release gates in docs/PRODUCT-WORKUP.md pass.

Install for isolated testing: copy @SynapseOS to the Arma 3 directory and enable it with CBA_A3 only. The included atlas_media_x64.dll is a Windows x64 extension for Camera; normal game and server extension policy applies.
"@
Set-Content -LiteralPath (Join-Path $modRoot 'README.txt') -Value $readme -Encoding utf8

$gitCommit = (& git -C $root rev-parse --short HEAD).Trim()
$release = [ordered]@{
    product = 'SynapseOS'
    version = $Version
    branch = (& git -C $root branch --show-current).Trim()
    commit = $gitCommit
    dependencies = @('Arma 3','CBA_A3')
    cTabRequired = $false
    aceOptional = $true
    candidateOnly = $true
    cleanArmaLaunchPassed = $false
    inGameAcceptancePassed = $false
    releaseGate = 'Pending clean Arma + CBA only launch, focused in-game smoke, and multiplayer acceptance.'
}
$release | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $modRoot 'RELEASE-MANIFEST.json') -Encoding utf8

$hashRows = Get-ChildItem -LiteralPath $modRoot -Recurse -File | Sort-Object FullName | ForEach-Object {
    $relative = $_.FullName.Substring($modRoot.Length + 1).Replace('\','/')
    (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash + '  ' + $relative
}
$hashRows | Set-Content -LiteralPath (Join-Path $modRoot 'SHA256SUMS.txt') -Encoding ascii

Write-Output "Workshop upload folder: $modRoot"

