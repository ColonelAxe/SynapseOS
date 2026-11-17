$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$zig=Join-Path $root 'tools/.cache/zig-x86_64-windows-0.15.2/zig.exe'
if (!(Test-Path -LiteralPath $zig)){throw 'Run tools/bootstrap-native.ps1 first'}
$out=Join-Path $root 'native/build';New-Item -ItemType Directory -Force $out | Out-Null
& $zig c++ -std=c++17 -O2 -shared -target x86_64-windows-gnu (Join-Path $root 'native/atlas_media.cpp') -o (Join-Path $out 'atlas_media_x64.dll') -lgdiplus -lole32 -lcrypt32 -luuid -ld3d11 -lshell32
if($LASTEXITCODE -ne 0){throw 'ATLAS native extension compilation failed'}
Get-FileHash -LiteralPath (Join-Path $out 'atlas_media_x64.dll') -Algorithm SHA256
