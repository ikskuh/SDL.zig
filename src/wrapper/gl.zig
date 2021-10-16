const SDL = @import("sdl.zig");
const c = @import("../binding/sdl.zig");
const std = @import("std");

pub const Context = struct {
    ptr: c.SDL_GLContext,
};

pub fn createContext(window: SDL.Window) !Context {
    return Context{
        .ptr = c.SDL_GL_CreateContext(window.ptr) orelse return SDL.makeError(),
    };
}

pub fn makeCurrent(context: Context, window: SDL.Window) !void {
    if (c.SDL_GL_MakeCurrent(window.ptr, context.ptr) != 0) {
        return SDL.makeError();
    }
}

pub fn deleteContext(context: Context) void {
    _ = c.SDL_GL_DeleteContext(context.ptr);
}

pub const SwapInterval = enum {
    immediate, // immediate updates
    vsync, // updates synchronized with the vertical retrace
    adaptive_vsync, // same as vsync, but if a frame is missed swaps buffers immediately
};

pub fn setSwapInterval(interval: SwapInterval) !void {
    if (c.SDL_GL_SetSwapInterval(switch (interval) {
        .immediate => 0,
        .vsync => 1,
        .adaptive_vsync => -1,
    }) != 0) {
        return SDL.makeError();
    }
}

pub fn swapWindow(window: SDL.Window) void {
    c.SDL_GL_SwapWindow(window.ptr);
}

fn attribValueToInt(value: anytype) c_int {
    return switch (@TypeOf(value)) {
        usize => @intCast(c_int, value),
        bool => if (value) @as(c_int, 1) else 0,
        ContextFlags => blk: {
            var result: c_int = 0;
            if (value.debug) {
                result |= c.SDL_GL_CONTEXT_DEBUG_FLAG;
            }
            if (value.forward_compatible) {
                result |= c.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG;
            }
            if (value.robust_access) {
                result |= c.SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG;
            }
            if (value.reset_isolation) {
                result |= c.SDL_GL_CONTEXT_RESET_ISOLATION_FLAG;
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
            const res = c.SDL_GL_SetAttribute(
                @intCast(c.SDL_GLattr, @enumToInt(attrib)),
                attribValueToInt(@field(attrib, fld.name)),
            );
            if (res != 0) {
                return SDL.makeError();
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
    doublebuffer: usize,
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
    red_size = c.SDL_GL_RED_SIZE,
    green_size = c.SDL_GL_GREEN_SIZE,
    blue_size = c.SDL_GL_BLUE_SIZE,
    alpha_size = c.SDL_GL_ALPHA_SIZE,
    buffer_size = c.SDL_GL_BUFFER_SIZE,
    doublebuffer = c.SDL_GL_DOUBLEBUFFER,
    depth_size = c.SDL_GL_DEPTH_SIZE,
    stencil_size = c.SDL_GL_STENCIL_SIZE,
    accum_red_size = c.SDL_GL_ACCUM_RED_SIZE,
    accum_green_size = c.SDL_GL_ACCUM_GREEN_SIZE,
    accum_blue_size = c.SDL_GL_ACCUM_BLUE_SIZE,
    accum_alpha_size = c.SDL_GL_ACCUM_ALPHA_SIZE,
    stereo = c.SDL_GL_STEREO,
    multisamplebuffers = c.SDL_GL_MULTISAMPLEBUFFERS,
    multisamplesamples = c.SDL_GL_MULTISAMPLESAMPLES,
    accelerated_visual = c.SDL_GL_ACCELERATED_VISUAL,
    context_major_version = c.SDL_GL_CONTEXT_MAJOR_VERSION,
    context_minor_version = c.SDL_GL_CONTEXT_MINOR_VERSION,
    context_flags = c.SDL_GL_CONTEXT_FLAGS,
    context_profile_mask = c.SDL_GL_CONTEXT_PROFILE_MASK,
    share_with_current_context = c.SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
    framebuffer_srgb_capable = c.SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
    context_release_behavior = c.SDL_GL_CONTEXT_RELEASE_BEHAVIOR,
};

pub const ContextFlags = struct {
    debug: bool = false,
    forward_compatible: bool = false,
    robust_access: bool = false,
    reset_isolation: bool = false,
};

pub const Profile = enum(c_int) {
    core = c.SDL_GL_CONTEXT_PROFILE_CORE,
    compatibility = c.SDL_GL_CONTEXT_PROFILE_COMPATIBILITY,
    es = c.SDL_GL_CONTEXT_PROFILE_ES,
};

pub const ReleaseBehaviour = enum(c_int) {
    none = c.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE,
    flush = c.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH,
};
