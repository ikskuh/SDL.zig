const sdl = @import("sdl.zig");
const std = @import("std");
const vk = @import("vulkan");

pub fn loadLibrary(path: ?[*:0]const u8) !void {
    const result = sdl.c.SDL_Vulkan_LoadLibrary(path);
    if (result != 0) return sdl.makeError();
}

pub const unloadLibrary = sdl.c.SDL_Vulkan_UnloadLibrary;

pub fn getVkGetInstanceProcAddr() !vk.PfnGetInstanceProcAddr {
    return sdl.c.SDL_Vulkan_GetVkGetInstanceProcAddr() orelse return sdl.makeError();
}

pub fn getInstanceExtensionsCount(window: ?sdl.Window) c_uint {
    const window_ptr = if (window) |window_v| window_v.ptr else null;
    var count: c_uint = 0;
    // The wiki isn't quite clear on whether this function returns true or false if pNames is null. Even if it was, it still isn't
    // quite up-to-date on whether window is allowed to be null (which it is, but the wiki still says "might be in the future").
    // I just hope ignoring the returned value is safe...
    _ = sdl.c.SDL_Vulkan_GetInstanceExtensions(window_ptr, &count, null);
    return count;
}

pub fn getInstanceExtensions(window: ?sdl.Window, dest: [][*:0]const u8) !c_uint {
    const window_ptr = if (window) |window_v| window_v.ptr else null;
    var count: c_uint = @intCast(dest.len);
    const result = sdl.c.SDL_Vulkan_GetInstanceExtensions(window_ptr, &count, dest.ptr);
    if (result == 0) return sdl.makeError();
    return count;
}

pub fn getInstanceExtensionsAlloc(window: ?sdl.Window, allocator: std.mem.Allocator) ![][*:0]const u8 {
    const count = getInstanceExtensionsCount(window);
    const slice = try allocator.alloc([*:0]const u8, count);
    errdefer allocator.free(slice);
    const actual_count = try getInstanceExtensions(window, slice);
    std.debug.assert(count == actual_count);
    return slice;
}

pub fn createSurface(window: sdl.Window, instance: vk.Instance) !vk.SurfaceKHR {
    var out: vk.SurfaceKHR = undefined;
    const result = sdl.c.SDL_Vulkan_CreateSurface(window.ptr, instance, &out);
    if (result == 0) return sdl.makeError();
    return out;
}

pub fn getDrawableSize(window: *sdl.Window) sdl.Size {
    var out: sdl.Size = undefined;
    sdl.c.SDL_Vulkan_GetDrawableSize(window.ptr, &out.width, &out.height);
    return out;
}
