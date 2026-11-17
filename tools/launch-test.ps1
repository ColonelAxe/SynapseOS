param([string]$ModFolder='@ATLAS-test',[switch]$Restart,[switch]$ACE)
$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$gameRoot='C:\Program Files (x86)\Steam\steamapps\common\Arma 3'
$running=Get-Process arma3_x64 -ErrorAction SilentlyContinue | Where-Object {$_.Path -eq (Join-Path $gameRoot 'arma3_x64.exe')}
if ($running -and !$Restart) {throw 'Arma is already running. Use -Restart only for the local test instance.'}
foreach($p in $running){Stop-Process -Id $p.Id;$p.WaitForExit()}
$target=Join-Path $root ('dist/'+$ModFolder)
New-Item -ItemType Directory -Force (Join-Path $target 'addons') | Out-Null
Copy-Item -LiteralPath (Join-Path $root '.hemttout/build/addons/sics_core.pbo') -Destination (Join-Path $target 'addons/sics_core.pbo') -Force
Copy-Item -LiteralPath (Join-Path $root 'mod.cpp') -Destination $target -Force
if (Test-Path -LiteralPath (Join-Path $root 'native/build/atlas_media_x64.dll')) {Copy-Item -LiteralPath (Join-Path $root 'native/build/atlas_media_x64.dll') -Destination $target -Force}
$mods='-mod="'+$gameRoot+'\!Workshop\@CBA_A3;'+$gameRoot+'\!Workshop\@cTab;'+$target+';'+$root+'\tests\runtime\.hemttout\build"'
if ($ACE) {$mods=$mods.TrimEnd('"')+';'+$gameRoot+'\!Workshop\@ace"'}
$profiles='-profiles="'+$root+'\test-profile"'
$init="-init=playMission['','\x\sics_test\addons\main\SICS_Runtime.VR',true]"
Start-Process -FilePath (Join-Path $gameRoot 'arma3_x64.exe') -WorkingDirectory $gameRoot -ArgumentList @('-window','-noPause','-noSplash','-skipIntro','-showScriptErrors','-world=empty',$profiles,$mods,$init)
