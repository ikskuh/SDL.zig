const sdl = @import("sdl.zig");

pub extern fn IMG_Init(flags: c_int) c_int;
pub extern fn IMG_Quit() void;

pub extern fn IMG_LoadTexture(renderer: ?*sdl.SDL_Renderer, file: [*c]const u8) ?*sdl.SDL_Texture;
pub extern fn IMG_Load(file: [*:0]const u8) ?*sdl.SDL_Surface;
