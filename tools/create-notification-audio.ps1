$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Speech
$audioRoot=Join-Path $PSScriptRoot '../addons/core/audio'
New-Item -ItemType Directory -Force $audioRoot | Out-Null
$voice=New-Object System.Speech.Synthesis.SpeechSynthesizer
$voice.Rate=0
$format=New-Object System.Speech.AudioFormat.SpeechAudioFormatInfo(22050,[System.Speech.AudioFormat.AudioBitsPerSample]::Sixteen,[System.Speech.AudioFormat.AudioChannel]::Mono)
$phrases=@{message='New message received.';report='New report received.';contact='Contact report received.';order='New order received.';ack='Order acknowledged.';channel='Channel update received.';info='New information received.'}
foreach($key in $phrases.Keys){
    $voice.SetOutputToWaveFile((Join-Path $audioRoot ($key+'.wav')),$format)
    $voice.Speak($phrases[$key])
    $voice.SetOutputToNull()
}
$voice.Dispose()
$previewAudio=Join-Path $PSScriptRoot '../preview/audio'
New-Item -ItemType Directory -Force $previewAudio | Out-Null
Copy-Item -Path (Join-Path $audioRoot '*.wav') -Destination $previewAudio -Force
Get-ChildItem $audioRoot -Filter *.wav | Select-Object Name,Length
