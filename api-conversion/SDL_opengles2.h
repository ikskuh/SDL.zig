#include "SDL_config.h"
#ifndef _MSC_VER
#ifdef __IPHONEOS__
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#else
#include <GLES2/gl2platform.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#endif
#else 
#include "SDL_opengles2_khrplatform.h"
#include "SDL_opengles2_gl2platform.h"
#include "SDL_opengles2_gl2.h"
#include "SDL_opengles2_gl2ext.h"
#endif 
#ifndef APIENTRY
#define APIENTRY GL_APIENTRY
#endif
