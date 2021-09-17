#ifndef SDL_assert_h_
#define SDL_assert_h_
#include "SDL_config.h"
#include "begin_code.h"
#ifdef __cplusplus
extern "C" {
#endif
#ifndef SDL_ASSERT_LEVEL
#ifdef SDL_DEFAULT_ASSERT_LEVEL
#define SDL_ASSERT_LEVEL SDL_DEFAULT_ASSERT_LEVEL
#elif defined(_DEBUG) || defined(DEBUG) || \
      (defined(__GNUC__) && !defined(__OPTIMIZE__))
#define SDL_ASSERT_LEVEL 2
#else
#define SDL_ASSERT_LEVEL 1
#endif
#endif 
#if defined(_MSC_VER)
    extern void __cdecl __debugbreak(void);
    #define SDL_TriggerBreakpoint() __debugbreak()
#elif ( (!defined(__NACL__)) && ((defined(__GNUC__) || defined(__clang__)) && (defined(__i386__) || defined(__x86_64__))) )
    #define SDL_TriggerBreakpoint() __asm__ __volatile__ ( "int $3\n\t" )
#elif ( defined(__APPLE__) && (defined(__arm64__) || defined(__aarch64__)) )  
    #define SDL_TriggerBreakpoint() __asm__ __volatile__ ( "brk #22\n\t" )
#elif defined(__APPLE__) && defined(__arm__)
    #define SDL_TriggerBreakpoint() __asm__ __volatile__ ( "bkpt #22\n\t" )
#elif defined(__386__) && defined(__WATCOMC__)
    #define SDL_TriggerBreakpoint() { _asm { int 0x03 } }
#elif defined(HAVE_SIGNAL_H) && !defined(__WATCOMC__)
    #include <signal.h>
    #define SDL_TriggerBreakpoint() raise(SIGTRAP)
#else
    
    #define SDL_TriggerBreakpoint()
#endif
#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L) 
#   define SDL_FUNCTION __func__
#elif ((__GNUC__ >= 2) || defined(_MSC_VER) || defined (__WATCOMC__))
#   define SDL_FUNCTION __FUNCTION__
#else
#   define SDL_FUNCTION "???"
#endif
#define SDL_FILE    __FILE__
#define SDL_LINE    __LINE__
#ifdef _MSC_VER  
#define SDL_NULL_WHILE_LOOP_CONDITION (0,0)
#else
#define SDL_NULL_WHILE_LOOP_CONDITION (0)
#endif
#define SDL_disabled_assert(condition) \
    do { (void) sizeof ((condition)); } while (SDL_NULL_WHILE_LOOP_CONDITION)
typedef enum
{
    SDL_ASSERTION_RETRY,  
    SDL_ASSERTION_BREAK,  
    SDL_ASSERTION_ABORT,  
    SDL_ASSERTION_IGNORE,  
    SDL_ASSERTION_ALWAYS_IGNORE  
} SDL_AssertState;
typedef struct SDL_AssertData
{
    int always_ignore;
    unsigned int trigger_count;
    const char *condition;
    const char *filename;
    int linenum;
    const char *function;
    const struct SDL_AssertData *next;
} SDL_AssertData;
#if (SDL_ASSERT_LEVEL > 0)
extern SDL_AssertState SDL_ReportAssertion(SDL_AssertData *,
                                                             const char *,
                                                             const char *, int)
#if defined(__clang__)
#if __has_feature(attribute_analyzer_noreturn)
   __attribute__((analyzer_noreturn))
#endif
#endif
;
#define SDL_enabled_assert(condition) \
    do { \
        while ( !(condition) ) { \
            static struct SDL_AssertData sdl_assert_data = { \
                0, 0, #condition, 0, 0, 0, 0 \
            }; \
            const SDL_AssertState sdl_assert_state = SDL_ReportAssertion(&sdl_assert_data, SDL_FUNCTION, SDL_FILE, SDL_LINE); \
            if (sdl_assert_state == SDL_ASSERTION_RETRY) { \
                continue;  \
            } else if (sdl_assert_state == SDL_ASSERTION_BREAK) { \
                SDL_TriggerBreakpoint(); \
            } \
            break;  \
        } \
    } while (SDL_NULL_WHILE_LOOP_CONDITION)
#endif  
#if SDL_ASSERT_LEVEL == 0   
#   define SDL_assert(condition) SDL_disabled_assert(condition)
#   define SDL_assert_release(condition) SDL_disabled_assert(condition)
#   define SDL_assert_paranoid(condition) SDL_disabled_assert(condition)
#elif SDL_ASSERT_LEVEL == 1  
#   define SDL_assert(condition) SDL_disabled_assert(condition)
#   define SDL_assert_release(condition) SDL_enabled_assert(condition)
#   define SDL_assert_paranoid(condition) SDL_disabled_assert(condition)
#elif SDL_ASSERT_LEVEL == 2  
#   define SDL_assert(condition) SDL_enabled_assert(condition)
#   define SDL_assert_release(condition) SDL_enabled_assert(condition)
#   define SDL_assert_paranoid(condition) SDL_disabled_assert(condition)
#elif SDL_ASSERT_LEVEL == 3  
#   define SDL_assert(condition) SDL_enabled_assert(condition)
#   define SDL_assert_release(condition) SDL_enabled_assert(condition)
#   define SDL_assert_paranoid(condition) SDL_enabled_assert(condition)
#else
#   error Unknown assertion level.
#endif
#define SDL_assert_always(condition) SDL_enabled_assert(condition)
typedef SDL_AssertState ( *SDL_AssertionHandler)(
                                 const SDL_AssertData* data, void* userdata);
extern void SDL_SetAssertionHandler(
                                            SDL_AssertionHandler handler,
                                            void *userdata);
extern SDL_AssertionHandler SDL_GetDefaultAssertionHandler(void);
extern SDL_AssertionHandler SDL_GetAssertionHandler(void **puserdata);
extern const SDL_AssertData * SDL_GetAssertionReport(void);
extern void SDL_ResetAssertionReport(void);
#define SDL_assert_state SDL_AssertState
#define SDL_assert_data SDL_AssertData
#ifdef __cplusplus
}
#endif
#include "close_code.h"
#endif 
