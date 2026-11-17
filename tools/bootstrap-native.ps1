$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$cache=Join-Path $root 'tools/.cache'
$compiler=Join-Path $cache 'zig-x86_64-windows-0.15.2/zig.exe'
if (Test-Path -LiteralPath $compiler) {Write-Output $compiler;exit}
New-Item -ItemType Directory -Force $cache | Out-Null
$index=Invoke-RestMethod -Uri 'https://ziglang.org/download/index.json'
$release=$index.'0.15.2'.'x86_64-windows'
$archive=Join-Path $cache 'zig-0.15.2.zip'
Invoke-WebRequest -Uri $release.tarball -OutFile $archive
if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ne $release.shasum) {throw 'Compiler archive checksum mismatch'}
Expand-Archive -LiteralPath $archive -DestinationPath $cache -Force
Write-Output $compiler
