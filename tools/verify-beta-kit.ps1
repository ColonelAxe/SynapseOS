param([Parameter(Mandatory=$true)][string]$KitPath)
$ErrorActionPreference='Stop'
$kit=(Resolve-Path -LiteralPath $KitPath).Path
$prefix=$kit.TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar
$manifest=Join-Path $kit 'SHA256SUMS.txt'
if(!(Test-Path -LiteralPath $manifest)){throw 'Missing SHA256SUMS.txt'}
$seen=New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach($line in Get-Content -LiteralPath $manifest){
    if($line -notmatch '^([A-Fa-f0-9]{64})  (.+)$'){throw 'Malformed checksum manifest'}
    $expected=$Matches[1];$relative=$Matches[2]
    if([IO.Path]::IsPathRooted($relative) -or $relative -match '[:\x00]'){throw 'Invalid manifest path'}
    $file=[IO.Path]::GetFullPath((Join-Path $kit $relative))
    if(!$file.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase) -or !$seen.Add($file)){throw 'Duplicate or out-of-kit manifest path'}
    if(!(Test-Path -LiteralPath $file -PathType Leaf)){throw "Missing: $relative"}
    if((Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash -ne $expected){throw "Checksum mismatch: $relative"}
}
$files=@(Get-ChildItem -LiteralPath $kit -Recurse -File | Where-Object {$_.FullName -ne $manifest})
if($files.Count -ne $seen.Count -or @($files | Where-Object {!$seen.Contains($_.FullName)}).Count){throw 'Kit contains unlisted files'}
$runtime=Join-Path $kit '@ATLAS/addons/sics_core.pbo'
if((Get-FileHash -LiteralPath $runtime).Hash -ne 'C8C22876EA750DB9D747BEEAF71F592A1DF6FE29975F592FEF1F0D2ACD60C71D'){throw 'Core differs from the validated beta 2 baseline'}
if(@(Get-ChildItem -LiteralPath (Join-Path $kit '@ATLAS/addons') -Filter '*.pbo').Count -ne 1){throw 'Unexpected runtime addon, possibly a test harness'}
if(@($files | Where-Object {$_.Name -match '\.biprivatekey$|\.rpt$'}).Count){throw 'Private key or runtime log in kit'}
Write-Output "PASS: $($seen.Count) checksummed files; core matches the validated beta 2 baseline."
Write-Output 'Checksums detect mismatched files; server signature checks remain required. Source ZIP contains test source only; do not load it on the beta server.'
