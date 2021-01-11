const sdl = @import("sdl.zig");

const SDL_RWops = sdl.SDL_RWops;

pub const SDL_IMAGE_MAJOR_VERSION = 2;
pub const SDL_IMAGE_MINOR_VERSION = 0;
pub const SDL_IMAGE_PATCHLEVEL = 4;

pub fn SDL_IMAGE_VERSION(vers: *sdl.SDL_version) void {
    vers.major = SDL_IMAGE_MAJOR_VERSION;
    vers.minor = SDL_IMAGE_MINOR_VERSION;
    vers.patch = SDL_IMAGE_PATCHLEVEL;
}

pub const SDL_IMAGE_COMPILEDVERSION = SDL_VERSIONNUM(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_PATCHLEVEL);

pub fn SDL_IMAGE_VERSION_ATLEAST(X: anytype, Y: anytype, Z: anytype) bool {
    return (SDL_IMAGE_COMPILEDVERSION >= SDL_VERSIONNUM(X, Y, Z));
}

pub extern fn IMG_Linked_Version(void) callconv(.C) *const sdl.SDL_version;

pub const IMG_InitFlags = extern enum {
    IMG_INIT_JPG = 0x00000001, IMG_INIT_PNG = 0x00000002, IMG_INIT_TIF = 0x00000004, IMG_INIT_WEBP = 0x00000008
};

pub const IMG_INIT_JPG = @enumToInt(IMG_InitFlags.IMG_INIT_JPG);
pub const IMG_INIT_PNG = @enumToInt(IMG_InitFlags.IMG_INIT_PNG);
pub const IMG_INIT_TIF = @enumToInt(IMG_InitFlags.IMG_INIT_TIF);
pub const IMG_INIT_WEBP = @enumToInt(IMG_InitFlags.IMG_INIT_WEBP);

pub extern fn IMG_Init(flags: c_int) c_int;

pub extern fn IMG_Quit() void;

pub extern fn IMG_LoadTyped_RW(src: *SDL_RWops, freesrc: c_int, type: [*:0]const u8) ?*sdl.SDL_Surface;
pub extern fn IMG_Load(file: [*:0]const u8) ?*sdl.SDL_Surface;
pub extern fn IMG_Load_RW(src: *SDL_RWops, freesrc: c_int) ?*sdl.SDL_Surface;

pub extern fn IMG_LoadTexture(renderer: *sdl.SDL_Renderer, file: [*:0]const u8) ?*sdl.SDL_Texture;
pub extern fn IMG_LoadTexture_RW(renderer: *sdl.SDL_Renderer, src: *SDL_RWops, freesrc: c_int) ?*sdl.SDL_Texture;
pub extern fn IMG_LoadTextureTyped_RW(renderer: *sdl.SDL_Renderer, src: *SDL_RWops, freesrc: c_int, type: [*:0]const u8) ?*sdl.SDL_Texture;

pub extern fn IMG_isICO(src: *SDL_RWops) c_int;
pub extern fn IMG_isCUR(src: *SDL_RWops) c_int;
pub extern fn IMG_isBMP(src: *SDL_RWops) c_int;
pub extern fn IMG_isGIF(src: *SDL_RWops) c_int;
pub extern fn IMG_isJPG(src: *SDL_RWops) c_int;
pub extern fn IMG_isLBM(src: *SDL_RWops) c_int;
pub extern fn IMG_isPCX(src: *SDL_RWops) c_int;
pub extern fn IMG_isPNG(src: *SDL_RWops) c_int;
pub extern fn IMG_isPNM(src: *SDL_RWops) c_int;
pub extern fn IMG_isSVG(src: *SDL_RWops) c_int;
pub extern fn IMG_isTIF(src: *SDL_RWops) c_int;
pub extern fn IMG_isXCF(src: *SDL_RWops) c_int;
pub extern fn IMG_isXPM(src: *SDL_RWops) c_int;
pub extern fn IMG_isXV(src: *SDL_RWops) c_int;
pub extern fn IMG_isWEBP(src: *SDL_RWops) c_int;

pub extern fn IMG_LoadICO_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadCUR_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadBMP_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadGIF_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadJPG_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadLBM_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadPCX_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadPNG_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadPNM_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadSVG_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadTGA_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadTIF_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadXCF_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadXPM_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadXV_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;
pub extern fn IMG_LoadWEBP_RW(src: *SDL_RWops) ?*sdl.SDL_Surface;

pub extern fn IMG_ReadXPMFromArray(xpm: [*]const [*:0]const u8) ?*sdl.SDL_Surface;

pub extern fn IMG_SavePNG(surface: *sdl.SDL_Surface, file: [*:0]const u8) c_int;
pub extern fn IMG_SavePNG_RW(surface: *sdl.SDL_Surface, dst: *sdl.SDL_RWops, freedst: c_int) c_int;
pub extern fn IMG_SaveJPG(surface: *sdl.SDL_Surface, file: [*:0]const u8, quality: c_int) c_int;
pub extern fn IMG_SaveJPG_RW(surface: *sdl.SDL_Surface, dst: *sdl.SDL_RWops, freedst: c_int, quality: c_int) c_int;

pub const IMG_SetError = sdl.SDL_SetError;
pub const IMG_GetError = sdl.SDL_GetError;
