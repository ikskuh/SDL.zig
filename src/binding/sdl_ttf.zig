const sdl = @import("sdl.zig");

pub const TTF_STYLE_NORMAL: c_int = 0x00;
pub const TTF_STYLE_BOLD: c_int = 0x01;
pub const TTF_STYLE_ITALIC: c_int = 0x02;
pub const TTF_STYLE_UNDERLINE: c_int = 0x04;

pub const TTF_Font = opaque {};

pub extern fn TTF_Init() c_int;
pub extern fn TTF_WasInit() c_int;
pub extern fn TTF_Quit() void;

pub const TTF_GetError = sdl.SDL_GetError;
pub const TTF_SetError = sdl.SDL_SetError;

pub extern fn TTF_OpenFont(file: [*c]const u8, point_size: c_int) ?*TTF_Font;
pub extern fn TTF_OpenFontRW(src: *sdl.SDL_RWops, free_src: c_int, point_size: c_int) ?*TTF_Font;
pub extern fn TTF_CloseFont(font: *TTF_Font) void;

pub extern fn TTF_GetFontStyle(font: *TTF_Font) c_int;
pub extern fn TTF_SetFontStyle(font: *TTF_Font, style: c_int) void;
pub extern fn TTF_FontHeight(font: *TTF_Font) c_int;

pub extern fn TTF_SizeText(font: *TTF_Font, text: [*c]const u8, width: ?*c_int, height: ?*c_int) c_int;

pub extern fn TTF_RenderText_Solid(font: *TTF_Font, text: [*c]const u8, foreground: sdl.SDL_Color) ?*sdl.SDL_Surface;

pub extern fn TTF_RenderText_Shaded(
    font: *TTF_Font,
    text: [*c]const u8,
    foreground: sdl.SDL_Color,
    background: sdl.SDL_Color,
) ?*sdl.SDL_Surface;

pub extern fn TTF_RenderText_Blended(
    font: *TTF_Font,
    text: [*c]const u8,
    foreground: sdl.SDL_Color,
) ?*sdl.SDL_Surface;
