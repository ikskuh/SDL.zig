#ifndef SDL_main_h_
#define SDL_main_h_
#include "SDL_stdinc.h"
#ifndef SDL_MAIN_HANDLED
#if defined(__WIN32__)
#define SDL_MAIN_AVAILABLE
#elif defined(__WINRT__)
#define SDL_MAIN_NEEDED
#elif defined(__IPHONEOS__)
#define SDL_MAIN_NEEDED
#elif defined(__ANDROID__)
#define SDL_MAIN_NEEDED
#define SDLMAIN_DECLSPEC    DECLSPEC
#elif defined(__NACL__)
#define SDL_MAIN_NEEDED
#endif
#endif 
#ifndef SDLMAIN_DECLSPEC
#define SDLMAIN_DECLSPEC
#endif
#if defined(SDL_MAIN_NEEDED) || defined(SDL_MAIN_AVAILABLE)
#define main    SDL_main
#endif
#include "begin_code.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef int (*SDL_main_func)(int argc, char *argv[]);
extern SDLMAIN_DECLSPEC int SDL_main(int argc, char *argv[]);
extern void SDL_SetMainReady(void);
#ifdef __WIN32__
extern int SDL_RegisterApp(char *name, Uint32 style, void *hInst);
extern void SDL_UnregisterApp(void);
#endif 
#ifdef __WINRT__
extern int SDL_WinRTRunApp(SDL_main_func mainFunction, void * reserved);
#endif 
#if defined(__IPHONEOS__)
extern int SDL_UIKitRunApp(int argc, char *argv[], SDL_main_func mainFunction);
#endif 
#ifdef __cplusplus
}
#endif
#include "close_code.h"
#endif 
