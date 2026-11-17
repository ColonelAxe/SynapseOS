param([ValidatePattern('^CB[0-9]+$')][string]$Revision='CB1',[switch]$Force)
$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$baseline=Join-Path $root 'dist/@ATLAS-beta2'
$archive=Join-Path $root ('dist/ATLAS-Closed-Beta-'+$Revision+'.zip')
if((Test-Path -LiteralPath $archive) -and !$Force){throw 'Frozen kit already exists. Use a new revision; use -Force only before distributing this candidate.'}
$expected=@{
 'addons/sics_core.pbo'='C8C22876EA750DB9D747BEEAF71F592A1DF6FE29975F592FEF1F0D2ACD60C71D'
 'addons/sics_core.pbo.ATLAS_Beta_012.bisign'='7AF07B4DFCDEADFAF0C99EE046A0B99BA4BF3DA32D7B812F556A1919AF052961'
 'keys/ATLAS_Beta_012.bikey'='D248E8F91F2D025EC70670A828FCCA12472C62AFBFD6414DB417A4A23BCE8066'
 'atlas_media_x64.dll'='B2CE5E85AEA28834A3430E3990A07BBE08304D0D22E993F3165DC8B49B359FAE'
}
foreach($relative in $expected.Keys){if((Get-FileHash -LiteralPath (Join-Path $baseline $relative)).Hash -ne $expected[$relative]){throw "Validated baseline changed: $relative"}}
$sourceZip=Join-Path $root 'dist/ATLAS-0.12.0-beta.2-source.zip'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$source=[IO.Compression.ZipFile]::OpenRead($sourceZip)
try {if(@($source.Entries | Where-Object {$_.FullName -match '\.biprivatekey|(^|[/\\])(\.keys|test-profile|server-profile|\.cache)([/\\])|\.rpt$'}).Count){throw 'Private/generated files in source archive'}} finally {$source.Dispose()}
$stage=Join-Path $root ('dist/closed-beta-stage-'+$Revision+'-'+[guid]::NewGuid().ToString('N'))
$kit=Join-Path $stage ('ATLAS-Closed-Beta-'+$Revision)
New-Item -ItemType Directory -Force $kit,(Join-Path $kit '@ATLAS/addons'),(Join-Path $kit '@ATLAS/keys'),(Join-Path $kit 'MPMissions'),(Join-Path $kit 'MissionSource'),(Join-Path $kit 'Source'),(Join-Path $kit 'Tools') | Out-Null
foreach($relative in $expected.Keys){Copy-Item -LiteralPath (Join-Path $baseline $relative) -Destination (Join-Path (Join-Path $kit '@ATLAS') $relative)}
foreach($name in @('mod.cpp','LICENSE')){Copy-Item -LiteralPath (Join-Path $root $name) -Destination (Join-Path $kit '@ATLAS')}
Copy-Item -LiteralPath (Join-Path $root 'docs') -Destination (Join-Path $kit '@ATLAS') -Recurse
Copy-Item -LiteralPath (Join-Path $root 'examples/ATLAS_Beta.VR') -Destination (Join-Path $kit 'MissionSource') -Recurse
Copy-Item -LiteralPath (Join-Path $root 'examples/server-cb1.cfg.example') -Destination $kit
Copy-Item -LiteralPath (Join-Path $root 'dist/ATLAS-0.12.0-beta.2-source.zip') -Destination (Join-Path $kit 'Source')
foreach($name in @('verify-beta-kit.ps1','prepare-closed-beta.ps1')){Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination (Join-Path $kit 'Tools')}
@'
# ATLAS frozen closed beta

Core: 0.12.0-beta.2. Requires CBA_A3 and original cTab; ACE optional.
Start with [the tester/organiser guide](docs/CLOSED-BETA-START-HERE.md).
The outer kit contains the CB1 mission, verification tool and corresponding core source archive. The editable CB1 mission is under MissionSource. Never load the source archive's test addon on a live beta server.
'@ | Set-Content -LiteralPath (Join-Path $kit '@ATLAS/README.md') -Encoding utf8
@"
# ATLAS Closed Beta $Revision

1. Read [START HERE](@ATLAS/docs/CLOSED-BETA-START-HERE.md).
2. Organisers use [the session sheet](@ATLAS/docs/BETA-SESSION.md), [known limitations](@ATLAS/docs/BETA-KNOWN-ISSUES.md) and [Discord draft](@ATLAS/docs/BETA-DISCORD.md).
3. Install @ATLAS with the agreed CBA/original-cTab preset. Administrators install MPMissions/ATLAS_ClosedBeta.VR.pbo and the public key; use server-cb1.cfg.example as a reference.
4. Tools/verify-beta-kit.ps1 -KitPath <this extracted folder> verifies all checksums. No tools need to be run simply to play.

The core is the unchanged validated 0.12.0-beta.2 build. The CB1 acceptance mission is a separate revision; 681 core checks are not a multiplayer acceptance result for this mission. Source contains the corresponding core source ZIP; MissionSource contains the editable CB1 mission. Session date/server details are provided by your organiser.
"@ | Set-Content -LiteralPath (Join-Path $kit 'START-HERE.md') -Encoding utf8
$fileBank='C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/FileBank/FileBank.exe'
if(!(Test-Path -LiteralPath $fileBank)){throw 'Arma Tools FileBank is required to build the mission PBO.'}
& $fileBank '-property' 'prefix=mpmissions\ATLAS_ClosedBeta.VR' '-dst' $stage (Join-Path $kit 'MissionSource/ATLAS_Beta.VR')
if($LASTEXITCODE -ne 0){throw 'Mission packing failed'}
$mission=Join-Path $kit 'MPMissions/ATLAS_ClosedBeta.VR.pbo'
Copy-Item -LiteralPath (Join-Path $stage 'ATLAS_Beta.VR.pbo') -Destination $mission
$release=[ordered]@{
 kit=$Revision;coreVersion='0.12.0-beta.2';missionVersion=$Revision;prepared='2026-11-16';
 coreSHA256=$expected['addons/sics_core.pbo'];missionSHA256=(Get-FileHash -LiteralPath $mission).Hash;
 testedCore=[ordered]@{nativeChecks=681;dedicatedBackendChecks=20;arma='2.22.154191';cba='3.19.0.260808';ctab='2.2.2.1';ace='3.21.2.113';realClientMultiplayerAccepted=$false};
 sourceArchive='Source/ATLAS-0.12.0-beta.2-source.zip';sourceSHA256=(Get-FileHash -LiteralPath $sourceZip).Hash;missionSource='MissionSource/ATLAS_Beta.VR';
 dependencyPolicy='Original cTab + CBA required. Agree exact versions for each session; community modpack, TFAR/ACRE and JIP remain acceptance work.'
}
$release | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $kit ('RELEASE-'+$Revision+'.json')) -Encoding utf8
$hashes=@(Get-ChildItem -LiteralPath $kit -Recurse -File | Sort-Object FullName | ForEach-Object {(Get-FileHash -LiteralPath $_.FullName).Hash+'  '+$_.FullName.Substring($kit.Length+1).Replace('\','/')})
$hashes | Set-Content -LiteralPath (Join-Path $kit 'SHA256SUMS.txt') -Encoding utf8
& (Join-Path $PSScriptRoot 'verify-beta-kit.ps1') -KitPath $kit
Compress-Archive -LiteralPath $kit -DestinationPath $archive -Force
$archiveHash=(Get-FileHash -LiteralPath $archive).Hash
($archiveHash+'  '+[IO.Path]::GetFileName($archive)) | Set-Content -LiteralPath ($archive+'.sha256') -Encoding ascii
Copy-Item -LiteralPath (Join-Path $kit ('RELEASE-'+$Revision+'.json')) -Destination (Join-Path $root ('dist/ATLAS-Closed-Beta-'+$Revision+'.release.json')) -Force
Write-Output "KIT: $kit"
Write-Output "ARCHIVE: $archive"
Write-Output "SHA256: $archiveHash"
