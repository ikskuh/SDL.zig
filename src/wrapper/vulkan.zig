const sdl = @import("sdl.zig");
const vk = @import("vulkan");
const std = @import("std");

pub fn loadLibrary(path: []const u8) !void {
    if (sdl.c.SDL_Vulkan_LoadLibrary(path.ptr) < 0) return sdl.makeError();
}

pub fn unloadLibrary() void {
    sdl.c.SDL_Vulkan_UnloadLibrary();
}

pub fn getProcAddrFn() !vk.PfnGetInstanceProcAddr {
    return sdl.c.SDL_Vulkan_GetVkGetInstanceProcAddr() orelse return sdl.makeError();
}

pub fn getInstanceExtensions(allocator: *std.mem.Allocator, window: sdl.Window) ![][*:0]const u8 {
    var count: c_uint = undefined;
    if (sdl.c.SDL_Vulkan_GetInstanceExtensions(window.ptr, &count, null) == sdl.c.SDL_FALSE) return sdl.makeError();
    const extensions = try allocator.alloc([*:0]const u8, count);
    errdefer allocator.free(extensions);
    if (sdl.c.SDL_Vulkan_GetInstanceExtensions(window.ptr, &count, extensions.ptr) == sdl.c.SDL_FALSE) return sdl.makeError();
    return extensions;
}

pub fn createSurface(window: sdl.Window, instance: vk.Instance) !vk.SurfaceKHR {
    var surface: vk.SurfaceKHR = undefined;
    if (sdl.c.SDL_Vulkan_CreateSurface(window.ptr, instance, &surface) == sdl.c.SDL_FALSE) return sdl.makeError();
    return surface;
}

pub fn getDrawableSize(window: sdl.Window) sdl.Size {
    var output: sdl.Size = undefined;
    sdl.c.SDL_Vulkan_GetDrawableSize(window.ptr, &output.width, &output.height);
    return output;
}
