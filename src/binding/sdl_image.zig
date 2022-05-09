const sdl = @import("sdl.zig");

pub const IMG_INIT_JPG: c_int = 1;
pub const IMG_INIT_PNG: c_int = 2;
pub const IMG_INIT_TIF: c_int = 4;
pub const IMG_INIT_WEBP: c_int = 8;

pub extern fn IMG_Init(flags: c_int) c_int;
pub extern fn IMG_Quit() void;

pub extern fn IMG_LoadTexture(renderer: ?*sdl.SDL_Renderer, file: [*c]const u8) ?*sdl.SDL_Texture;
pub extern fn IMG_Load(file: [*:0]const u8) ?*sdl.SDL_Surface;

pub extern fn IMG_LoadTyped_RW(rw: *sdl.SDL_RWops, freesrc: c_int, type: [*:0]const u8) ?*sdl.SDL_Surface;
pub extern fn IMG_Load_RW(rw: *sdl.SDL_RWops, freesrc: c_int) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadBMP_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadCUR_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadGIF_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadICO_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadJPG_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadLBM_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadPCX_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadPNG_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadPNM_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadTGA_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadTIF_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadXCF_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadXPM_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadXV_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;

pub const IMG_SetError = sdl.SDL_SetError;
pub const IMG_GetError = sdl.SDL_GetError;
