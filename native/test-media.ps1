$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$dll=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot 'build/atlas_media_x64.dll'))
$code=@"
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class AtlasMediaTest {
 [DllImport(@"$dll",CallingConvention=CallingConvention.StdCall,CharSet=CharSet.Ansi)]
 static extern int RVExtensionArgs(StringBuilder output,uint size,string function,[MarshalAs(UnmanagedType.LPArray,ArraySubType=UnmanagedType.LPStr,SizeParamIndex=4)]string[] args,uint count);
 [DllImport(@"$dll",CallingConvention=CallingConvention.StdCall,CharSet=CharSet.Ansi)]
 static extern void RVExtensionFillTextureSource(string id,ushort width,ushort height,ushort pitch,byte mip,uint format,IntPtr buffer);
 public static string Call(string f,params string[] args){var b=new StringBuilder(8192);RVExtensionArgs(b,8192,f,args,(uint)args.Length);return b.ToString();}
 public static bool Texture(string id){int pitch=2056,bytes=pitch*256;var data=new byte[bytes+32];for(int i=0;i<data.Length;i++)data[i]=0xcc;IntPtr p=Marshal.AllocHGlobal(data.Length);try {Marshal.Copy(data,0,p,data.Length);RVExtensionFillTextureSource(id,512,256,(ushort)pitch,0,5,IntPtr.Add(p,16));Marshal.Copy(p,data,0,data.Length);for(int i=0;i<16;i++)if(data[i]!=0xcc||data[data.Length-1-i]!=0xcc)return false;for(int y=0;y<256;y++)for(int x=2048;x<pitch;x++)if(data[16+y*pitch+x]!=0xcc)return false;return data[19]==255&&data[16]!=0xcc;}finally{Marshal.FreeHGlobal(p);}}
}
"@
Add-Type -TypeDefinition $code
function Assert($ok,$message){if(!$ok){throw $message};Write-Output ('PASS '+$message)}
Assert (([AtlasMediaTest]::Call('version')).StartsWith('ATLAS_MEDIA')) 'native version'
Assert (([AtlasMediaTest]::Call('begin','../bad','1')).StartsWith('ERR')) 'reject path-like identifiers'
Assert (([AtlasMediaTest]::Call('begin','P_0_bad','49')).StartsWith('ERR')) 'bound transfer chunks'
$image=[Drawing.Bitmap]::new(512,256);$g=[Drawing.Graphics]::FromImage($image);$g.Clear([Drawing.Color]::CornflowerBlue);$g.FillEllipse([Drawing.Brushes]::White,150,20,150,150);$g.Dispose()
$stream=[IO.MemoryStream]::new();$image.Save($stream,[Drawing.Imaging.ImageFormat]::Jpeg);$image.Dispose();$base64=[Convert]::ToBase64String($stream.ToArray());$stream.Dispose()
$parts=[int][Math]::Ceiling($base64.Length/2048)
Assert (([AtlasMediaTest]::Call('begin','P_0_fixture',[string]$parts)) -eq 'OK') 'begin bounded photo'
for($i=0;$i -lt $parts;$i++){$part=$base64.Substring($i*2048,[Math]::Min(2048,$base64.Length-$i*2048));Assert (([AtlasMediaTest]::Call('put','P_0_fixture',[string]$i,$part)) -eq 'OK') ('chunk '+$i)}
Assert (([AtlasMediaTest]::Call('finish','P_0_fixture')) -eq 'OK') 'decode JPEG'
Assert (([AtlasMediaTest]::Call('info','P_0_fixture')).StartsWith('OK|')) 'photo available'
Assert ([AtlasMediaTest]::Texture('P_0_fixture')) 'render pixels with intact buffer and row guards'
Assert (([AtlasMediaTest]::Call('begin','P_0_incomplete','2')) -eq 'OK') 'begin incomplete transfer'
Assert (([AtlasMediaTest]::Call('finish','P_0_incomplete')).StartsWith('ERR')) 'reject incomplete JPEG'
Assert (([AtlasMediaTest]::Call('drop','P_0_fixture')) -eq 'OK') 'release cached photo'
