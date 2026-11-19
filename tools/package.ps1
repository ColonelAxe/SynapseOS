param([string]$Version = '0.12.0-beta.3')
$ErrorActionPreference = 'Stop'
$candidateScript = Join-Path $PSScriptRoot 'package-release-candidate.ps1'
& $candidateScript -Version $Version
