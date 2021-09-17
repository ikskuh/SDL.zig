#ifndef SDL_config_windows_h_
#define SDL_config_windows_h_
#define SDL_config_h_
#include "SDL_platform.h"
#if !defined(_STDINT_H_) && (!defined(HAVE_STDINT_H) || !_HAVE_STDINT_H)
#if defined(__GNUC__) || defined(__DMC__) || defined(__WATCOMC__) || defined(__clang__)
#define HAVE_STDINT_H   1
#elif defined(_MSC_VER)
typedef signed __int8 int8_t;
typedef unsigned __int8 uint8_t;
typedef signed __int16 int16_t;
typedef unsigned __int16 uint16_t;
typedef signed __int32 int32_t;
typedef unsigned __int32 uint32_t;
typedef signed __int64 int64_t;
typedef unsigned __int64 uint64_t;
#ifndef _UINTPTR_T_DEFINED
#ifdef  _WIN64
typedef unsigned __int64 uintptr_t;
#else
typedef unsigned int uintptr_t;
#endif
#define _UINTPTR_T_DEFINED
#endif
#if ((_MSC_VER <= 1200) && (!defined(DWORD_PTR)))
#define DWORD_PTR DWORD
#endif
#if ((_MSC_VER <= 1200) && (!defined(LONG_PTR)))
#define LONG_PTR LONG
#endif
#else 
typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef signed short int16_t;
typedef unsigned short uint16_t;
typedef signed int int32_t;
typedef unsigned int uint32_t;
typedef signed long long int64_t;
typedef unsigned long long uint64_t;
#ifndef _SIZE_T_DEFINED_
#define _SIZE_T_DEFINED_
typedef unsigned int size_t;
#endif
typedef unsigned int uintptr_t;
#endif 
#endif 
#ifdef _WIN64
# define SIZEOF_VOIDP 8
#else
# define SIZEOF_VOIDP 4
#endif
#define HAVE_DDRAW_H 1
#define HAVE_DINPUT_H 1
#define HAVE_DSOUND_H 1
#define HAVE_DXGI_H 1
#define HAVE_XINPUT_H 1
#define HAVE_MMDEVICEAPI_H 1
#define HAVE_AUDIOCLIENT_H 1
#define HAVE_SENSORSAPI_H 1
#if (defined(_M_IX86) || defined(_M_X64) || defined(_M_AMD64)) && (defined(_MSC_VER) && _MSC_VER >= 1600)
#define HAVE_IMMINTRIN_H 1
#elif defined(__has_include) && (defined(__i386__) || defined(__x86_64))
# if __has_include(<immintrin.h>)
#   define HAVE_IMMINTRIN_H 1
# endif
#endif
#ifdef HAVE_LIBC
#define STDC_HEADERS 1
#define HAVE_CTYPE_H 1
#define HAVE_FLOAT_H 1
#define HAVE_LIMITS_H 1
#define HAVE_MATH_H 1
#define HAVE_SIGNAL_H 1
#define HAVE_STDIO_H 1
#define HAVE_STRING_H 1
#define HAVE_MALLOC 1
#define HAVE_CALLOC 1
#define HAVE_REALLOC 1
#define HAVE_FREE 1
#define HAVE_ALLOCA 1
#define HAVE_QSORT 1
#define HAVE_ABS 1
#define HAVE_MEMSET 1
#define HAVE_MEMCPY 1
#define HAVE_MEMMOVE 1
#define HAVE_MEMCMP 1
#define HAVE_STRLEN 1
#define HAVE__STRREV 1
#define HAVE_STRCHR 1
#define HAVE_STRRCHR 1
#define HAVE_STRSTR 1
#define HAVE_STRTOL 1
#define HAVE_STRTOUL 1
#define HAVE_STRTOD 1
#define HAVE_ATOI 1
#define HAVE_ATOF 1
#define HAVE_STRCMP 1
#define HAVE_STRNCMP 1
#define HAVE__STRICMP 1
#define HAVE__STRNICMP 1
#define HAVE__WCSICMP 1
#define HAVE__WCSNICMP 1
#define HAVE__WCSDUP 1
#define HAVE_ACOS   1
#define HAVE_ACOSF  1
#define HAVE_ASIN   1
#define HAVE_ASINF  1
#define HAVE_ATAN   1
#define HAVE_ATANF  1
#define HAVE_ATAN2  1
#define HAVE_ATAN2F 1
#define HAVE_CEILF  1
#define HAVE__COPYSIGN 1
#define HAVE_COS    1
#define HAVE_COSF   1
#define HAVE_EXP    1
#define HAVE_EXPF   1
#define HAVE_FABS   1
#define HAVE_FABSF  1
#define HAVE_FLOOR  1
#define HAVE_FLOORF 1
#define HAVE_FMOD   1
#define HAVE_FMODF  1
#define HAVE_LOG    1
#define HAVE_LOGF   1
#define HAVE_LOG10  1
#define HAVE_LOG10F 1
#define HAVE_POW    1
#define HAVE_POWF   1
#define HAVE_SIN    1
#define HAVE_SINF   1
#define HAVE_SQRT   1
#define HAVE_SQRTF  1
#define HAVE_TAN    1
#define HAVE_TANF   1
#if defined(_MSC_VER)
#if _MSC_VER >= 1800
#define HAVE_STRTOLL 1
#define HAVE_STRTOULL 1
#define HAVE_VSSCANF 1
#define HAVE_LROUND 1
#define HAVE_LROUNDF 1
#define HAVE_ROUND 1
#define HAVE_ROUNDF 1
#define HAVE_SCALBN 1
#define HAVE_SCALBNF 1
#define HAVE_TRUNC  1
#define HAVE_TRUNCF 1
#endif
#if _MSC_VER >= 1400
#define HAVE__FSEEKI64 1
#endif
#endif
#if !defined(_MSC_VER) || defined(_USE_MATH_DEFINES)
#define HAVE_M_PI 1
#endif
#else
#define HAVE_STDARG_H   1
#define HAVE_STDDEF_H   1
#endif
#if defined(_MSC_VER) && (_MSC_VER >= 1911)        
#include <sdkddkver.h>
#if _WIN32_WINNT >= 0x0601  
#define SDL_WINDOWS7_SDK
#endif
#if _WIN32_WINNT >= 0x0602  
#define SDL_WINDOWS8_SDK
#endif
#if _WIN32_WINNT >= 0x0A00  
#define SDL_WINDOWS10_SDK
#endif
#endif 
#define SDL_AUDIO_DRIVER_WASAPI 1
#define SDL_AUDIO_DRIVER_DSOUND 1
#define SDL_AUDIO_DRIVER_WINMM  1
#define SDL_AUDIO_DRIVER_DISK   1
#define SDL_AUDIO_DRIVER_DUMMY  1
#define SDL_JOYSTICK_DINPUT 1
#define SDL_JOYSTICK_HIDAPI 1
#ifndef __WINRT__
#define SDL_JOYSTICK_RAWINPUT   1
#endif
#define SDL_JOYSTICK_VIRTUAL    1
#ifdef SDL_WINDOWS10_SDK
#define SDL_JOYSTICK_WGI    1
#endif
#define SDL_JOYSTICK_XINPUT 1
#define SDL_HAPTIC_DINPUT   1
#define SDL_HAPTIC_XINPUT   1
#define SDL_SENSOR_WINDOWS  1
#define SDL_LOADSO_WINDOWS  1
#define SDL_THREAD_GENERIC_COND_SUFFIX 1
#define SDL_THREAD_WINDOWS  1
#define SDL_TIMER_WINDOWS   1
#define SDL_VIDEO_DRIVER_DUMMY  1
#define SDL_VIDEO_DRIVER_WINDOWS    1
#ifndef SDL_VIDEO_RENDER_D3D
#define SDL_VIDEO_RENDER_D3D    1
#endif
#ifdef SDL_WINDOWS7_SDK
#define SDL_VIDEO_RENDER_D3D11  1
#endif
#ifndef SDL_VIDEO_OPENGL
#define SDL_VIDEO_OPENGL    1
#endif
#ifndef SDL_VIDEO_OPENGL_WGL
#define SDL_VIDEO_OPENGL_WGL    1
#endif
#ifndef SDL_VIDEO_RENDER_OGL
#define SDL_VIDEO_RENDER_OGL    1
#endif
#ifndef SDL_VIDEO_RENDER_OGL_ES2
#define SDL_VIDEO_RENDER_OGL_ES2    1
#endif
#ifndef SDL_VIDEO_OPENGL_ES2
#define SDL_VIDEO_OPENGL_ES2    1
#endif
#ifndef SDL_VIDEO_OPENGL_EGL
#define SDL_VIDEO_OPENGL_EGL    1
#endif
#define SDL_VIDEO_VULKAN 1
#define SDL_POWER_WINDOWS 1
#define SDL_FILESYSTEM_WINDOWS  1
#ifndef _WIN64
#define SDL_ASSEMBLY_ROUTINES   1
#endif
#endif 
