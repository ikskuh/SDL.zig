const std = @import("std");
const SDL = @import("sdl2");
const target_os = @import("builtin").os;

pub fn main() !void {
    if (SDL.SDL_Init(SDL.SDL_INIT_VIDEO | SDL.SDL_INIT_EVENTS | SDL.SDL_INIT_AUDIO) < 0)
        sdlPanic();
    defer SDL.SDL_Quit();

    var window = SDL.SDL_CreateWindow(
        "SDL.zig Basic Demo",
        SDL.SDL_WINDOWPOS_CENTERED,
        SDL.SDL_WINDOWPOS_CENTERED,
        640,
        480,
        SDL.SDL_WINDOW_SHOWN,
    ) orelse sdlPanic();
    defer _ = SDL.SDL_DestroyWindow(window);

    var renderer = SDL.SDL_CreateRenderer(window, -1, SDL.SDL_RENDERER_ACCELERATED) orelse sdlPanic();
    defer _ = SDL.SDL_DestroyRenderer(renderer);

    const vertices = [_]SDL.SDL_Vertex{
        .{
            .position = .{ .x = 400, .y = 150 },
            .color = .{ .r = 255, .g = 0, .b = 0, .a = 255 },
        },
        .{
            .position = .{ .x = 350, .y = 200 },
            .color = .{ .r = 0, .g = 0, .b = 255, .a = 255 },
        },
        .{
            .position = .{ .x = 450, .y = 200 },
            .color = .{ .r = 0, .g = 255, .b = 0, .a = 255 },
        },
    };

    mainLoop: while (true) {
        var ev: SDL.SDL_Event = undefined;
        while (SDL.SDL_PollEvent(&ev) != 0) {
            switch (ev.type) {
                SDL.SDL_QUIT => break :mainLoop,
                SDL.SDL_KEYDOWN => {
                    switch (ev.key.keysym.scancode) {
                        SDL.SDL_SCANCODE_ESCAPE => break :mainLoop,
                        else => std.log.info("key pressed: {}\n", .{ev.key.keysym.scancode}),
                    }
                },

                else => {},
            }
        }

        _ = SDL.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0xFF);
        _ = SDL.SDL_RenderClear(renderer);

        _ = SDL.SDL_SetRenderDrawColor(renderer, 0xF7, 0xA4, 0x1D, 0xFF);
        _ = SDL.SDL_RenderDrawRect(renderer, &SDL.SDL_Rect{
            .x = 270,
            .y = 215,
            .w = 100,
            .h = 50,
        });

        if (target_os.tag != .linux) {
            // Ubuntu CI doesn't have this function available yet
            _ = SDL.SDL_RenderGeometry(
                renderer,
                null,
                &vertices,
                3,
                null,
                0,
            );
        }

        SDL.SDL_RenderPresent(renderer);
    }
}

fn sdlPanic() noreturn {
    const str = @as(?[*:0]const u8, SDL.SDL_GetError()) orelse "unknown error";
    @panic(std.mem.sliceTo(str, 0));
}
