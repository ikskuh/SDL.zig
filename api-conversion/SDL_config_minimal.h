#ifndef SDL_config_minimal_h_
#define SDL_config_minimal_h_
#define SDL_config_h_
#include "SDL_platform.h"
#define HAVE_STDARG_H   1
#define HAVE_STDDEF_H   1
#if defined(_MSC_VER) && (_MSC_VER < 1600)
typedef unsigned int size_t;
typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef signed short int16_t;
typedef unsigned short uint16_t;
typedef signed int int32_t;
typedef unsigned int uint32_t;
typedef signed long long int64_t;
typedef unsigned long long uint64_t;
typedef unsigned long uintptr_t;
#else
#define HAVE_STDINT_H 1
#endif 
#ifdef __GNUC__
#define HAVE_GCC_SYNC_LOCK_TEST_AND_SET 1
#endif
#define SDL_AUDIO_DRIVER_DUMMY  1
#define SDL_JOYSTICK_DISABLED   1
#define SDL_HAPTIC_DISABLED 1
#define SDL_SENSOR_DISABLED 1
#define SDL_LOADSO_DISABLED 1
#define SDL_THREADS_DISABLED    1
#define SDL_TIMERS_DISABLED 1
#define SDL_VIDEO_DRIVER_DUMMY  1
#define SDL_FILESYSTEM_DUMMY  1
#endif 
