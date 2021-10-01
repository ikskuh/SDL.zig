const sdl = @import("sdl.zig");
const vk = @import("vulkan");

pub const SDL_vulkanInstance = vk.Instance;
pub const SDL_vulkanSurface = vk.SurfaceKHR;

pub extern fn SDL_Vulkan_LoadLibrary(path: [*:0]const u8) c_int;
pub extern fn SDL_Vulkan_GetVkGetInstanceProcAddr() ?vk.PfnGetInstanceProcAddr;
pub extern fn SDL_Vulkan_UnloadLibrary() void;
pub extern fn SDL_Vulkan_GetInstanceExtensions(window: *sdl.SDL_Window, pCount: *c_uint, pNames: ?[*][*:0]const u8) sdl.SDL_bool;
pub extern fn SDL_Vulkan_CreateSurface(window: *sdl.SDL_Window, instance: vk.Instance, surface: *vk.SurfaceKHR) sdl.SDL_bool;
pub extern fn SDL_Vulkan_GetDrawableSize(window: *sdl.SDL_Window, w: ?*c_int, h: ?*c_int) void;
