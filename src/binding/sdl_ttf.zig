const sdl = @import("sdl.zig");

pub extern fn TTF_Init() c_int;
pub extern fn TTF_WasInit() c_int;
pub extern fn TTF_Quit() void;

pub const TTF_Font = opaque {};

pub const TTF_GetError = sdl.SDL_GetError;
pub const TTF_SetError = sdl.SDL_SetError;

pub extern fn TTF_OpenFont(file: [*c]const u8, point_size: c_int) ?*TTF_Font;
pub extern fn TTF_OpenFontRW(src: *sdl.SDL_RWops, free_src: c_int, point_size: c_int) ?*TTF_Font;
pub extern fn TTF_CloseFont(font: *TTF_Font) void;
