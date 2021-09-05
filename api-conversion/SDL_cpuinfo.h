#ifndef SDL_cpuinfo_h_
#define SDL_cpuinfo_h_
#include "SDL_stdinc.h"
#if defined(_MSC_VER) && (_MSC_VER >= 1500) &&                                 \
    (defined(_M_IX86) || defined(_M_X64))
#ifdef __clang__
#ifndef __PRFCHWINTRIN_H
#define __PRFCHWINTRIN_H
static __inline__ void __attribute__((__always_inline__, __nodebug__))
_m_prefetch(void *__P) {
  __builtin_prefetch(__P, 0, 3);
}
#endif
#endif
#include <intrin.h>
#ifndef _WIN64
#ifndef __MMX__
#define __MMX__
#endif
#ifndef __3dNOW__
#define __3dNOW__
#endif
#endif
#ifndef __SSE__
#define __SSE__
#endif
#ifndef __SSE2__
#define __SSE2__
#endif
#ifndef __SSE3__
#define __SSE3__
#endif
#elif defined(__MINGW64_VERSION_MAJOR)
#include <intrin.h>
#if !defined(SDL_DISABLE_ARM_NEON_H) && defined(__ARM_NEON)
#include <arm_neon.h>
#endif
#else
#if defined(HAVE_ALTIVEC_H) && defined(__ALTIVEC__) &&                         \
    !defined(__APPLE_ALTIVEC__) && defined(SDL_ENABLE_ALTIVEC_H)
#include <altivec.h>
#endif
#if !defined(SDL_DISABLE_ARM_NEON_H)
#if defined(__ARM_NEON)
#include <arm_neon.h>
#elif defined(__WINDOWS__) || defined(__WINRT__)
#if defined(_M_ARM)
#include <arm_neon.h>
#include <armintr.h>
#define __ARM_NEON 1
#endif
#if defined(_M_ARM64)
#include <arm64_neon.h>
#include <arm64intr.h>
#define __ARM_NEON 1
#endif
#endif
#endif
#endif
#if defined(__3dNOW__) && !defined(SDL_DISABLE_MM3DNOW_H)
#include <mm3dnow.h>
#endif
#if defined(HAVE_IMMINTRIN_H) && !defined(SDL_DISABLE_IMMINTRIN_H)
#include <immintrin.h>
#else
#if defined(__MMX__) && !defined(SDL_DISABLE_MMINTRIN_H)
#include <mmintrin.h>
#endif
#if defined(__SSE__) && !defined(SDL_DISABLE_XMMINTRIN_H)
#include <xmmintrin.h>
#endif
#if defined(__SSE2__) && !defined(SDL_DISABLE_EMMINTRIN_H)
#include <emmintrin.h>
#endif
#if defined(__SSE3__) && !defined(SDL_DISABLE_PMMINTRIN_H)
#include <pmmintrin.h>
#endif
#endif
#include "begin_code.h"
#ifdef __cplusplus
extern "C" {
#endif
#ifdef __cplusplus
}
#endif
#include "close_code.h"
#endif
