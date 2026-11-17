$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$signTools='C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/DSSignFile'
$keyRoot=Join-Path $root '.keys'
$authority='ATLAS_Beta_012'
New-Item -ItemType Directory -Force $keyRoot | Out-Null
$private=Join-Path $keyRoot ($authority+'.biprivatekey')
$public=Join-Path $keyRoot ($authority+'.bikey')
if (!(Test-Path -LiteralPath $private)) {
    if (Test-Path -LiteralPath $public){throw 'Public key exists without its private key. Restore the matching private key; do not replace the authority.'}
    Push-Location $keyRoot
    try {& (Join-Path $signTools 'DSCreateKey.exe') $authority;if($LASTEXITCODE -ne 0){throw 'Key generation failed'}} finally {Pop-Location}
}
$pbo=Join-Path $root '.hemttout/build/addons/sics_core.pbo'
& (Join-Path $signTools 'DSSignFile.exe') $private $pbo
if($LASTEXITCODE -ne 0){throw 'PBO signing failed'}
$keys=Join-Path $root '.hemttout/build/keys';New-Item -ItemType Directory -Force $keys | Out-Null
Copy-Item -LiteralPath $public -Destination $keys -Force
& (Join-Path $signTools 'DSCheckSignatures.exe') (Join-Path $root '.hemttout/build/addons') $keys
if($LASTEXITCODE -ne 0){throw 'Signature verification failed'}
Write-Output 'Beta PBO signed and verified. Keep .keys private; distribute only the .bikey and .bisign.'
