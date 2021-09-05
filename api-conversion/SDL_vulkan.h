#ifndef SDL_vulkan_h_
#define SDL_vulkan_h_
#include "SDL_video.h"
#include "begin_code.h"
#ifdef __cplusplus
extern "C" {
#endif
#ifdef VULKAN_H_
#define NO_SDL_VULKAN_TYPEDEFS
#endif
#ifndef NO_SDL_VULKAN_TYPEDEFS
#define VK_DEFINE_HANDLE(object) typedef struct object##_T* object;
#if defined(__LP64__) || defined(_WIN64) || defined(__x86_64__) || defined(_M_X64) || defined(__ia64) || defined (_M_IA64) || defined(__aarch64__) || defined(__powerpc64__)
#define VK_DEFINE_NON_DISPATCHABLE_HANDLE(object) typedef struct object##_T *object;
#else
#define VK_DEFINE_NON_DISPATCHABLE_HANDLE(object) typedef uint64_t object;
#endif
VK_DEFINE_HANDLE(VkInstance)
VK_DEFINE_NON_DISPATCHABLE_HANDLE(VkSurfaceKHR)
#endif 
typedef VkInstance SDL_vulkanInstance;
typedef VkSurfaceKHR SDL_vulkanSurface; 
extern int SDL_Vulkan_LoadLibrary(const char *path);
extern void * SDL_Vulkan_GetVkGetInstanceProcAddr(void);
extern void SDL_Vulkan_UnloadLibrary(void);
extern SDL_bool SDL_Vulkan_GetInstanceExtensions(SDL_Window *window,
                                                                  unsigned int *pCount,
                                                                  const char **pNames);
extern SDL_bool SDL_Vulkan_CreateSurface(SDL_Window *window,
                                                          VkInstance instance,
                                                          VkSurfaceKHR* surface);
extern void SDL_Vulkan_GetDrawableSize(SDL_Window * window,
                                                        int *w, int *h);
#ifdef __cplusplus
}
#endif
#include "close_code.h"
#endif 
