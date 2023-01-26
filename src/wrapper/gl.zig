const sdl = @import("sdl.zig");
const std = @import("std");

pub const Context = struct {
    ptr: sdl.c.SDL_GLContext,
};

pub fn createContext(window: sdl.Window) !Context {
    return Context{
        .ptr = sdl.c.SDL_GL_CreateContext(window.ptr) orelse return sdl.makeError(),
    };
}

pub fn makeCurrent(context: Context, window: sdl.Window) !void {
    if (sdl.c.SDL_GL_MakeCurrent(window.ptr, context.ptr) != 0) {
        return sdl.makeError();
    }
}

pub fn deleteContext(context: Context) void {
    _ = sdl.c.SDL_GL_DeleteContext(context.ptr);
}

pub fn getProcAddress(proc: [:0]const u8) ?*const anyopaque {
    return sdl.c.SDL_GL_GetProcAddress(proc.ptr);
}

pub const SwapInterval = enum {
    immediate, // immediate updates
    vsync, // updates synchronized with the vertical retrace
    adaptive_vsync, // same as vsync, but if a frame is missed swaps buffers immediately
};

pub fn setSwapInterval(interval: SwapInterval) !void {
    if (sdl.c.SDL_GL_SetSwapInterval(switch (interval) {
        .immediate => 0,
        .vsync => 1,
        .adaptive_vsync => -1,
    }) != 0) {
        return sdl.makeError();
    }
}

pub fn swapWindow(window: sdl.Window) void {
    sdl.c.SDL_GL_SwapWindow(window.ptr);
}

pub fn getDrawableSize(window: sdl.Window) struct { w: u32, h: u32 } {
    var w: c_int = undefined;
    var h: c_int = undefined;
    sdl.c.SDL_GL_GetDrawableSize(window.ptr, &w, &h);
    return .{ .w = @intCast(u32, w), .h = @intCast(u32, h) };
}

fn attribValueToInt(value: anytype) c_int {
    return switch (@TypeOf(value)) {
        usize => @intCast(c_int, value),
        bool => if (value) @as(c_int, 1) else 0,
        ContextFlags => blk: {
            var result: c_int = 0;
            if (value.debug) {
                result |= sdl.c.SDL_GL_CONTEXT_DEBUG_FLAG;
            }
            if (value.forward_compatible) {
                result |= sdl.c.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG;
            }
            if (value.robust_access) {
                result |= sdl.c.SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG;
            }
            if (value.reset_isolation) {
                result |= sdl.c.SDL_GL_CONTEXT_RESET_ISOLATION_FLAG;
            }

            break :blk result;
        },
        Profile, ReleaseBehaviour => @enumToInt(value),
        else => @compileError("Unsupported type for sdl.gl.Attribute"),
    };
}

pub fn setAttribute(attrib: Attribute) !void {
    inline for (std.meta.fields(Attribute)) |fld| {
        if (attrib == @field(AttributeName, fld.name)) {
            const res = sdl.c.SDL_GL_SetAttribute(
                @intCast(sdl.c.SDL_GLattr, @enumToInt(attrib)),
                attribValueToInt(@field(attrib, fld.name)),
            );
            if (res != 0) {
                return sdl.makeError();
            } else {
                return;
            }
        }
    }
    unreachable;
}

pub const Attribute = union(AttributeName) {
    red_size: usize,
    green_size: usize,
    blue_size: usize,
    alpha_size: usize,
    buffer_size: usize,
    doublebuffer: bool,
    depth_size: usize,
    stencil_size: usize,
    accum_red_size: usize,
    accum_green_size: usize,
    accum_blue_size: usize,
    accum_alpha_size: usize,
    stereo: usize,
    multisamplebuffers: bool,
    multisamplesamples: usize,
    accelerated_visual: bool,
    context_major_version: usize,
    context_minor_version: usize,
    context_flags: ContextFlags,
    context_profile_mask: Profile,
    share_with_current_context: usize,
    framebuffer_srgb_capable: bool,
    context_release_behavior: ReleaseBehaviour,
};

pub const AttributeName = enum(c_int) {
    red_size = sdl.c.SDL_GL_RED_SIZE,
    green_size = sdl.c.SDL_GL_GREEN_SIZE,
    blue_size = sdl.c.SDL_GL_BLUE_SIZE,
    alpha_size = sdl.c.SDL_GL_ALPHA_SIZE,
    buffer_size = sdl.c.SDL_GL_BUFFER_SIZE,
    doublebuffer = sdl.c.SDL_GL_DOUBLEBUFFER,
    depth_size = sdl.c.SDL_GL_DEPTH_SIZE,
    stencil_size = sdl.c.SDL_GL_STENCIL_SIZE,
    accum_red_size = sdl.c.SDL_GL_ACCUM_RED_SIZE,
    accum_green_size = sdl.c.SDL_GL_ACCUM_GREEN_SIZE,
    accum_blue_size = sdl.c.SDL_GL_ACCUM_BLUE_SIZE,
    accum_alpha_size = sdl.c.SDL_GL_ACCUM_ALPHA_SIZE,
    stereo = sdl.c.SDL_GL_STEREO,
    multisamplebuffers = sdl.c.SDL_GL_MULTISAMPLEBUFFERS,
    multisamplesamples = sdl.c.SDL_GL_MULTISAMPLESAMPLES,
    accelerated_visual = sdl.c.SDL_GL_ACCELERATED_VISUAL,
    context_major_version = sdl.c.SDL_GL_CONTEXT_MAJOR_VERSION,
    context_minor_version = sdl.c.SDL_GL_CONTEXT_MINOR_VERSION,
    context_flags = sdl.c.SDL_GL_CONTEXT_FLAGS,
    context_profile_mask = sdl.c.SDL_GL_CONTEXT_PROFILE_MASK,
    share_with_current_context = sdl.c.SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
    framebuffer_srgb_capable = sdl.c.SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
    context_release_behavior = sdl.c.SDL_GL_CONTEXT_RELEASE_BEHAVIOR,
};

pub const ContextFlags = struct {
    debug: bool = false,
    forward_compatible: bool = false,
    robust_access: bool = false,
    reset_isolation: bool = false,
};

pub const Profile = enum(c_int) {
    core = sdl.c.SDL_GL_CONTEXT_PROFILE_CORE,
    compatibility = sdl.c.SDL_GL_CONTEXT_PROFILE_COMPATIBILITY,
    es = sdl.c.SDL_GL_CONTEXT_PROFILE_ES,
};

pub const ReleaseBehaviour = enum(c_int) {
    none = sdl.c.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE,
    flush = sdl.c.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH,
};
