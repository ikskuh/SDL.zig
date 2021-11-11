const std = @import("std");

/// Exports the C interface for SDL
pub const c = @import("sdl-native");

// pub const image = @import("image.zig");
pub const gl = @import("gl.zig");

pub const Error = error{SdlError};

const log = std.log.scoped(.sdl2);

pub fn makeError() error{SdlError} {
    if (c.SDL_GetError()) |ptr| {
        log.debug("{s}\n", .{
            std.mem.span(ptr),
        });
    }
    return error.SdlError;
}

pub const Rectangle = extern struct {
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,

    fn getSdlPtr(r: *Rectangle) *c.SDL_Rect {
        return @ptrCast(*c.SDL_Rect, r);
    }
    fn getConstSdlPtr(r: Rectangle) *const c.SDL_Rect {
        return @ptrCast(*const c.SDL_Rect, &r);
    }
};

pub const Point = extern struct {
    x: c_int,
    y: c_int,
};

pub const Size = extern struct {
    width: c_int,
    height: c_int,
};

pub const Color = extern struct {
    pub const black = rgb(0x00, 0x00, 0x00);
    pub const white = rgb(0xFF, 0xFF, 0xFF);
    pub const red = rgb(0xFF, 0x00, 0x00);
    pub const green = rgb(0x00, 0xFF, 0x00);
    pub const blue = rgb(0x00, 0x00, 0xFF);
    pub const magenta = rgb(0xFF, 0x00, 0xFF);
    pub const cyan = rgb(0x00, 0xFF, 0xFF);
    pub const yellow = rgb(0xFF, 0xFF, 0x00);

    r: u8,
    g: u8,
    b: u8,
    a: u8,

    /// returns a initialized color struct with alpha = 255
    pub fn rgb(r: u8, g: u8, b: u8) Color {
        return Color{ .r = r, .g = g, .b = b, .a = 255 };
    }

    /// returns a initialized color struct
    pub fn rgba(r: u8, g: u8, b: u8, a: u8) Color {
        return Color{ .r = r, .g = g, .b = b, .a = a };
    }

    /// parses a hex string color literal.
    /// allowed formats are:
    /// - `RGB`
    /// - `RGBA`
    /// - `#RGB`
    /// - `#RGBA`
    /// - `RRGGBB`
    /// - `#RRGGBB`
    /// - `RRGGBBAA`
    /// - `#RRGGBBAA`
    pub fn parse(str: []const u8) error{
        UnknownFormat,
        InvalidCharacter,
        Overflow,
    }!Color {
        switch (str.len) {
            // RGB
            3 => {
                const r = try std.fmt.parseInt(u8, str[0..1], 16);
                const g = try std.fmt.parseInt(u8, str[1..2], 16);
                const b = try std.fmt.parseInt(u8, str[2..3], 16);

                return rgb(
                    r | (r << 4),
                    g | (g << 4),
                    b | (b << 4),
                );
            },

            // #RGB, RGBA
            4 => {
                if (str[0] == '#')
                    return parse(str[1..]);

                const r = try std.fmt.parseInt(u8, str[0..1], 16);
                const g = try std.fmt.parseInt(u8, str[1..2], 16);
                const b = try std.fmt.parseInt(u8, str[2..3], 16);
                const a = try std.fmt.parseInt(u8, str[3..4], 16);

                // bit-expand the patters to a uniform range
                return rgba(
                    r | (r << 4),
                    g | (g << 4),
                    b | (b << 4),
                    a | (a << 4),
                );
            },

            // #RGBA
            5 => return parse(str[1..]),

            // RRGGBB
            6 => {
                const r = try std.fmt.parseInt(u8, str[0..2], 16);
                const g = try std.fmt.parseInt(u8, str[2..4], 16);
                const b = try std.fmt.parseInt(u8, str[4..6], 16);

                return rgb(r, g, b);
            },

            // #RRGGBB
            7 => return parse(str[1..]),

            // RRGGBBAA
            8 => {
                const r = try std.fmt.parseInt(u8, str[0..2], 16);
                const g = try std.fmt.parseInt(u8, str[2..4], 16);
                const b = try std.fmt.parseInt(u8, str[4..6], 16);
                const a = try std.fmt.parseInt(u8, str[6..8], 16);

                return rgba(r, g, b, a);
            },

            // #RRGGBBAA
            9 => return parse(str[1..]),

            else => return error.UnknownFormat,
        }
    }
};

pub const InitFlags = struct {
    pub const everything = InitFlags{
        .video = true,
        .audio = true,
        .timer = true,
        .joystick = true,
        .haptic = true,
        .game_controller = true,
        .events = true,
    };
    video: bool = false,
    audio: bool = false,
    timer: bool = false,
    joystick: bool = false,
    haptic: bool = false,
    game_controller: bool = false,
    events: bool = false,
};

pub fn init(flags: InitFlags) !void {
    var cflags: c_uint = 0;
    if (flags.video) cflags |= c.SDL_INIT_VIDEO;
    if (flags.audio) cflags |= c.SDL_INIT_AUDIO;
    if (flags.timer) cflags |= c.SDL_INIT_TIMER;
    if (flags.joystick) cflags |= c.SDL_INIT_JOYSTICK;
    if (flags.haptic) cflags |= c.SDL_INIT_HAPTIC;
    if (flags.game_controller) cflags |= c.SDL_INIT_GAMECONTROLLER;
    if (flags.events) cflags |= c.SDL_INIT_EVENTS;
    if (c.SDL_Init(cflags) < 0)
        return makeError();
}

pub fn quit() void {
    c.SDL_Quit();
}

pub fn getError() ?[]const u8 {
    if (c.SDL_GetError()) |err| {
        return std.mem.spanZ(err);
    } else {
        return null;
    }
}

pub const Window = struct {
    ptr: *c.SDL_Window,

    pub fn fromID(wid: u32) ?Window {
        return if (c.SDL_GetWindowFromID(wid)) |ptr|
            Window{ .ptr = ptr }
        else
            null;
    }

    pub fn destroy(w: Window) void {
        c.SDL_DestroyWindow(w.ptr);
    }

    pub fn getSize(w: Window) Size {
        var s: Size = undefined;
        c.SDL_GetWindowSize(w.ptr, &s.width, &s.height);
        return s;
    }

    pub fn getSurface(w: Window) !Surface {
        var surface_ptr = c.SDL_GetWindowSurface(w.ptr) orelse return makeError();
        return Surface{ .ptr = surface_ptr };
    }

    pub fn updateSurface(w: Window) !void {
        if (c.SDL_UpdateWindowSurface(w.ptr) < 0) return makeError();
    }
};

pub const WindowPosition = union(enum) {
    default: void,
    centered: void,
    absolute: c_int,
};

pub const WindowFlags = struct {
    /// fullscreen window
    fullscreen: bool = false, // SDL_WINDOW_FULLSCREEN,

    /// fullscreen window at the current desktop resolution,
    fullscreen_desktop: bool = false, // SDL_WINDOW_FULLSCREEN_DESKTOP

    /// window usable with OpenGL context
    opengl: bool = false, //  SDL_WINDOW_OPENGL,

    /// window is visible,
    shown: bool = false, //  SDL_WINDOW_SHOWN,

    /// window is not visible
    hidden: bool = false, //  SDL_WINDOW_HIDDEN,

    /// no window decoration
    borderless: bool = false, // SDL_WINDOW_BORDERLESS,

    /// window can be resized
    resizable: bool = false, // SDL_WINDOW_RESIZABLE,

    /// window is minimized
    minimized: bool = false, // SDL_WINDOW_MINIMIZED,

    /// window is maximized
    maximized: bool = false, // SDL_WINDOW_MAXIMIZED,

    ///  window has grabbed input focus
    input_grabbed: bool = false, // SDL_WINDOW_INPUT_GRABBED,

    /// window has input focus
    input_focus: bool = false, //SDL_WINDOW_INPUT_FOCUS,

    ///  window has mouse focus
    mouse_focus: bool = false, //SDL_WINDOW_MOUSE_FOCUS,

    /// window not created by SDL
    foreign: bool = false, //SDL_WINDOW_FOREIGN,

    /// window should be created in high-DPI mode if supported (>= SDL 2.0.1)
    allow_high_dpi: bool = false, //SDL_WINDOW_ALLOW_HIGHDPI,

    /// window has mouse captured (unrelated to INPUT_GRABBED, >= SDL 2.0.4)
    mouse_capture: bool = false, //SDL_WINDOW_MOUSE_CAPTURE,

    /// window should always be above others (X11 only, >= SDL 2.0.5)
    always_on_top: bool = false, //SDL_WINDOW_ALWAYS_ON_TOP,

    /// window should not be added to the taskbar (X11 only, >= SDL 2.0.5)
    skip_taskbar: bool = false, //SDL_WINDOW_SKIP_TASKBAR,

    /// window should be treated as a utility window (X11 only, >= SDL 2.0.5)
    utility: bool = false, //SDL_WINDOW_UTILITY,

    /// window should be treated as a tooltip (X11 only, >= SDL 2.0.5)
    tooltip: bool = false, //SDL_WINDOW_TOOLTIP,

    /// window should be treated as a popup menu (X11 only, >= SDL 2.0.5)
    popup_menu: bool = false, //SDL_WINDOW_POPUP_MENU,

    // fn fromInteger(val: c_uint) WindowFlags {
    //     // TODO: Implement
    //     @panic("niy");
    // }

    fn toInteger(wf: WindowFlags) c_int {
        var val: c_int = 0;
        if (wf.fullscreen) val |= c.SDL_WINDOW_FULLSCREEN;
        if (wf.fullscreen_desktop) val |= c.SDL_WINDOW_FULLSCREEN_DESKTOP;
        if (wf.opengl) val |= c.SDL_WINDOW_OPENGL;
        if (wf.shown) val |= c.SDL_WINDOW_SHOWN;
        if (wf.hidden) val |= c.SDL_WINDOW_HIDDEN;
        if (wf.borderless) val |= c.SDL_WINDOW_BORDERLESS;
        if (wf.resizable) val |= c.SDL_WINDOW_RESIZABLE;
        if (wf.minimized) val |= c.SDL_WINDOW_MINIMIZED;
        if (wf.maximized) val |= c.SDL_WINDOW_MAXIMIZED;
        if (wf.input_grabbed) val |= c.SDL_WINDOW_INPUT_GRABBED;
        if (wf.input_focus) val |= c.SDL_WINDOW_INPUT_FOCUS;
        if (wf.mouse_focus) val |= c.SDL_WINDOW_MOUSE_FOCUS;
        if (wf.foreign) val |= c.SDL_WINDOW_FOREIGN;
        if (wf.allow_high_dpi) val |= c.SDL_WINDOW_ALLOW_HIGHDPI;
        if (wf.mouse_capture) val |= c.SDL_WINDOW_MOUSE_CAPTURE;
        if (wf.always_on_top) val |= c.SDL_WINDOW_ALWAYS_ON_TOP;
        if (wf.skip_taskbar) val |= c.SDL_WINDOW_SKIP_TASKBAR;
        if (wf.utility) val |= c.SDL_WINDOW_UTILITY;
        if (wf.tooltip) val |= c.SDL_WINDOW_TOOLTIP;
        if (wf.popup_menu) val |= c.SDL_WINDOW_POPUP_MENU;
        return val;
    }
};

pub fn createWindow(
    title: [:0]const u8,
    x: WindowPosition,
    y: WindowPosition,
    width: usize,
    height: usize,
    flags: WindowFlags,
) !Window {
    return Window{
        .ptr = c.SDL_CreateWindow(
            title,
            switch (x) {
                .default => c.SDL_WINDOWPOS_UNDEFINED_MASK,
                .centered => c.SDL_WINDOWPOS_CENTERED_MASK,
                .absolute => |v| v,
            },
            switch (y) {
                .default => c.SDL_WINDOWPOS_UNDEFINED_MASK,
                .centered => c.SDL_WINDOWPOS_CENTERED_MASK,
                .absolute => |v| v,
            },
            @intCast(c_int, width),
            @intCast(c_int, height),
            @intCast(u32, flags.toInteger()),
        ) orelse return makeError(),
    };
}

pub const Surface = struct {
    ptr: *c.SDL_Surface,

    pub fn destroy(s: Surface) void {
        c.SDL_FreeSurface(s.ptr);
    }

    pub fn setColorKey(s: Surface, flag: c_int, color: Color) !void {
        if (c.SDL_SetColorKey(s.ptr, flag, c.SDL_MapRGBA(s.ptr.*.format, color.r, color.g, color.b, color.a)) < 0) return makeError();
    }

    pub fn fillRect(s: *Surface, rect: ?*Rectangle, color: Color) !void {
        const rect_ptr = if (rect) |_rect| _rect.getSdlPtr() else null;
        if (c.SDL_FillRect(s.ptr, rect_ptr, c.SDL_MapRGBA(s.ptr.*.format, color.r, color.g, color.b, color.a)) < 0) return makeError();
    }
};

pub fn createRgbSurfaceWithFormat(width: u31, height: u31, bit_depth: u31, format: PixelFormatEnum) !Surface {
    return Surface{ .ptr = c.SDL_CreateRGBSurfaceWithFormat(0, width, height, bit_depth, @enumToInt(format)) orelse return error.SdlError };
}

pub fn blitScaled(src: Surface, src_rectangle: ?*Rectangle, dest: Surface, dest_rectangle: ?*Rectangle) !void {
    if (c.SDL_BlitScaled(
        src.ptr,
        if (src_rectangle) |rect| rect.getSdlPtr() else null,
        dest.ptr,
        if (dest_rectangle) |rect| rect.getSdlPtr() else null,
    ) < 0) return error.SdlError;
}

pub const Renderer = struct {
    ptr: *c.SDL_Renderer,

    pub fn destroy(ren: Renderer) void {
        c.SDL_DestroyRenderer(ren.ptr);
    }

    pub fn clear(ren: Renderer) !void {
        if (c.SDL_RenderClear(ren.ptr) != 0)
            return makeError();
    }

    pub fn present(ren: Renderer) void {
        c.SDL_RenderPresent(ren.ptr);
    }

    pub fn copy(ren: Renderer, tex: Texture, dstRect: ?Rectangle, srcRect: ?Rectangle) !void {
        if (c.SDL_RenderCopy(ren.ptr, tex.ptr, if (srcRect) |r| r.getConstSdlPtr() else null, if (dstRect) |r| r.getConstSdlPtr() else null) < 0)
            return makeError();
    }

    pub fn drawLine(ren: Renderer, x0: i32, y0: i32, x1: i32, y1: i32) !void {
        if (c.SDL_RenderDrawLine(ren.ptr, x0, y0, x1, y1) < 0)
            return makeError();
    }

    pub fn drawPoint(ren: Renderer, x: i32, y: i32) !void {
        if (c.SDL_RenderDrawPoint(ren.ptr, x, y) < 0)
            return makeError();
    }

    pub fn fillRect(ren: Renderer, rect: Rectangle) !void {
        if (c.SDL_RenderFillRect(ren.ptr, rect.getConstSdlPtr()) < 0)
            return makeError();
    }

    pub fn drawRect(ren: Renderer, rect: Rectangle) !void {
        if (c.SDL_RenderDrawRect(ren.ptr, rect.getConstSdlPtr()) < 0)
            return makeError();
    }

    pub fn setColor(ren: Renderer, color: Color) !void {
        if (c.SDL_SetRenderDrawColor(ren.ptr, color.r, color.g, color.b, color.a) < 0)
            return makeError();
    }

    pub fn setColorRGB(ren: Renderer, r: u8, g: u8, b: u8) !void {
        if (c.SDL_SetRenderDrawColor(ren.ptr, r, g, b, 255) < 0)
            return makeError();
    }

    pub fn setColorRGBA(ren: Renderer, r: u8, g: u8, b: u8, a: u8) !void {
        if (c.SDL_SetRenderDrawColor(ren.ptr, r, g, b, a) < 0)
            return makeError();
    }

    pub fn setDrawBlendMode(ren: Renderer, blendMode: c.SDL_BlendMode) !void {
        if (c.SDL_SetRenderDrawBlendMode(ren.ptr, blendMode) < 0)
            return makeError();
    }
};

pub const RendererFlags = struct {
    software: bool = false,
    accelerated: bool = false,
    present_vsync: bool = false,
    target_texture: bool = false,

    fn toInteger(rf: RendererFlags) c_int {
        var val: c_int = 0;
        if (rf.software) val |= c.SDL_RENDERER_SOFTWARE;
        if (rf.accelerated) val |= c.SDL_RENDERER_ACCELERATED;
        if (rf.present_vsync) val |= c.SDL_RENDERER_PRESENTVSYNC;
        if (rf.target_texture) val |= c.SDL_RENDERER_TARGETTEXTURE;
        return val;
    }
};

pub fn createRenderer(window: Window, index: ?u31, flags: RendererFlags) !Renderer {
    return Renderer{
        .ptr = c.SDL_CreateRenderer(
            window.ptr,
            if (index) |idx| @intCast(c_int, idx) else -1,
            @intCast(u32, flags.toInteger()),
        ) orelse return makeError(),
    };
}

pub const Texture = struct {
    pub const PixelData = struct {
        texture: *c.SDL_Texture,
        pixels: [*]u8,
        stride: usize,

        pub fn scanline(self: *@This(), y: usize, comptime Pixel: type) [*]Pixel {
            return @ptrCast([*]Pixel, self.pixels + y * self.stride);
        }

        pub fn release(self: *@This()) void {
            c.SDL_UnlockTexture(self.texture);
            self.* = undefined;
        }
    };

    ptr: *c.SDL_Texture,

    pub fn destroy(tex: Texture) void {
        c.SDL_DestroyTexture(tex.ptr);
    }

    pub fn lock(tex: Texture, rectangle: ?Rectangle) !PixelData {
        var ptr: ?*c_void = undefined;
        var pitch: c_int = undefined;
        if (c.SDL_LockTexture(
            tex.ptr,
            if (rectangle) |rect| rect.getConstSdlPtr() else null,
            &ptr,
            &pitch,
        ) != 0) {
            return makeError();
        }
        return PixelData{
            .texture = tex.ptr,
            .stride = @intCast(usize, pitch),
            .pixels = @ptrCast([*]u8, ptr),
        };
    }

    pub fn update(texture: Texture, pixels: []const u8, pitch: usize, rectangle: ?Rectangle) !void {
        if (c.SDL_UpdateTexture(
            texture.ptr,
            if (rectangle) |rect| rect.getConstSdlPtr() else null,
            pixels.ptr,
            @intCast(c_int, pitch),
        ) != 0)
            return makeError();
    }

    const Info = struct {
        width: usize,
        height: usize,
        access: Access,
        format: PixelFormatEnum,
    };

    pub fn query(tex: Texture) !Info {
        var format: u32 = undefined;
        var w: c_int = undefined;
        var h: c_int = undefined;
        var access: c_int = undefined;
        if (c.SDL_QueryTexture(tex.ptr, &format, &access, &w, &h) < 0)
            return makeError();
        return Info{
            .width = @intCast(usize, w),
            .height = @intCast(usize, h),
            .access = @intToEnum(Access, access),
            .format = @intToEnum(PixelFormatEnum, format),
        };
    }
    pub fn resetColorMod(tex: Texture) !void {
        try tex.setColorMod(Color.white);
    }

    pub fn setColorMod(tex: Texture, color: Color) !void {
        if (c.SDL_SetTextureColorMod(tex.ptr, color.r, color.g, color.b) < 0)
            return makeError();
        if (c.SDL_SetTextureAlphaMod(tex.ptr, color.a) < 0)
            return makeError();
    }

    pub fn setColorModRGB(tex: Texture, r: u8, g: u8, b: u8) !void {
        try tex.setColorMod(Color.rgb(r, g, b));
    }

    pub fn setColorModRGBA(tex: Texture, r: u8, g: u8, b: u8, a: u8) !void {
        try tex.setColorMod(Color.rgba(r, g, b, a));
    }

    pub const Format = PixelFormatEnum;

    pub const Access = enum(c_int) {
        static = c.SDL_TEXTUREACCESS_STATIC,
        streaming = c.SDL_TEXTUREACCESS_STREAMING,
        target = c.SDL_TEXTUREACCESS_TARGET,
    };
};

pub const PixelFormatEnum = enum(u32) {
    index1_lsb = c.SDL_PIXELFORMAT_INDEX1LSB,
    index1_msb = c.SDL_PIXELFORMAT_INDEX1MSB,
    index4_lsb = c.SDL_PIXELFORMAT_INDEX4LSB,
    index4_msb = c.SDL_PIXELFORMAT_INDEX4MSB,
    index8 = c.SDL_PIXELFORMAT_INDEX8,
    rgb332 = c.SDL_PIXELFORMAT_RGB332,
    rgb444 = c.SDL_PIXELFORMAT_RGB444,
    rgb555 = c.SDL_PIXELFORMAT_RGB555,
    bgr555 = c.SDL_PIXELFORMAT_BGR555,
    argb4444 = c.SDL_PIXELFORMAT_ARGB4444,
    rgba4444 = c.SDL_PIXELFORMAT_RGBA4444,
    abgr4444 = c.SDL_PIXELFORMAT_ABGR4444,
    bgra4444 = c.SDL_PIXELFORMAT_BGRA4444,
    argb1555 = c.SDL_PIXELFORMAT_ARGB1555,
    rgba5551 = c.SDL_PIXELFORMAT_RGBA5551,
    abgr1555 = c.SDL_PIXELFORMAT_ABGR1555,
    bgra5551 = c.SDL_PIXELFORMAT_BGRA5551,
    rgb565 = c.SDL_PIXELFORMAT_RGB565,
    bgr565 = c.SDL_PIXELFORMAT_BGR565,
    rgb24 = c.SDL_PIXELFORMAT_RGB24,
    bgr24 = c.SDL_PIXELFORMAT_BGR24,
    rgb888 = c.SDL_PIXELFORMAT_RGB888,
    rgbx8888 = c.SDL_PIXELFORMAT_RGBX8888,
    bgr888 = c.SDL_PIXELFORMAT_BGR888,
    bgrx8888 = c.SDL_PIXELFORMAT_BGRX8888,
    argb8888 = c.SDL_PIXELFORMAT_ARGB8888,
    rgba8888 = c.SDL_PIXELFORMAT_RGBA8888,
    abgr8888 = c.SDL_PIXELFORMAT_ABGR8888,
    bgra8888 = c.SDL_PIXELFORMAT_BGRA8888,
    argb2101010 = c.SDL_PIXELFORMAT_ARGB2101010,
    yv12 = c.SDL_PIXELFORMAT_YV12,
    iyuv = c.SDL_PIXELFORMAT_IYUV,
    yuy2 = c.SDL_PIXELFORMAT_YUY2,
    uyvy = c.SDL_PIXELFORMAT_UYVY,
    yvyu = c.SDL_PIXELFORMAT_YVYU,
    nv12 = c.SDL_PIXELFORMAT_NV12,
    nv21 = c.SDL_PIXELFORMAT_NV21,
    externalOES = c.SDL_PIXELFORMAT_EXTERNAL_OES,
};

pub fn createTexture(renderer: Renderer, format: PixelFormatEnum, access: Texture.Access, width: usize, height: usize) !Texture {
    const texptr = c.SDL_CreateTexture(
        renderer.ptr,
        @enumToInt(format),
        @enumToInt(access),
        @intCast(c_int, width),
        @intCast(c_int, height),
    ) orelse return makeError();
    return Texture{
        .ptr = texptr,
    };
}

pub fn createTextureFromSurface(renderer: Renderer, surface: Surface) !Texture {
    const texptr = c.SDL_CreateTextureFromSurface(
        renderer.ptr,
        surface.ptr,
    ) orelse return makeError();
    return Texture{
        .ptr = texptr,
    };
}

pub const WindowEvent = struct {
    const Type = enum(u8) {
        none = c.SDL_WINDOWEVENT_NONE,
        shown = c.SDL_WINDOWEVENT_SHOWN,
        hidden = c.SDL_WINDOWEVENT_HIDDEN,
        exposed = c.SDL_WINDOWEVENT_EXPOSED,
        moved = c.SDL_WINDOWEVENT_MOVED,
        resized = c.SDL_WINDOWEVENT_RESIZED,
        size_changed = c.SDL_WINDOWEVENT_SIZE_CHANGED,
        minimized = c.SDL_WINDOWEVENT_MINIMIZED,
        maximized = c.SDL_WINDOWEVENT_MAXIMIZED,
        restored = c.SDL_WINDOWEVENT_RESTORED,
        enter = c.SDL_WINDOWEVENT_ENTER,
        leave = c.SDL_WINDOWEVENT_LEAVE,
        focus_gained = c.SDL_WINDOWEVENT_FOCUS_GAINED,
        focus_lost = c.SDL_WINDOWEVENT_FOCUS_LOST,
        close = c.SDL_WINDOWEVENT_CLOSE,
        take_focus = c.SDL_WINDOWEVENT_TAKE_FOCUS,
        hit_test = c.SDL_WINDOWEVENT_HIT_TEST,

        _,
    };

    const Data = union(Type) {
        shown: void,
        hidden: void,
        exposed: void,
        moved: Point,
        resized: Size,
        size_changed: Size,
        minimized: void,
        maximized: void,
        restored: void,
        enter: void,
        leave: void,
        focus_gained: void,
        focus_lost: void,
        close: void,
        take_focus: void,
        hit_test: void,
        none: void,
    };

    timestamp: u32,
    window_id: u32,
    type: Data,

    fn fromNative(ev: c.SDL_WindowEvent) WindowEvent {
        return WindowEvent{
            .timestamp = ev.timestamp,
            .window_id = ev.windowID,
            .type = switch (@intToEnum(Type, ev.event)) {
                .shown => Data{ .shown = {} },
                .hidden => Data{ .hidden = {} },
                .exposed => Data{ .exposed = {} },
                .moved => Data{ .moved = Point{ .x = ev.data1, .y = ev.data2 } },
                .resized => Data{ .resized = Size{ .width = ev.data1, .height = ev.data2 } },
                .size_changed => Data{ .size_changed = Size{ .width = ev.data1, .height = ev.data2 } },
                .minimized => Data{ .minimized = {} },
                .maximized => Data{ .maximized = {} },
                .restored => Data{ .restored = {} },
                .enter => Data{ .enter = {} },
                .leave => Data{ .leave = {} },
                .focus_gained => Data{ .focus_gained = {} },
                .focus_lost => Data{ .focus_lost = {} },
                .close => Data{ .close = {} },
                .take_focus => Data{ .take_focus = {} },
                .hit_test => Data{ .hit_test = {} },
                else => Data{ .none = {} },
            },
        };
    }
};

pub const EventType = std.meta.Tag(Event);
pub const Event = union(enum) {
    pub const CommonEvent = c.SDL_CommonEvent;
    pub const DisplayEvent = c.SDL_DisplayEvent;

    pub const KeyboardEvent = c.SDL_KeyboardEvent;
    pub const TextEditingEvent = c.SDL_TextEditingEvent;
    pub const TextInputEvent = c.SDL_TextInputEvent;
    pub const MouseMotionEvent = c.SDL_MouseMotionEvent;
    pub const MouseButtonEvent = c.SDL_MouseButtonEvent;
    pub const MouseWheelEvent = c.SDL_MouseWheelEvent;
    pub const JoyAxisEvent = c.SDL_JoyAxisEvent;
    pub const JoyBallEvent = c.SDL_JoyBallEvent;
    pub const JoyHatEvent = c.SDL_JoyHatEvent;
    pub const JoyButtonEvent = c.SDL_JoyButtonEvent;
    pub const JoyDeviceEvent = c.SDL_JoyDeviceEvent;
    pub const ControllerAxisEvent = c.SDL_ControllerAxisEvent;
    pub const ControllerButtonEvent = c.SDL_ControllerButtonEvent;
    pub const ControllerDeviceEvent = c.SDL_ControllerDeviceEvent;
    pub const AudioDeviceEvent = c.SDL_AudioDeviceEvent;
    pub const SensorEvent = c.SDL_SensorEvent;
    pub const QuitEvent = c.SDL_QuitEvent;
    pub const UserEvent = c.SDL_UserEvent;
    pub const SysWMEvent = c.SDL_SysWMEvent;
    pub const TouchFingerEvent = c.SDL_TouchFingerEvent;
    pub const MultiGestureEvent = c.SDL_MultiGestureEvent;
    pub const DollarGestureEvent = c.SDL_DollarGestureEvent;
    pub const DropEvent = c.SDL_DropEvent;

    clip_board_update: CommonEvent,
    app_did_enter_background: CommonEvent,
    app_did_enter_foreground: CommonEvent,
    app_will_enter_foreground: CommonEvent,
    app_will_enter_background: CommonEvent,
    app_low_memory: CommonEvent,
    app_terminating: CommonEvent,
    render_targets_reset: CommonEvent,
    render_device_reset: CommonEvent,
    key_map_changed: CommonEvent,
    display: DisplayEvent,
    window: WindowEvent,
    key_down: KeyboardEvent,
    key_up: KeyboardEvent,
    text_editing: TextEditingEvent,
    text_input: TextInputEvent,
    mouse_motion: MouseMotionEvent,
    mouse_button_down: MouseButtonEvent,
    mouse_button_up: MouseButtonEvent,
    mouse_wheel: MouseWheelEvent,
    joy_axis_motion: JoyAxisEvent,
    joy_ball_motion: JoyBallEvent,
    joy_hat_motion: JoyHatEvent,
    joy_button_down: JoyButtonEvent,
    joy_button_up: JoyButtonEvent,
    joy_device_added: JoyDeviceEvent,
    joy_device_removed: JoyDeviceEvent,
    controller_axis_motion: ControllerAxisEvent,
    controller_button_down: ControllerButtonEvent,
    controller_button_up: ControllerButtonEvent,
    controller_device_added: ControllerDeviceEvent,
    controller_device_removed: ControllerDeviceEvent,
    controller_device_remapped: ControllerDeviceEvent,
    audio_device_added: AudioDeviceEvent,
    audio_device_removed: AudioDeviceEvent,
    sensor_update: SensorEvent,
    quit: QuitEvent,
    sys_wm: SysWMEvent,
    finger_down: TouchFingerEvent,
    finger_up: TouchFingerEvent,
    finger_motion: TouchFingerEvent,
    multi_gesture: MultiGestureEvent,
    dollar_gesture: DollarGestureEvent,
    dollar_record: DollarGestureEvent,
    drop_file: DropEvent,
    drop_text: DropEvent,
    drop_begin: DropEvent,
    drop_complete: DropEvent,
    // user: UserEvent,

    pub fn from(raw: c.SDL_Event) Event {
        return switch (raw.type) {
            c.SDL_QUIT => Event{ .quit = raw.quit },
            c.SDL_APP_TERMINATING => Event{ .app_terminating = raw.common },
            c.SDL_APP_LOWMEMORY => Event{ .app_low_memory = raw.common },
            c.SDL_APP_WILLENTERBACKGROUND => Event{ .app_will_enter_background = raw.common },
            c.SDL_APP_DIDENTERBACKGROUND => Event{ .app_did_enter_background = raw.common },
            c.SDL_APP_WILLENTERFOREGROUND => Event{ .app_will_enter_foreground = raw.common },
            c.SDL_APP_DIDENTERFOREGROUND => Event{ .app_did_enter_foreground = raw.common },
            c.SDL_DISPLAYEVENT => Event{ .display = raw.display },
            c.SDL_WINDOWEVENT => Event{ .window = WindowEvent.fromNative(raw.window) },
            c.SDL_SYSWMEVENT => Event{ .sys_wm = raw.syswm },
            c.SDL_KEYDOWN => Event{ .key_down = raw.key },
            c.SDL_KEYUP => Event{ .key_up = raw.key },
            c.SDL_TEXTEDITING => Event{ .text_editing = raw.edit },
            c.SDL_TEXTINPUT => Event{ .text_input = raw.text },
            c.SDL_KEYMAPCHANGED => Event{ .key_map_changed = raw.common },
            c.SDL_MOUSEMOTION => Event{ .mouse_motion = raw.motion },
            c.SDL_MOUSEBUTTONDOWN => Event{ .mouse_button_down = raw.button },
            c.SDL_MOUSEBUTTONUP => Event{ .mouse_button_up = raw.button },
            c.SDL_MOUSEWHEEL => Event{ .mouse_wheel = raw.wheel },
            c.SDL_JOYAXISMOTION => Event{ .joy_axis_motion = raw.jaxis },
            c.SDL_JOYBALLMOTION => Event{ .joy_ball_motion = raw.jball },
            c.SDL_JOYHATMOTION => Event{ .joy_hat_motion = raw.jhat },
            c.SDL_JOYBUTTONDOWN => Event{ .joy_button_down = raw.jbutton },
            c.SDL_JOYBUTTONUP => Event{ .joy_button_up = raw.jbutton },
            c.SDL_JOYDEVICEADDED => Event{ .joy_device_added = raw.jdevice },
            c.SDL_JOYDEVICEREMOVED => Event{ .joy_device_removed = raw.jdevice },
            c.SDL_CONTROLLERAXISMOTION => Event{ .controller_axis_motion = raw.caxis },
            c.SDL_CONTROLLERBUTTONDOWN => Event{ .controller_button_down = raw.cbutton },
            c.SDL_CONTROLLERBUTTONUP => Event{ .controller_button_up = raw.cbutton },
            c.SDL_CONTROLLERDEVICEADDED => Event{ .controller_device_added = raw.cdevice },
            c.SDL_CONTROLLERDEVICEREMOVED => Event{ .controller_device_removed = raw.cdevice },
            c.SDL_CONTROLLERDEVICEREMAPPED => Event{ .controller_device_remapped = raw.cdevice },
            c.SDL_FINGERDOWN => Event{ .finger_down = raw.tfinger },
            c.SDL_FINGERUP => Event{ .finger_up = raw.tfinger },
            c.SDL_FINGERMOTION => Event{ .finger_motion = raw.tfinger },
            c.SDL_DOLLARGESTURE => Event{ .dollar_gesture = raw.dgesture },
            c.SDL_DOLLARRECORD => Event{ .dollar_record = raw.dgesture },
            c.SDL_MULTIGESTURE => Event{ .multi_gesture = raw.mgesture },
            c.SDL_CLIPBOARDUPDATE => Event{ .clip_board_update = raw.common },
            c.SDL_DROPFILE => Event{ .drop_file = raw.drop },
            c.SDL_DROPTEXT => Event{ .drop_text = raw.drop },
            c.SDL_DROPBEGIN => Event{ .drop_begin = raw.drop },
            c.SDL_DROPCOMPLETE => Event{ .drop_complete = raw.drop },
            c.SDL_AUDIODEVICEADDED => Event{ .audio_device_added = raw.adevice },
            c.SDL_AUDIODEVICEREMOVED => Event{ .audio_device_removed = raw.adevice },
            c.SDL_SENSORUPDATE => Event{ .sensor_update = raw.sensor },
            c.SDL_RENDER_TARGETS_RESET => Event{ .render_targets_reset = raw.common },
            c.SDL_RENDER_DEVICE_RESET => Event{ .render_device_reset = raw.common },
            else => @panic("Unsupported event type detected!"),
        };
    }
};

pub fn pollEvent() ?Event {
    var ev: c.SDL_Event = undefined;
    if (c.SDL_PollEvent(&ev) != 0)
        return Event.from(ev);
    return null;
}

pub fn pollNativeEvent() ?c.SDL_Event {
    var ev: c.SDL_Event = undefined;
    if (c.SDL_PollEvent(&ev) != 0)
        return ev;
    return null;
}

pub const MouseState = struct {
    x: c_int,
    y: c_int,
    left: bool,
    right: bool,
    middle: bool,
    extra1: bool,
    extra2: bool,
};

pub fn getMouseState() MouseState {
    var ms: MouseState = undefined;
    const buttons = c.SDL_GetMouseState(&ms.x, &ms.y);
    ms.left = ((buttons & 1) != 0);
    ms.right = ((buttons & 4) != 0);
    ms.middle = ((buttons & 2) != 0);
    ms.extra1 = ((buttons & 8) != 0);
    ms.extra2 = ((buttons & 16) != 0);
    return ms;
}

pub const KeyboardState = struct {
    states: []const u8,

    pub fn isPressed(ks: KeyboardState, scanCode: c.SDL_Scancode) bool {
        return ks.states[@intCast(usize, @enumToInt(scanCode))] != 0;
    }
};

pub fn getKeyboardState() KeyboardState {
    var len: c_int = undefined;
    const slice = c.SDL_GetKeyboardState(&len);
    return KeyboardState{
        .states = slice[0..@intCast(usize, len)],
    };
}

pub fn getTicks() usize {
    return c.SDL_GetTicks();
}

pub fn delay(ms: u32) void {
    c.SDL_Delay(ms);
}

test "platform independent declarations" {
    std.testing.refAllDecls(@This());
}

pub fn numJoysticks() !u31 {
    const num = c.SDL_NumJoysticks();
    if (num < 0) return error.SdlError;
    return @intCast(u31, num);
}

pub const GameController = struct {
    ptr: *c.SDL_GameController,

    pub fn open(joystick_index: u31) !GameController {
        return GameController{
            .ptr = c.SDL_GameControllerOpen(joystick_index) orelse return error.SdlError,
        };
    }

    pub fn close(self: GameController) void {
        c.SDL_GameControllerClose(self.ptr);
    }

    pub fn nameForIndex(joystick_index: u31) ?[:0]const u8 {
        return std.mem.spanZ(c.SDL_GameControllerNameForIndex(joystick_index));
    }

    pub const Button = enum(i32) {
        a = c.SDL_CONTROLLER_BUTTON_A,
        b = c.SDL_CONTROLLER_BUTTON_B,
        x = c.SDL_CONTROLLER_BUTTON_X,
        y = c.SDL_CONTROLLER_BUTTON_Y,
        back = c.SDL_CONTROLLER_BUTTON_BACK,
        start = c.SDL_CONTROLLER_BUTTON_START,
        guide = c.SDL_CONTROLLER_BUTTON_GUIDE,
        left_stick = c.SDL_CONTROLLER_BUTTON_LEFTSTICK,
        right_stick = c.SDL_CONTROLLER_BUTTON_RIGHTSTICK,
        left_shoulder = c.SDL_CONTROLLER_BUTTON_LEFTSHOULDER,
        right_shoulder = c.SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,
        dpad_up = c.SDL_CONTROLLER_BUTTON_DPAD_UP,
        dpad_down = c.SDL_CONTROLLER_BUTTON_DPAD_DOWN,
        dpad_left = c.SDL_CONTROLLER_BUTTON_DPAD_LEFT,
        dpad_right = c.SDL_CONTROLLER_BUTTON_DPAD_RIGHT,
    };

    pub const Axis = enum(i32) {
        left_x = c.SDL_CONTROLLER_AXIS_LEFTX,
        left_y = c.SDL_CONTROLLER_AXIS_LEFTY,
        right_x = c.SDL_CONTROLLER_AXIS_RIGHTX,
        right_y = c.SDL_CONTROLLER_AXIS_RIGHTY,
        trigger_left = c.SDL_CONTROLLER_AXIS_TRIGGERLEFT,
        trigger_right = c.SDL_CONTROLLER_AXIS_TRIGGERRIGHT,
    };
};
