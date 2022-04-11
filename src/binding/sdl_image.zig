const sdl = @import("sdl.zig");

pub const IMG_INIT_JPG: c_int = 1;
pub const IMG_INIT_PNG: c_int = 2;
pub const IMG_INIT_TIF: c_int = 4;
pub const IMG_INIT_WEBP: c_int = 8;

pub extern fn IMG_Init(flags: c_int) c_int;
pub extern fn IMG_Quit() void;

pub extern fn IMG_LoadTexture(renderer: ?*sdl.SDL_Renderer, file: [*c]const u8) ?*sdl.SDL_Texture;
pub extern fn IMG_Load(file: [*:0]const u8) ?*sdl.SDL_Surface;

pub const IMG_SetError = sdl.SDL_SetError;
pub const IMG_GetError = sdl.SDL_GetError;
