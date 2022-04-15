const sdl = @import("sdl.zig");

pub const IMG_INIT_JPG: c_int = 1;
pub const IMG_INIT_PNG: c_int = 2;
pub const IMG_INIT_TIF: c_int = 4;
pub const IMG_INIT_WEBP: c_int = 8;

pub extern fn IMG_Init(flags: c_int) c_int;
pub extern fn IMG_Quit() void;

pub extern fn IMG_LoadTexture(renderer: ?*sdl.SDL_Renderer, file: [*c]const u8) ?*sdl.SDL_Texture;
pub extern fn IMG_Load(file: [*:0]const u8) ?*sdl.SDL_Surface;
// https://www.libsdl.org/projects/SDL_image/docs/SDL_image_10.html#SEC10
// Automagic Loading
// - [X] IMG_Load	  	Load from a file
// - [X] IMG_Load_RW	  	Load using a SDL_RWop
// - [X] IMG_LoadTyped_RW	  	Load more format specifically with a SDL_RWop
// Specific Loaders
// - [X] IMG_LoadBMP_RW	  	Load BMP using a SDL_RWop
// - [ ] IMG_LoadCUR_RW	  	Load CUR using a SDL_RWop
// - [ ] IMG_LoadGIF_RW	  	Load GIF using a SDL_RWop
// - [ ] IMG_LoadICO_RW	  	Load ICO using a SDL_RWop
// - [X] IMG_LoadJPG_RW	  	Load JPG using a SDL_RWop
// - [ ] IMG_LoadLBM_RW	  	Load LBM using a SDL_RWop
// - [ ] IMG_LoadPCX_RW	  	Load PCX using a SDL_RWop
// - [ ] IMG_LoadPNG_RW	  	Load PNG using a SDL_RWop
// - [ ] IMG_LoadPNM_RW	  	Load PNM using a SDL_RWop
// - [ ] IMG_LoadTGA_RW	  	Load TGA using a SDL_RWop
// - [ ] IMG_LoadTIF_RW	  	Load TIF using a SDL_RWop
// - [ ] IMG_LoadXCF_RW	  	Load XCF using a SDL_RWop
// - [ ] IMG_LoadXPM_RW	  	Load XPM using a SDL_RWop
// - [ ] IMG_LoadXV_RW	  	Load XV using a SDL_RWop
// Array Loaders
// - [ ] IMG_ReadXPMFromArray	  	Load XPM from compiled XPM data
pub extern fn IMG_IMG_LoadTyped_RW(rw:*sdl.SDL_RWops, freesrc: c_int, type: [*:0]const u8) ?*sdl.SDL_Surface;
pub extern fn IMG_Load_RW(rw:*sdl.SDL_RWops, freesrc: c_int) ?*sdl.SDL_Surface; 
pub extern fn IMG_LoadBMP_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadCUR_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadGIF_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadICO_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadJPG_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadPNG_RW(rw: *sdl.SDL_RWops) ?*sdl.SDL_Surface;

pub const IMG_SetError = sdl.SDL_SetError;
pub const IMG_GetError = sdl.SDL_GetError;
