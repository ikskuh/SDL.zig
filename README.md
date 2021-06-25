# SDL.zig
A shallow wrapper around SDL that provides object API and error handling

## Getting started

See `build.zig` and `examples/basic.zig` on how to get started with the library.

## TODO:

Make `SDL_image` an optional dependency

## Support Matrix

This project tries to provide you the best possible development experience for SDL2. Thus, this project supports
the maximum amount of cross-compilation targets for SDL2.

The following table documents this. The rows document the *target* whereas the columns are the *build host*:

|                       | Windows (x86_64) | Windows (i386) | Linux (x86_64) | MacOS (x86_64) |
|-----------------------|------------------|----------------|----------------|----------------|
| `i386-windows-gnu`    | ✅               | ✅             | ✅             | ✅             |
| `i386-windows-msvc`   | ✅               | ✅             | ✅             | ✅             |
| `x86_64-windows-gnu`  | ✅               | ✅             | ✅             | ✅             |
| `x86_64-windows-msvc` | ✅               | ✅             | ✅             | ✅             |
| `x86_64-macos`        | ❌               | ❌             | ❌             | ✅             |
| `x86_64-linux-gnu`    | 🧪               | 🧪             | ✅             | 🧪             |

Legend:
- ✅ Cross-compilation is known to work and tested via CI
- 🧪 Experimental cross-compilation support, covered via CI
- ⚠️ Cross-compilation *might* work, but is not tested via CI
- ❌ Cross-compilation is 