#ifdef _begin_code_h
#error Nested inclusion of begin_code.h
#endif
#define _begin_code_h
#ifndef SDL_DEPRECATED
#  if (__GNUC__ >= 4)  
#    define SDL_DEPRECATED __attribute__((deprecated))
#  else
#    define SDL_DEPRECATED
#  endif
#endif
#ifndef SDL_UNUSED
#  ifdef __GNUC__
#    define SDL_UNUSED __attribute__((unused))
#  else
#    define SDL_UNUSED
#  endif
#endif
#ifndef DECLSPEC
# if defined(__WIN32__) || defined(__WINRT__) || defined(__CYGWIN__)
#  ifdef DLL_EXPORT
#   define __declspec(dllexport)
#  else
#   define DECLSPEC
#  endif
# elif defined(__OS2__)
#   ifdef BUILD_SDL
#    define    __declspec(dllexport)
#   else
#    define DECLSPEC
#   endif
# else
#  if defined(__GNUC__) && __GNUC__ >= 4
#   define __attribute__ ((visibility("default")))
#  else
#   define DECLSPEC
#  endif
# endif
#endif
#ifndef 
#if (defined(__WIN32__) || defined(__WINRT__)) && !defined(__GNUC__)
#define __cdecl
#elif defined(__OS2__) || defined(__EMX__)
#define _System
# if defined (__GNUC__) && !defined(_System)
#  define _System 
# endif
#else
#define 
#endif
#endif 
#ifdef __SYMBIAN32__
#undef DECLSPEC
#define DECLSPEC
#endif 
#if defined(_MSC_VER) || defined(__MWERKS__) || defined(__BORLANDC__)
#ifdef _MSC_VER
#pragma warning(disable: 4103)
#endif
#ifdef __clang__
#pragma clang diagnostic ignored "-Wpragma-pack"
#endif
#ifdef __BORLANDC__
#pragma nopackwarning
#endif
#ifdef _M_X64
#pragma pack(push,8)
#else
#pragma pack(push,4)
#endif
#endif 
#ifndef SDL_INLINE
#if defined(__GNUC__)
#define SDL_INLINE __inline__
#elif defined(_MSC_VER) || defined(__BORLANDC__) || \
      defined(__DMC__) || defined(__SC__) || \
      defined(__WATCOMC__) || defined(__LCC__) || \
      defined(__DECC) || defined(__CC_ARM)
#define SDL_INLINE __inline
#ifndef __inline__
#define __inline__ __inline
#endif
#else
#define SDL_INLINE inline
#ifndef __inline__
#define __inline__ inline
#endif
#endif
#endif 
#ifndef SDL_FORCE_INLINE
#if defined(_MSC_VER)
#define SDL_FORCE_INLINE __forceinline
#elif ( (defined(__GNUC__) && (__GNUC__ >= 4)) || defined(__clang__) )
#define SDL_FORCE_INLINE __attribute__((always_inline)) static __inline__
#else
#define SDL_FORCE_INLINE static SDL_INLINE
#endif
#endif 
#ifndef SDL_NORETURN
#if defined(__GNUC__)
#define SDL_NORETURN __attribute__((noreturn))
#elif defined(_MSC_VER)
#define SDL_NORETURN __declspec(noreturn)
#else
#define SDL_NORETURN
#endif
#endif 
#if !defined(__MACH__)
#ifndef NULL
#ifdef __cplusplus
#define NULL 0
#else
#define NULL ((void *)0)
#endif
#endif 
#endif 
