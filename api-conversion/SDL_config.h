#ifndef SDL_config_h_
#define SDL_config_h_
#include "SDL_platform.h"
#if defined(__WIN32__)
#include "SDL_config_windows.h"
#elif defined(__WINRT__)
#include "SDL_config_winrt.h"
#elif defined(__MACOSX__)
#include "SDL_config_macosx.h"
#elif defined(__IPHONEOS__)
#include "SDL_config_iphoneos.h"
#elif defined(__ANDROID__)
#include "SDL_config_android.h"
#elif defined(__PSP__)
#include "SDL_config_psp.h"
#elif defined(__OS2__)
#include "SDL_config_os2.h"
#else
#include "SDL_config_minimal.h"
#endif 
#ifdef USING_GENERATED_CONFIG_H
#error Wrong SDL_config.h, check your include path?
#endif
#endif 
