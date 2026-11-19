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

$candidateRoot = Join-Path $root ('dist/release-candidate/' + $Version)
if (Test-Path -LiteralPath $candidateRoot) { throw "Candidate folder already exists: $candidateRoot. Use a new version to preserve prior artifacts." }
$modRoot = Join-Path $candidateRoot '@SynapseOS'
New-Item -ItemType Directory -Force (Join-Path $modRoot 'addons'),(Join-Path $modRoot 'keys') | Out-Null
Copy-Item -LiteralPath $pbo -Destination (Join-Path $modRoot 'addons/sics_core.pbo')
Copy-Item -LiteralPath $signature -Destination (Join-Path $modRoot 'addons')
Copy-Item -LiteralPath $publicKey -Destination (Join-Path $modRoot 'keys')
Copy-Item -LiteralPath (Join-Path $root 'mod.cpp') -Destination $modRoot
Copy-Item -LiteralPath (Join-Path $root 'LICENSE') -Destination $modRoot
Copy-Item -LiteralPath $native -Destination $modRoot

$readme = @"
SynapseOS $Version — beta candidate, not a public release

Requirements: Arma 3 and CBA_A3. cTab is not required. ACE is optional.
This candidate is compiled and signed, but has not passed a clean Arma launch or in-game acceptance. Do not publish it or use it on a live server until the release gates in docs/PRODUCT-WORKUP.md pass.

Install for isolated testing: copy @SynapseOS to the Arma 3 directory and enable it with CBA_A3 only. The included atlas_media_x64.dll is a Windows x64 extension for Camera; normal game and server extension policy applies.
"@
Set-Content -LiteralPath (Join-Path $modRoot 'README.txt') -Value $readme -Encoding utf8

$sourceArchive = Join-Path $candidateRoot ('SynapseOS-' + $Version + '-source.zip')
$sourceStage = Join-Path $env:TEMP ('SynapseOS-source-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force $sourceStage | Out-Null
foreach ($relative in (& git -C $root ls-files)) {
    $sourceFile = Join-Path $root $relative
    if (!(Test-Path -LiteralPath $sourceFile -PathType Leaf)) { continue }
    $destination = Join-Path $sourceStage $relative
    New-Item -ItemType Directory -Force (Split-Path -Parent $destination) | Out-Null
    Copy-Item -LiteralPath $sourceFile -Destination $destination
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($sourceStage,$sourceArchive,[IO.Compression.CompressionLevel]::Optimal,$false)
$sourceHash = (Get-FileHash -LiteralPath $sourceArchive -Algorithm SHA256).Hash
Set-Content -LiteralPath ($sourceArchive + '.sha256') -Value ($sourceHash + '  ' + [IO.Path]::GetFileName($sourceArchive)) -Encoding ascii
$tempPrefix = [IO.Path]::GetFullPath($env:TEMP).TrimEnd('\') + '\'
$sourcePath = [IO.Path]::GetFullPath($sourceStage)
if (!$sourcePath.StartsWith($tempPrefix,[StringComparison]::OrdinalIgnoreCase)) { throw 'Refusing to clean a source staging folder outside the system temporary directory.' }
Remove-Item -LiteralPath $sourcePath -Recurse -Force

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
    sourceArchive = [IO.Path]::GetFileName($sourceArchive)
    sourceArchiveSHA256 = $sourceHash
}
$release | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $modRoot 'RELEASE-MANIFEST.json') -Encoding utf8

$hashRows = Get-ChildItem -LiteralPath $modRoot -Recurse -File | Sort-Object FullName | ForEach-Object {
    $relative = $_.FullName.Substring($modRoot.Length + 1).Replace('\','/')
    (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash + '  ' + $relative
}
$hashRows | Set-Content -LiteralPath (Join-Path $modRoot 'SHA256SUMS.txt') -Encoding ascii

$archive = Join-Path $candidateRoot ('SynapseOS-' + $Version + '-candidate.zip')
Compress-Archive -LiteralPath $modRoot -DestinationPath $archive
$archiveHash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash
Set-Content -LiteralPath ($archive + '.sha256') -Value ($archiveHash + '  ' + [IO.Path]::GetFileName($archive)) -Encoding ascii
Write-Output "Candidate folder: $modRoot"
Write-Output "Candidate archive: $archive"
Write-Output "Archive SHA256: $archiveHash"
