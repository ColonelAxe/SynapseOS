// ATLAS media: named game render targets and generated ATLAS screenshot PNGs only.
// No desktop capture, arbitrary paths, sockets or process injection. SQF owns transport.
#define NOMINMAX
#include <windows.h>
#include <d3d11.h>
#include <gdiplus.h>
#include <wincrypt.h>
#include <shlobj.h>
#include <shellapi.h>
#include <filesystem>
#include <algorithm>
#include <cstdint>
#include <cstring>
#include <map>
#include <mutex>
#include <string>
#include <vector>
#include <memory>
using namespace Gdiplus;
namespace {
constexpr int W=512,H=256,CHUNK=2048,MAXPARTS=48;
struct Photo {std::vector<uint8_t> jpeg,pixels;uint64_t age=0;};
struct Transfer {std::vector<std::string> parts;uint64_t started;};
std::mutex gate;std::map<std::string,Photo> photos;std::map<std::string,Transfer> incoming;
std::map<std::string,uint64_t> pending;uint64_t sequence=0;ULONG_PTR gdip=0;std::once_flag gdipOnce;std::string diagnostics="idle";
bool validId(const std::string& s){return !s.empty()&&s.size()<=64&&std::all_of(s.begin(),s.end(),[](unsigned char c){return (c>='A'&&c<='Z')||(c>='a'&&c<='z')||(c>='0'&&c<='9')||c=='_';});}
bool valid64(const std::string& s){return s.size()<=CHUNK&&s.size()%4==0&&std::all_of(s.begin(),s.end(),[](unsigned char c){return (c>='A'&&c<='Z')||(c>='a'&&c<='z')||(c>='0'&&c<='9')||c=='+'||c=='/'||c=='=';});}
std::string arg(const char* s){std::string v=s?s:"";if(v.size()>=2&&v.front()=='"'&&v.back()=='"')v=v.substr(1,v.size()-2);return v;}
int number(const std::string& s){if(s.empty()||s.size()>6||s.find_first_not_of("0123456789")!=std::string::npos)return -1;return std::stoi(s);}
void out(char* buffer,unsigned size,const std::string& value){if(!size)return;size_t n=std::min<size_t>(size-1,value.size());memcpy(buffer,value.data(),n);buffer[n]=0;}
bool init(){std::call_once(gdipOnce,[]{GdiplusStartupInput in;if(GdiplusStartup(&gdip,&in,nullptr)!=Ok)gdip=0;});return gdip!=0;}
std::string encode64(const std::vector<uint8_t>& data){DWORD n=0;CryptBinaryToStringA(data.data(),DWORD(data.size()),CRYPT_STRING_BASE64|CRYPT_STRING_NOCRLF,nullptr,&n);std::string s(n,'\0');if(!CryptBinaryToStringA(data.data(),DWORD(data.size()),CRYPT_STRING_BASE64|CRYPT_STRING_NOCRLF,s.data(),&n))return {};s.resize(n);while(!s.empty()&&!s.back())s.pop_back();return s;}
bool decode64(const std::string& text,std::vector<uint8_t>& data){if(text.size()>CHUNK*MAXPARTS)return false;DWORD n=0;if(!CryptStringToBinaryA(text.data(),DWORD(text.size()),CRYPT_STRING_BASE64|CRYPT_STRING_STRICT,nullptr,&n,nullptr,nullptr)||n>65536)return false;data.resize(n);return CryptStringToBinaryA(text.data(),DWORD(text.size()),CRYPT_STRING_BASE64|CRYPT_STRING_STRICT,data.data(),&n,nullptr,nullptr);}
bool decodeJPEG(Photo& p){if(!init()||p.jpeg.size()<4||p.jpeg[0]!=0xff||p.jpeg[1]!=0xd8)return false;IStream* stream=nullptr;if(FAILED(CreateStreamOnHGlobal(nullptr,TRUE,&stream)))return false;ULONG wrote=0;stream->Write(p.jpeg.data(),ULONG(p.jpeg.size()),&wrote);LARGE_INTEGER zero{};stream->Seek(zero,STREAM_SEEK_SET,nullptr);bool ok=false;{
    Bitmap image(stream,FALSE);if(image.GetLastStatus()==Ok&&image.GetWidth()==W&&image.GetHeight()==H){BitmapData b{};Rect r(0,0,W,H);if(image.LockBits(&r,ImageLockModeRead,PixelFormat32bppARGB,&b)==Ok){p.pixels.resize(W*H*4);for(int y=0;y<H;y++)memcpy(p.pixels.data()+y*W*4,static_cast<uint8_t*>(b.Scan0)+y*b.Stride,W*4);image.UnlockBits(&b);ok=true;}}
}stream->Release();return ok;}
bool compress(const uint8_t* pixels,int width,int height,Photo& p){if(!init())return false;Bitmap input(width,height,width*4,PixelFormat32bppARGB,const_cast<BYTE*>(pixels));Bitmap image(W,H,PixelFormat32bppARGB);{Graphics g(&image);g.SetInterpolationMode(InterpolationModeHighQualityBicubic);g.DrawImage(&input,0,0,W,H);}
    UINT count=0,size=0;GetImageEncodersSize(&count,&size);std::vector<uint8_t> storage(size);auto enc=reinterpret_cast<ImageCodecInfo*>(storage.data());if(GetImageEncoders(count,size,enc)!=Ok)return false;CLSID cls{};bool found=false;for(UINT i=0;i<count;i++)if(wcscmp(enc[i].MimeType,L"image/jpeg")==0){cls=enc[i].Clsid;found=true;break;}if(!found)return false;
    IStream* stream=nullptr;if(FAILED(CreateStreamOnHGlobal(nullptr,TRUE,&stream)))return false;ULONG quality=65;EncoderParameters params{};params.Count=1;params.Parameter[0].Guid=EncoderQuality;params.Parameter[0].Type=EncoderParameterValueTypeLong;params.Parameter[0].NumberOfValues=1;params.Parameter[0].Value=&quality;
    bool ok=false;if(image.Save(stream,&cls,&params)==Ok){STATSTG stat{};stream->Stat(&stat,STATFLAG_NONAME);if(stat.cbSize.QuadPart>0&&stat.cbSize.QuadPart<=65536){p.jpeg.resize(size_t(stat.cbSize.QuadPart));LARGE_INTEGER zero{};stream->Seek(zero,STREAM_SEEK_SET,nullptr);ULONG read=0;stream->Read(p.jpeg.data(),ULONG(p.jpeg.size()),&read);ok=read==p.jpeg.size();}}stream->Release();return ok&&decodeJPEG(p);
}
bool importShot(const std::string& id,Photo& p){
    if(id.rfind("P_",0)!=0||!init())return false;
    namespace fs=std::filesystem;std::vector<fs::path> bases;PWSTR docs=nullptr;
    if(SUCCEEDED(SHGetKnownFolderPath(FOLDERID_Documents,0,nullptr,&docs))){fs::path root(docs);CoTaskMemFree(docs);bases.push_back(root/L"Arma 3");std::error_code ec;auto others=root/L"Arma 3 - Other Profiles";for(auto& e:fs::directory_iterator(others,ec))if(e.is_directory(ec)&&!e.is_symlink(ec))bases.push_back(e.path());}
    int argc=0;auto argv=CommandLineToArgvW(GetCommandLineW(),&argc);if(argv){for(int i=0;i<argc;i++){std::wstring a=argv[i];if(a.size()>10&&_wcsnicmp(a.c_str(),L"-profiles=",10)==0){fs::path root(a.substr(10));bases.push_back(root);std::error_code ec;for(auto& e:fs::directory_iterator(root/L"Users",ec))if(e.is_directory(ec)&&!e.is_symlink(ec))bases.push_back(e.path());}}LocalFree(argv);}
    for(auto& base:bases){auto file=base/L"Screenshots"/L"ATLAS"/fs::path(id+".png");std::error_code ec;if(!fs::is_regular_file(file,ec)||fs::file_size(file,ec)>32*1024*1024)continue;Bitmap image(file.c_str(),FALSE);if(image.GetLastStatus()!=Ok||image.GetWidth()>8192||image.GetHeight()>8192||!image.GetWidth()||!image.GetHeight())continue;
        Bitmap small(W,H,PixelFormat32bppARGB);{Graphics g(&small);g.SetInterpolationMode(InterpolationModeHighQualityBicubic);g.DrawImage(&image,0,0,W,H);}BitmapData b{};Rect r(0,0,W,H);if(small.LockBits(&r,ImageLockModeRead,PixelFormat32bppARGB,&b)!=Ok)continue;std::vector<uint8_t> pixels(W*H*4);for(int y=0;y<H;y++)memcpy(pixels.data()+y*W*4,static_cast<uint8_t*>(b.Scan0)+y*b.Stride,W*4);small.UnlockBits(&b);return compress(pixels.data(),W,H,p);
    }return false;
}
void store(const std::string& id,Photo&& p){p.age=++sequence;photos[id]=std::move(p);while(photos.size()>64){auto oldest=std::min_element(photos.begin(),photos.end(),[](auto& a,auto& b){return a.second.age<b.second.age;});photos.erase(oldest);}}
struct GraphicsLock {virtual void ReleaseLock()const=0;virtual ~GraphicsLock()=default;};
using LockFn=GraphicsLock*(__stdcall*)();
thread_local bool graphicsLocked=false;
using CaptureCallback=void(__stdcall*)(ID3D11Texture2D*,ID3D11ShaderResourceView*,ID3D11RenderTargetView*,uint32_t,uint32_t,uint32_t,const char*);
using GetTextureFn=void(__stdcall*)(const char*,CaptureCallback);
void __stdcall captured(ID3D11Texture2D* texture,ID3D11ShaderResourceView*,ID3D11RenderTargetView*,uint32_t,uint32_t,uint32_t,const char* name){
    std::string id=name?name:"";{std::lock_guard<std::mutex> l(gate);diagnostics="callback:"+id;if(!pending.count(id)){auto found=std::find_if(pending.begin(),pending.end(),[&](auto& p){return _stricmp(p.first.c_str(),id.c_str())==0;});if(found==pending.end())return;id=found->first;}}if(!texture)return;
    auto lockFn=reinterpret_cast<LockFn>(GetProcAddress(GetModuleHandleW(nullptr),"RVExtensionGLock"));if(!lockFn){std::lock_guard<std::mutex> l(gate);diagnostics="graphics lock export missing";return;}auto guard=graphicsLocked?nullptr:lockFn();if(!graphicsLocked&&!guard){std::lock_guard<std::mutex> l(gate);diagnostics="graphics lock denied";return;}
    ID3D11Device* device=nullptr;ID3D11DeviceContext* context=nullptr;ID3D11Texture2D* staging=nullptr;ID3D11Texture2D* resolved=nullptr;
    std::vector<uint8_t> pixels;D3D11_TEXTURE2D_DESC d{};texture->GetDesc(&d);int width=int(d.Width),height=int(d.Height);
    if(width>0&&height>0&&width<=4096&&height<=4096&&(d.Format==DXGI_FORMAT_B8G8R8A8_UNORM||d.Format==DXGI_FORMAT_R8G8B8A8_UNORM||d.Format==DXGI_FORMAT_B8G8R8A8_UNORM_SRGB||d.Format==DXGI_FORMAT_R8G8B8A8_UNORM_SRGB)){
        texture->GetDevice(&device);device->GetImmediateContext(&context);auto desc=d;desc.MipLevels=1;desc.ArraySize=1;desc.SampleDesc.Count=1;desc.SampleDesc.Quality=0;desc.BindFlags=0;desc.MiscFlags=0;desc.Usage=D3D11_USAGE_STAGING;desc.CPUAccessFlags=D3D11_CPU_ACCESS_READ;
        ID3D11Texture2D* source=texture;if(d.SampleDesc.Count>1){auto rd=desc;rd.Usage=D3D11_USAGE_DEFAULT;rd.CPUAccessFlags=0;if(SUCCEEDED(device->CreateTexture2D(&rd,nullptr,&resolved))){context->ResolveSubresource(resolved,0,texture,0,d.Format);source=resolved;}else source=nullptr;}
        if(source&&SUCCEEDED(device->CreateTexture2D(&desc,nullptr,&staging))){context->CopySubresourceRegion(staging,0,0,0,0,source,0,nullptr);D3D11_MAPPED_SUBRESOURCE m{};if(SUCCEEDED(context->Map(staging,0,D3D11_MAP_READ,0,&m))){pixels.resize(size_t(width)*height*4);for(int y=0;y<height;y++)memcpy(pixels.data()+size_t(y)*width*4,static_cast<uint8_t*>(m.pData)+size_t(y)*m.RowPitch,width*4);context->Unmap(staging,0);if(d.Format==DXGI_FORMAT_R8G8B8A8_UNORM||d.Format==DXGI_FORMAT_R8G8B8A8_UNORM_SRGB)for(size_t i=0;i<pixels.size();i+=4)std::swap(pixels[i],pixels[i+2]);for(size_t i=3;i<pixels.size();i+=4)pixels[i]=255;}}
    }
    if(staging)staging->Release();if(resolved)resolved->Release();if(context)context->Release();if(device)device->Release();if(guard)guard->ReleaseLock();
    Photo p;bool ok=!pixels.empty()&&compress(pixels.data(),width,height,p);std::lock_guard<std::mutex> l(gate);diagnostics="capture:"+id+" format:"+std::to_string(d.Format)+" dimensions:"+std::to_string(width)+"x"+std::to_string(height)+" ok:"+std::to_string(ok);if(pending.erase(id)&&ok)store(id,std::move(p));
}
std::string info(const std::string& id){std::lock_guard<std::mutex> l(gate);auto it=photos.find(id);if(it==photos.end())return pending.count(id)?"WAIT":"MISSING";auto s=encode64(it->second.jpeg);return "OK|"+std::to_string((s.size()+CHUNK-1)/CHUNK)+"|"+std::to_string(it->second.jpeg.size());}
}
extern "C" {
__declspec(dllexport) void __stdcall RVExtensionVersion(char* output,unsigned size){out(output,size,"ATLAS_MEDIA 1.0 x64");}
__declspec(dllexport) void __stdcall RVExtension(char* output,unsigned size,const char*){out(output,size,"ATLAS_MEDIA|1|512|256");}
__declspec(dllexport) int __stdcall RVExtensionArgs(char* output,unsigned size,const char* function,const char** argv,unsigned argc){try{
    std::string f=function?function:"",id=argc?arg(argv[0]):"",result="ERR|arguments";
    if(f=="version"){out(output,size,"ATLAS_MEDIA|1|512|256");return 0;}if(f=="debug"){std::lock_guard<std::mutex> l(gate);out(output,size,diagnostics);return 0;}if(!validId(id)){out(output,size,"ERR|id");return 1;}
    if(f=="capture"&&argc==1){auto get=reinterpret_cast<GetTextureFn>(GetProcAddress(GetModuleHandleW(nullptr),"RVExtensionGGetR2TTexture"));auto lockFn=reinterpret_cast<LockFn>(GetProcAddress(GetModuleHandleW(nullptr),"RVExtensionGLock"));if(!get||!lockFn){out(output,size,"ERR|Arma 2.22 R2T capture unavailable");return 2;}{std::lock_guard<std::mutex> l(gate);if(pending.size()>=2){out(output,size,"ERR|busy");return 3;}pending[id]=GetTickCount64();diagnostics="requested:"+id;}auto guard=lockFn();if(!guard){out(output,size,"ERR|graphics unavailable");return 2;}graphicsLocked=true;get(id.c_str(),captured);if(info(id)=="WAIT")get(nullptr,captured);graphicsLocked=false;guard->ReleaseLock();result=info(id);}
    else if(f=="info"&&argc==1)result=info(id);
    else if(f=="import"&&argc==1){Photo p;if(importShot(id,p)){std::lock_guard<std::mutex> l(gate);pending.erase(id);store(id,std::move(p));result="OK";}else result="WAIT";}
    else {std::lock_guard<std::mutex> l(gate);
        if(f=="get"&&argc==2){auto it=photos.find(id);int index=number(arg(argv[1]));if(it!=photos.end()&&index>=0){auto s=encode64(it->second.jpeg);if(size_t(index)*CHUNK<s.size())result=s.substr(size_t(index)*CHUNK,CHUNK);}}
        else if(f=="begin"&&argc==2){int count=number(arg(argv[1]));for(auto it=incoming.begin();it!=incoming.end();)if(GetTickCount64()-it->second.started>30000)it=incoming.erase(it);else ++it;if(photos.count(id))result="READY";else if(count>=1&&count<=MAXPARTS&&incoming.size()<8){incoming[id]={std::vector<std::string>(count),GetTickCount64()};result="OK";}}
        else if(f=="put"&&argc==3){auto it=incoming.find(id);int i=number(arg(argv[1]));auto data=arg(argv[2]);if(it!=incoming.end()&&i>=0&&size_t(i)<it->second.parts.size()&&valid64(data)){it->second.parts[i]=data;result="OK";}}
        else if(f=="finish"&&argc==1){auto it=incoming.find(id);if(it!=incoming.end()){std::string text;bool complete=true;for(auto& s:it->second.parts){if(s.empty())complete=false;text+=s;}Photo p;if(complete&&decode64(text,p.jpeg)&&decodeJPEG(p)){store(id,std::move(p));result="OK";}incoming.erase(it);}}
        else if(f=="drop"&&argc==1){photos.erase(id);incoming.erase(id);pending.erase(id);result="OK";}
    }out(output,size,result);return result.rfind("ERR",0)==0?1:0;
}catch(...){out(output,size,"ERR|native operation failed");return 9;}}
__declspec(dllexport) void __stdcall RVExtensionFillTextureSource(const char* name,uint16_t width,uint16_t height,uint16_t pitch,uint8_t,uint32_t format,void* buffer){
    if(!buffer||!width||!height||pitch<width*4||format!=5)return;std::lock_guard<std::mutex> l(gate);auto it=photos.find(name?name:"");for(unsigned y=0;y<height;y++){auto dst=static_cast<uint8_t*>(buffer)+size_t(y)*pitch;for(unsigned x=0;x<width;x++){if(it!=photos.end()){size_t at=(size_t(y)*H/height*W+size_t(x)*W/width)*4;memcpy(dst+x*4,it->second.pixels.data()+at,4);}else {dst[x*4]=24;dst[x*4+1]=18;dst[x*4+2]=8;dst[x*4+3]=255;}}}
}
__declspec(dllexport) bool __stdcall RVExtensionHasTextureSourceUpdate(const char*){return false;}
}
