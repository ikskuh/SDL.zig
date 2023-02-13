# SDL.zig

A Zig package that provides you with the means to link SDL2 to your project, as well as a Zig-infused header implementation (allows you to not have the SDL2 headers on your system and still compile for SDL2) and a shallow wrapper around the SDL apis that allow a more Zig-style coding with Zig error handling and tagged unions.

## Getting started

### Linking SDL2 to your project

This is an example `build.zig` that will link the SDL2 library to your project.

```zig
const std = @import("std");
const Sdk = @import("Sdk.zig"); // Import the Sdk at build time

pub fn build(b: *std.Build.Builder) !void {
    // Determine compilation target
    const target = b.standardTargetOptions(.{});
  
    // Create a new instance of the SDL2 Sdk
    const sdk = Sdk.init(b, null);

    // Create executable for our example
    const demo_basic = b.addExecutable(.{
        .name = "demo-basic",
        .root_source_file = .{ .path = "my-game.zig" },
    });
    
    demo_basic.setTarget(target);   // must be done before calling sdk.link
    sdk.link(demo_basic, .dynamic); // link SDL2 as a shared library

    // Add "sdl2" package that exposes the SDL2 api (like SDL_Init or SDL_CreateWindow)
    demo_basic.addModule("sdl2", sdk.getNativeModule()); 

    // Install the executable into the prefix when invoking "zig build"
    demo_basic.install();
}
```

### Using the native API

This package exposes the SDL2 API as defined in the SDL headers. Use this to create a normal SDL2 program:

```zig
const std = @import("std");
const SDL = @import("sdl2"); // Add this package by using sdk.getNativeModule

pub fn main() !void {
    if (SDL.SDL_Init(SDL.SDL_INIT_VIDEO | SDL.SDL_INIT_EVENTS | SDL.SDL_INIT_AUDIO) < 0)
        sdlPanic();
    defer SDL.SDL_Quit();

    var window = SDL.SDL_CreateWindow(
        "SDL2 Native Demo",
        SDL.SDL_WINDOWPOS_CENTERED, SDL.SDL_WINDOWPOS_CENTERED,
        640, 480,
        SDL.SDL_WINDOW_SHOWN,
    ) orelse sdlPanic();
    defer _ = SDL.SDL_DestroyWindow(window);

    var renderer = SDL.SDL_CreateRenderer(window, -1, SDL.SDL_RENDERER_ACCELERATED) orelse sdlPanic();
    defer _ = SDL.SDL_DestroyRenderer(renderer);

    mainLoop: while (true) {
        var ev: SDL.SDL_Event = undefined;
        while (SDL.SDL_PollEvent(&ev) != 0) {
            if(ev.type == SDL.SDL_QUIT)
                break :mainLoop;
        }

        _ = SDL.SDL_SetRenderDrawColor(renderer, 0xF7, 0xA4, 0x1D, 0xFF);
        _ = SDL.SDL_RenderClear(renderer);

        SDL.SDL_RenderPresent(renderer);
    }
}

fn sdlPanic() noreturn {
    const str = @as(?[*:0]const u8, SDL.SDL_GetError()) orelse "unknown error";
    @panic(std.mem.sliceTo(str, 0));
}
```

### Using the wrapper API

This package also exposes the SDL2 API with a more Zig-style API. Use this if you want a more convenient Zig experience.

**Note:** This API is experimental and might change in the future

```zig
const std = @import("std");
const SDL = @import("sdl2"); // Add this package by using sdk.getWrapperPackage

pub fn main() !void {
    try SDL.init(.{
        .video = true,
        .events = true,
        .audio = true,
    });
    defer SDL.quit();

    var window = try SDL.createWindow(
        "SDL2 Wrapper Demo",
        .{ .centered = {} }, .{ .centered = {} },
        640, 480,
        .{ .vis = .shown },
    );
    defer window.destroy();

    var renderer = try SDL.createRenderer(window, null, .{ .accelerated = true });
    defer renderer.destroy();

    mainLoop: while (true) {
        while (SDL.pollEvent()) |ev| {
            switch (ev) {
                .quit => break :mainLoop,
                else => {},
            }
        }

        try renderer.setColorRGB(0xF7, 0xA4, 0x1D);
        try renderer.clear();

        renderer.present();
    }
}
```

## `Sdk.zig` API

```zig
/// Just call `Sdk.init(b, null)` to obtain a handle to the Sdk!
const Sdk = @This();

/// Creates a instance of the Sdk and initializes internal steps.
/// Initialize once, use everywhere (in your `build` function).
pub fn init(b: *Build, maybe_config_path: ?[]const u8) *Sdk

/// Returns a module with the raw SDL api with proper argument types, but no functional/logical changes
/// for a more *ziggy* feeling.
/// This is similar to the *C import* result.
pub fn getNativeModule(sdk: *Sdk) *Build.Module;

/// Returns the smart wrapper for the SDL api. Contains convenient zig types, tagged unions and so on.
pub fn getWrapperModule(sdk: *Sdk) *Build.Module;

/// Links SDL2 to the given exe and adds required installs if necessary.
/// **Important:** The target of the `exe` must already be set, otherwise the Sdk will do the wrong thing!
pub fn link(sdk: *Sdk, exe: *LibExeObjStep, linkage: std.Build.LibExeObjStep.Linkage) void;
```

## Dependencies

All of those are dependencies for the *target* platform, not for your host. Zig will run/build the same on all source platforms.

### Windows

For Windows, you need to fetch the correct dev libraries from the [SDL download page](https://www.libsdl.org/download-2.0.php). It is recommended to use the MinGW versions if you don't require MSVC compatibility.

### MacOS

Right now, cross-compiling for MacOS isn't possible. On a Mac, install SDL2 via `brew`.

### Linux

If you are cross-compiling, no dependencies exist. The build Sdk compiles a `libSDL2.so` stub which is used for linking.

If you compile to your target platform, you require SDL2 to be installed via your OS package manager.

## Support Matrix

This project tries to provide you the best possible development experience for SDL2. Thus, this project supports
the maximum amount of cross-compilation targets for SDL2.

The following table documents this. The rows document the *target* whereas the columns are the *build host*:

|                       | Windows (x86_64) | Windows (i386) | Linux (x86_64) | MacOS (x86_64) | MacOS (aarch64) |
|-----------------------|------------------|----------------|----------------|----------------|-----------------|
| `i386-windows-gnu`    | ✅               | ✅             | ✅             | ✅             | ⚠️               |
| `i386-windows-msvc`   | ✅               | ✅             | ✅             | ✅             | ⚠️               |
| `x86_64-windows-gnu`  | ✅               | ✅             | ✅             | ✅             | ⚠️               |
| `x86_64-windows-msvc` | ✅               | ✅             | ✅             | ✅             | ⚠️               |
| `x86_64-macos`        | ❌               | ❌             | ❌             | ✅             | ❌              |
| `aarch64-macos`       | ❌               | ❌             | ❌             | ❌             | ⚠️               |
| `x86_64-linux-gnu`    | 🧪               | 🧪             | ✅             | 🧪             | ⚠️               |
| `aarch64-linux-gnu`   | 🧪               | 🧪             | 🧪             | 🧪             | ⚠️               |

Legend:
- ✅ Cross-compilation is known to work and tested via CI
- 🧪 Experimental cross-compilation support, covered via CI
- ⚠️ Cross-compilation *might* work, but is not tested via CI
- ❌ Cross-compilation is not possible right now

## Contributing

You can contribute to this project in several ways:
- Use it!  
  This helps me to track bugs (which i know that there are some), and usability defects (which we can resolve then). I want this library to have the best development experience possible.
- Implement/improve the linking experience:  
  Right now, it's not possible to cross-compile for MacOS, which is very sad. We might find a way to do so, though! Also VCPKG is not well supported on windows platforms.
- Improve the wrapper.  
  Just add the functions you need and make a PR. Or improve existing ones. I won't do it for you, so you have to get your own hands dirty!
