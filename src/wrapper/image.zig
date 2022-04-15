const SDL = @import("sdl.zig");
const std = @import("std");

/// Exports the C interface for SDL_image
pub const c = @import("sdl-native");

pub const InitFlags = packed struct {
    jpg: bool = false, // IMG_INIT_JPG = 1,
    png: bool = false, // IMG_INIT_PNG = 2,
    tif: bool = false, // IMG_INIT_TIF = 4,
    webp: bool = false, // IMG_INIT_WEBP = 8,
};

pub fn init(flags: InitFlags) !void {
    if (c.IMG_Init(@bitCast(u4, flags)) < 0)
        return error.SdlError;
}

pub fn quit() void {
    c.IMG_Quit();
}

pub fn loadTexture(ren: SDL.Renderer, file: [:0]const u8) !SDL.Texture {
    return SDL.Texture{
        .ptr = c.IMG_LoadTexture(ren.ptr, file) orelse return SDL.makeError(),
    };
}

pub fn loadSurface(file: [:0]const u8) !SDL.Surface {
    return SDL.Surface{
        .ptr = c.IMG_Load(file) orelse return SDL.makeError(),
    };
}

test "platform independent declarations" {
    std.testing.refAllDecls(@This());
}
