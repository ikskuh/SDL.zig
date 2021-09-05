#ifndef SDL_metal_h_
#define SDL_metal_h_
#include "SDL_video.h"
#include "begin_code.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef void *SDL_MetalView;
extern SDL_MetalView SDL_Metal_CreateView(SDL_Window * window);
extern void SDL_Metal_DestroyView(SDL_MetalView view);
extern void * SDL_Metal_GetLayer(SDL_MetalView view);
extern void SDL_Metal_GetDrawableSize(SDL_Window* window, int *w,
                                                       int *h);
#ifdef __cplusplus
}
#endif
#include "close_code.h"
#endif 
