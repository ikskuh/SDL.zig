#ifndef SDL_system_h_
#define SDL_system_h_
#include "SDL_stdinc.h"
#include "SDL_keyboard.h"
#include "SDL_render.h"
#include "SDL_video.h"
#include "begin_code.h"
#ifdef __cplusplus
extern "C" {
#endif
#ifdef __WIN32__
	
typedef void ( * SDL_WindowsMessageHook)(void *userdata, void *hWnd, unsigned int message, Uint64 wParam, Sint64 lParam);
extern void SDL_SetWindowsMessageHook(SDL_WindowsMessageHook callback, void *userdata);
extern int SDL_Direct3D9GetAdapterIndex( int displayIndex );
typedef struct IDirect3DDevice9 IDirect3DDevice9;
extern IDirect3DDevice9* SDL_RenderGetD3D9Device(SDL_Renderer * renderer);
typedef struct ID3D11Device ID3D11Device;
extern ID3D11Device* SDL_RenderGetD3D11Device(SDL_Renderer * renderer);
extern SDL_bool SDL_DXGIGetOutputInfo( int displayIndex, int *adapterIndex, int *outputIndex );
#endif 
#ifdef __LINUX__
extern int SDL_LinuxSetThreadPriority(Sint64 threadID, int priority);
 
#endif 
	
#ifdef __IPHONEOS__
#define SDL_iOSSetAnimationCallback(window, interval, callback, callbackParam) SDL_iPhoneSetAnimationCallback(window, interval, callback, callbackParam)
extern int SDL_iPhoneSetAnimationCallback(SDL_Window * window, int interval, void (*callback)(void*), void *callbackParam);
#define SDL_iOSSetEventPump(enabled) SDL_iPhoneSetEventPump(enabled)
extern void SDL_iPhoneSetEventPump(SDL_bool enabled);
#endif 
#ifdef __ANDROID__
extern void * SDL_AndroidGetJNIEnv(void);
extern void * SDL_AndroidGetActivity(void);
extern int SDL_GetAndroidSDKVersion(void);
extern SDL_bool SDL_IsAndroidTV(void);
extern SDL_bool SDL_IsChromebook(void);
extern SDL_bool SDL_IsDeXMode(void);
extern void SDL_AndroidBackButton(void);
#define SDL_ANDROID_EXTERNAL_STORAGE_READ   0x01
#define SDL_ANDROID_EXTERNAL_STORAGE_WRITE  0x02
extern const char * SDL_AndroidGetInternalStoragePath(void);
extern int SDL_AndroidGetExternalStorageState(void);
extern const char * SDL_AndroidGetExternalStoragePath(void);
extern SDL_bool SDL_AndroidRequestPermission(const char *permission);
extern int SDL_AndroidShowToast(const char* message, int duration, int gravity, int xoffset, int yoffset);
#endif 
#ifdef __WINRT__
typedef enum
{
    
    SDL_WINRT_PATH_INSTALLED_LOCATION,
    
    SDL_WINRT_PATH_LOCAL_FOLDER,
    
    SDL_WINRT_PATH_ROAMING_FOLDER,
    
    SDL_WINRT_PATH_TEMP_FOLDER
} SDL_WinRT_Path;
typedef enum
{
    
    SDL_WINRT_DEVICEFAMILY_UNKNOWN,
    
    SDL_WINRT_DEVICEFAMILY_DESKTOP,
    
    SDL_WINRT_DEVICEFAMILY_MOBILE,
    
    SDL_WINRT_DEVICEFAMILY_XBOX,
} SDL_WinRT_DeviceFamily;
extern const wchar_t * SDL_WinRTGetFSPathUNICODE(SDL_WinRT_Path pathType);
extern const char * SDL_WinRTGetFSPathUTF8(SDL_WinRT_Path pathType);
extern SDL_WinRT_DeviceFamily SDL_WinRTGetDeviceFamily();
#endif 
extern SDL_bool SDL_IsTablet(void);
extern void SDL_OnApplicationWillTerminate(void);
extern void SDL_OnApplicationDidReceiveMemoryWarning(void);
extern void SDL_OnApplicationWillResignActive(void);
extern void SDL_OnApplicationDidEnterBackground(void);
extern void SDL_OnApplicationWillEnterForeground(void);
extern void SDL_OnApplicationDidBecomeActive(void);
#ifdef __IPHONEOS__
extern void SDL_OnApplicationDidChangeStatusBarOrientation(void);
#endif
#ifdef __cplusplus
}
#endif
#include "close_code.h"
#endif 
