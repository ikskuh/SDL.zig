const std = @import("std");

/// Exports the C interface for SDL
pub const c = @import("sdl-native");

pub const image = @import("image.zig");
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

pub const RectangleF = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    fn getSdlPtr(r: *RectangleF) *c.SDL_FRect {
        return @ptrCast(*c.SDL_FRect, r);
    }
    fn getConstSdlPtr(r: RectangleF) *const c.SDL_FRect {
        return @ptrCast(*const c.SDL_FRect, &r);
    }
};

pub const Point = extern struct {
    x: c_int,
    y: c_int,
};

pub const PointF = extern struct {
    x: f32,
    y: f32,
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

pub const Vertex = extern struct {
    position: PointF,
    color: Color,
    tex_coord: PointF = undefined,
};

pub const InitFlags = struct {
    pub const everything = InitFlags{
        .timer = true,
        .audio = true,
        .video = true,
        .joystick = true,
        .haptic = true,
        .game_controller = true,
        .events = true,
        .sensor = true,
    };
    timer: bool = false,
    audio: bool = false,
    video: bool = false,
    joystick: bool = false,
    haptic: bool = false,
    game_controller: bool = false,
    events: bool = false,
    sensor: bool = false,

    pub fn from_u32(flags: u32) InitFlags {
        return .{
            .timer = (flags & c.SDL_INIT_TIMER) != 0,
            .audio = (flags & c.SDL_INIT_AUDIO) != 0,
            .video = (flags & c.SDL_INIT_VIDEO) != 0,
            .joystick = (flags & c.SDL_INIT_JOYSTICK) != 0,
            .haptic = (flags & c.SDL_INIT_HAPTIC) != 0,
            .game_controller = (flags & c.SDL_INIT_GAMECONTROLLER) != 0,
            .events = (flags & c.SDL_INIT_EVENTS) != 0,
            .sensor = (flags & c.SDL_INIT_SENSOR) != 0,
        };
    }

    pub fn as_u32(self: InitFlags) u32 {
        return (if (self.timer) @as(u32, c.SDL_INIT_TIMER) else 0) |
            (if (self.audio) @as(u32, c.SDL_INIT_AUDIO) else 0) |
            (if (self.video) @as(u32, c.SDL_INIT_VIDEO) else 0) |
            (if (self.joystick) @as(u32, c.SDL_INIT_JOYSTICK) else 0) |
            (if (self.haptic) @as(u32, c.SDL_INIT_HAPTIC) else 0) |
            (if (self.game_controller) @as(u32, c.SDL_INIT_GAMECONTROLLER) else 0) |
            (if (self.events) @as(u32, c.SDL_INIT_EVENTS) else 0) |
            (if (self.sensor) @as(u32, c.SDL_INIT_SENSOR) else 0);
    }
};

pub fn init(flags: InitFlags) !void {
    if (c.SDL_Init(flags.as_u32()) < 0)
        return makeError();
}

pub fn wasInit(flags: InitFlags) InitFlags {
    return InitFlags.from_u32(c.SDL_WasInit(flags.as_u32()));
}

pub fn quit() void {
    c.SDL_Quit();
}

pub fn getError() ?[]const u8 {
    if (c.SDL_GetError()) |err| {
        return std.mem.span(err);
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

    pub fn getPosition(w: Window) !Point {
        var x: c_int = undefined;
        var y: c_int = undefined;

        c.SDL_GetWindowPosition(w.ptr, &x, &y);

        return Point{
            .x = x,
            .y = y,
        };
    }

    pub fn setPosition(w: Window, p: Point) !void {
        c.SDL_SetWindowPosition(w.ptr, p.x, p.y);
    }

    pub fn setMinimumSize(w: Window, width: c_int, height: c_int) void {
        c.SDL_SetWindowMinimumSize(w.ptr, width, height);
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

    /// window usable with Vulkan context
    vulkan: bool = false, //  SDL_WINDOW_VULKAN,

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
        if (wf.vulkan) val |= c.SDL_WINDOW_VULKAN;
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

    pub fn setColorKey(s: Surface, enabled: bool, color: Color) !void {
        if (c.SDL_SetColorKey(s.ptr, if (enabled) c.SDL_TRUE else c.SDL_FALSE, c.SDL_MapRGBA(
            s.ptr.*.format,
            color.r,
            color.g,
            color.b,
            color.a,
        )) < 0) return makeError();
    }

    pub fn fillRect(s: *Surface, rect: ?*Rectangle, color: Color) !void {
        const rect_ptr = if (rect) |_rect| _rect.getSdlPtr() else null;
        if (c.SDL_FillRect(s.ptr, rect_ptr, c.SDL_MapRGBA(s.ptr.*.format, color.r, color.g, color.b, color.a)) < 0) return makeError();
    }
};

pub fn loadBmpFromConstMem(data: []const u8) !Surface {
    const sptr = c.SDL_LoadBMP_RW(c.SDL_RWFromConstMem(data.ptr, @intCast(c_int, data.len)), 1) orelse return makeError();
    return Surface{
        .ptr = sptr,
    };
}

pub fn loadBmp(filename: [:0]const u8) !Surface {
    if (c.SDL_RWFromFile(filename, "rb")) |rwops| {
        if (c.SDL_LoadBMP_RW(rwops, 1)) |sptr| {
            return Surface{
                .ptr = sptr,
            };
        }
    }

    return makeError();
}

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

pub const BlendMode = enum(c.SDL_BlendMode) {
    none = c.SDL_BLENDMODE_NONE,
    blend = c.SDL_BLENDMODE_BLEND,
    add = c.SDL_BLENDMODE_ADD,
    mod = c.SDL_BLENDMODE_MOD,
    multiply = c.SDL_BLENDMODE_MUL,
    _, // additional values may be obtained from c.SDL_ComposeCustomBlendMode (though not supported by all renderers)
};

pub const ScaleMode = enum(c.SDL_ScaleMode) {
    nearest = c.SDL_ScaleModeNearest,
    linear = c.SDL_ScaleModeLinear,
    best = c.SDL_ScaleModeBest,
};

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

    pub fn copyF(ren: Renderer, tex: Texture, dstRect: ?RectangleF, srcRect: ?Rectangle) !void {
        if (c.SDL_RenderCopyF(ren.ptr, tex.ptr, if (srcRect) |r| r.getConstSdlPtr() else null, if (dstRect) |r| r.getConstSdlPtr() else null) < 0)
            return makeError();
    }

    pub fn setScale(ren: Renderer, x: f32, y: f32) !void {
        if (c.SDL_RenderSetScale(ren.ptr, x, y) > 0)
            return makeError();
    }

    pub fn drawLine(ren: Renderer, x0: i32, y0: i32, x1: i32, y1: i32) !void {
        if (c.SDL_RenderDrawLine(ren.ptr, x0, y0, x1, y1) < 0)
            return makeError();
    }

    pub fn drawLineF(ren: Renderer, x0: f32, y0: f32, x1: f32, y1: f32) !void {
        if (c.SDL_RenderDrawLineF(ren.ptr, x0, y0, x1, y1) < 0)
            return makeError();
    }

    pub fn drawPoint(ren: Renderer, x: i32, y: i32) !void {
        if (c.SDL_RenderDrawPoint(ren.ptr, x, y) < 0)
            return makeError();
    }

    pub fn drawPointF(ren: Renderer, x: f32, y: f32) !void {
        if (c.SDL_RenderDrawPointF(ren.ptr, x, y) < 0)
            return makeError();
    }

    pub fn fillRect(ren: Renderer, rect: Rectangle) !void {
        if (c.SDL_RenderFillRect(ren.ptr, rect.getConstSdlPtr()) < 0)
            return makeError();
    }

    pub fn fillRectF(ren: Renderer, rect: RectangleF) !void {
        if (c.SDL_RenderFillRectF(ren.ptr, rect.getConstSdlPtr()) < 0)
            return makeError();
    }

    pub fn drawRect(ren: Renderer, rect: Rectangle) !void {
        if (c.SDL_RenderDrawRect(ren.ptr, rect.getConstSdlPtr()) < 0)
            return makeError();
    }

    pub fn drawRectF(ren: Renderer, rect: RectangleF) !void {
        if (c.SDL_RenderDrawRectF(ren.ptr, rect.getConstSdlPtr()) < 0)
            return makeError();
    }

    pub fn drawGeometry(ren: Renderer, tex: ?Texture, vertices: []const Vertex, indices: ?[]const u32) !void {
        if (c.SDL_RenderGeometry(
            ren.ptr,
            if (tex) |t| t.ptr else null,
            @ptrCast([*c]const c.SDL_Vertex, vertices.ptr),
            @intCast(c_int, vertices.len),
            if (indices) |idx| @ptrCast([*]const c_int, idx.ptr) else null,
            if (indices) |idx| @intCast(c_int, idx.len) else 0,
        ) < 0)
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

    pub fn getColor(ren: Renderer) !Color {
        var color: Color = undefined;
        if (c.SDL_GetRenderDrawColor(ren.ptr, &color.r, &color.g, &color.b, &color.a) < 0)
            return makeError();
        return color;
    }

    pub fn getDrawBlendMode(ren: Renderer) !BlendMode {
        var blend_mode: c.SDL_BlendMode = undefined;
        if (c.SDL_GetRenderDrawBlendMode(ren.ptr, &blend_mode) < 0)
            return makeError();
        return @intToEnum(BlendMode, blend_mode);
    }

    pub fn setDrawBlendMode(ren: Renderer, blend_mode: BlendMode) !void {
        if (c.SDL_SetRenderDrawBlendMode(ren.ptr, @enumToInt(blend_mode)) < 0)
            return makeError();
    }

    pub const OutputSize = struct { width_pixels: c_int, height_pixels: c_int };
    pub fn getOutputSize(ren: Renderer) !OutputSize {
        var width_pixels: c_int = undefined;
        var height_pixels: c_int = undefined;
        if (c.SDL_GetRendererOutputSize(ren.ptr, &width_pixels, &height_pixels) < 0)
            return makeError();
        return OutputSize{ .width_pixels = width_pixels, .height_pixels = height_pixels };
    }

    pub fn getInfo(ren: Renderer) !c.SDL_RendererInfo {
        var result: c.SDL_RendererInfo = undefined;
        if (c.SDL_GetRendererInfo(ren.ptr, &result) < 0)
            return makeError();
        return result;
    }

    pub fn setClipRect(ren: Renderer, clip_rectangle: ?Rectangle) !void {
        if (c.SDL_RenderSetClipRect(ren.ptr, if (clip_rectangle) |*r| r.getConstSdlPtr() else null) < 0)
            return makeError();
    }

    pub fn getClipRect(ren: Renderer) !?Rectangle {
        if (c.SDL_RenderIsClipEnabled(ren.ptr) == c.SDL_FALSE) return null;
        var clip_rectangle: Rectangle = undefined;
        c.SDL_RenderGetClipRect(ren.ptr, clip_rectangle.getSdlPtr());
        return clip_rectangle;
    }

    pub fn getLogicalSize(ren: Renderer) !Size {
        var width_pixels: c_int = undefined;
        var height_pixels: c_int = undefined;

        if (c.SDL_RenderGetLogicalSize(ren.ptr, &width_pixels, &height_pixels) < 0)
            return makeError();
        return Size{
            .width = width_pixels,
            .height = height_pixels,
        };
    }

    pub fn setLogicalSize(ren: Renderer, width_pixels: c_int, height_pixels: c_int) !void {
        if (c.SDL_RenderSetLogicalSize(ren.ptr, width_pixels, height_pixels) < 0)
            return makeError();
    }

    pub fn getViewport(ren: Renderer) Rectangle {
        var result: Rectangle = undefined;
        c.SDL_RenderGetViewport(ren.ptr, result.getSdlPtr());
        return result;
    }

    pub fn setViewport(ren: Renderer, rect: Rectangle) !void {
        var vp = rect;
        if (c.SDL_RenderSetViewport(ren.ptr, vp.getSdlPtr()) < 0)
            return makeError();
    }

    pub fn setTarget(ren: Renderer, tex: ?Texture) !void {
        if (c.SDL_SetRenderTarget(ren.ptr, if (tex) |t| t.ptr else null) < 0)
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
        var ptr: ?*anyopaque = undefined;
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

    pub const Info = struct {
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

    pub fn setAlphaMod(tex: Texture, a: u8) !void {
        if (c.SDL_SetTextureAlphaMod(tex.ptr, a) < 0)
            return makeError();
    }

    pub fn getBlendMode(tex: Texture) !BlendMode {
        var blend_mode: c.SDL_BlendMode = undefined;
        if (c.SDL_GetTextureBlendMode(tex.ptr, &blend_mode) < 0)
            return makeError();
        return @intToEnum(BlendMode, blend_mode);
    }

    pub fn setBlendMode(tex: Texture, blend_mode: BlendMode) !void {
        if (c.SDL_SetTextureBlendMode(tex.ptr, @enumToInt(blend_mode)) < 0)
            return makeError();
    }

    pub fn getScaleMode(tex: Texture) !ScaleMode {
        var scale_mode: c.SDL_ScaleMode = undefined;
        if (c.SDL_GetTextureScaleMode(tex.ptr, @enumToInt(scale_mode)) < 0)
            return makeError();
        return @intToEnum(ScaleMode, scale_mode);
    }

    pub fn setScaleMode(tex: Texture, scale_mode: ScaleMode) !void {
        if (c.SDL_SetTextureScaleMode(tex.ptr, @enumToInt(scale_mode)) < 0)
            return makeError();
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

pub const KeyModifierBit = enum(u16) {
    left_shift = c.KMOD_LSHIFT,
    right_shift = c.KMOD_RSHIFT,
    left_control = c.KMOD_LCTRL,
    right_control = c.KMOD_RCTRL,
    ///left alternate
    left_alt = c.KMOD_LALT,
    ///right alternate
    right_alt = c.KMOD_RALT,
    left_gui = c.KMOD_LGUI,
    right_gui = c.KMOD_RGUI,
    ///numeric lock
    num_lock = c.KMOD_NUM,
    ///capital letters lock
    caps_lock = c.KMOD_CAPS,
    mode = c.KMOD_MODE,
    ///scroll lock (= previous value c.KMOD_RESERVED)
    scroll_lock = c.KMOD_SCROLL,
};
pub const KeyModifierSet = struct {
    storage: u16,

    pub fn fromNative(native: u16) KeyModifierSet {
        return .{ .storage = native };
    }
    pub fn toNative(self: KeyModifierSet) u16 {
        return self.storage;
    }

    pub fn get(self: KeyModifierSet, modifier: KeyModifierBit) bool {
        return (self.storage & @enumToInt(modifier)) != 0;
    }
    pub fn set(self: *KeyModifierSet, modifier: KeyModifierBit) void {
        self.storage |= @enumToInt(modifier);
    }
    pub fn clear(self: *KeyModifierSet, modifier: KeyModifierBit) void {
        self.storage &= ~@enumToInt(modifier);
    }
};
pub const KeyboardEvent = struct {
    pub const KeyState = enum(u8) {
        released = c.SDL_RELEASED,
        pressed = c.SDL_PRESSED,
    };

    timestamp: u32,
    window_id: u32,
    key_state: KeyState,
    is_repeat: bool,
    scancode: Scancode,
    keycode: Keycode,
    modifiers: KeyModifierSet,

    pub fn fromNative(native: c.SDL_KeyboardEvent) KeyboardEvent {
        switch (native.type) {
            else => unreachable,
            c.SDL_KEYDOWN, c.SDL_KEYUP => {},
        }
        return .{
            .timestamp = native.timestamp,
            .window_id = native.windowID,
            .key_state = @intToEnum(KeyState, native.state),
            .is_repeat = native.repeat != 0,
            .scancode = @intToEnum(Scancode, native.keysym.scancode),
            .keycode = @intToEnum(Keycode, native.keysym.sym),
            .modifiers = KeyModifierSet.fromNative(native.keysym.mod),
        };
    }
};

pub const MouseButton = enum(u3) {
    left = c.SDL_BUTTON_LEFT,
    middle = c.SDL_BUTTON_MIDDLE,
    right = c.SDL_BUTTON_RIGHT,
    extra_1 = c.SDL_BUTTON_X1,
    extra_2 = c.SDL_BUTTON_X2,
};
pub const MouseButtonState = struct {
    pub const NativeBitField = u32;
    pub const Storage = u5;

    storage: Storage,

    fn maskForButton(button_id: MouseButton) Storage {
        const mask = @as(NativeBitField, 1) << (@enumToInt(button_id) - 1);
        return @intCast(Storage, mask);
    }

    pub fn getPressed(self: MouseButtonState, button_id: MouseButton) bool {
        return (self.storage & maskForButton(button_id)) != 0;
    }
    pub fn setPressed(self: *MouseButtonState, button_id: MouseButton) void {
        self.storage |= maskForButton(button_id);
    }
    pub fn setUnpressed(self: *MouseButtonState, button_id: MouseButton) void {
        self.storage &= ~maskForButton(button_id);
    }

    pub fn fromNative(native: NativeBitField) MouseButtonState {
        return .{ .storage = @intCast(Storage, native) };
    }
    pub fn toNative(self: MouseButtonState) NativeBitField {
        return self.storage;
    }
};
pub const MouseMotionEvent = struct {
    timestamp: u32,
    /// originally named `windowID`
    window_id: u32,
    /// originally named `which`;
    /// if it comes from a touch input device,
    /// the value is c.SDL_TOUCH_MOUSEID,
    /// in which case a TouchFingerEvent was also generated.
    mouse_instance_id: u32,
    /// from original field named `state`
    button_state: MouseButtonState,
    x: i32,
    y: i32,
    /// originally named `xrel`,
    /// difference of position since last reported MouseMotionEvent,
    /// ignores screen boundaries if relative mouse mode is enabled
    /// (see c.SDL_SetRelativeMouseMode)
    delta_x: i32,
    /// originally named `yrel`,
    /// difference of position since last reported MouseMotionEvent,
    /// ignores screen boundaries if relative mouse mode is enabled
    /// (see c.SDL_SetRelativeMouseMode)
    delta_y: i32,

    pub fn fromNative(native: c.SDL_MouseMotionEvent) MouseMotionEvent {
        std.debug.assert(native.type == c.SDL_MOUSEMOTION);
        return .{
            .timestamp = native.timestamp,
            .window_id = native.windowID,
            .mouse_instance_id = native.which,
            .button_state = MouseButtonState.fromNative(native.state),
            .x = native.x,
            .y = native.y,
            .delta_x = native.xrel,
            .delta_y = native.yrel,
        };
    }
};
pub const MouseButtonEvent = struct {
    pub const ButtonState = enum(u8) {
        released = c.SDL_RELEASED,
        pressed = c.SDL_PRESSED,
    };

    timestamp: u32,
    /// originally named `windowID`
    window_id: u32,
    /// originally named `which`,
    /// if it comes from a touch input device,
    /// the value is c.SDL_TOUCH_MOUSEID,
    /// in which case a TouchFingerEvent was also generated.
    mouse_instance_id: u32,
    button: MouseButton,
    state: ButtonState,
    clicks: u8,
    x: i32,
    y: i32,

    pub fn fromNative(native: c.SDL_MouseButtonEvent) MouseButtonEvent {
        switch (native.type) {
            else => unreachable,
            c.SDL_MOUSEBUTTONDOWN, c.SDL_MOUSEBUTTONUP => {},
        }
        return .{
            .timestamp = native.timestamp,
            .window_id = native.windowID,
            .mouse_instance_id = native.which,
            .button = @intToEnum(MouseButton, native.button),
            .state = @intToEnum(ButtonState, native.state),
            .clicks = native.clicks,
            .x = native.x,
            .y = native.y,
        };
    }
};
pub const MouseWheelEvent = struct {
    pub const Direction = enum(u8) {
        normal = c.SDL_MOUSEWHEEL_NORMAL,
        flipped = c.SDL_MOUSEWHEEL_FLIPPED,
    };

    timestamp: u32,
    /// originally named `windowID`
    window_id: u32,
    /// originally named `which`,
    /// if it comes from a touch input device,
    /// the value is c.SDL_TOUCH_MOUSEID,
    /// in which case a TouchFingerEvent was also generated.
    mouse_instance_id: u32,
    /// originally named `x`,
    /// the amount scrolled horizontally,
    /// positive to the right and negative to the left,
    /// unless field `direction` has value `.flipped`,
    /// in which case the signs are reversed.
    delta_x: i32,
    /// originally named `y`,
    /// the amount scrolled vertically,
    /// positive away from the user and negative towards the user,
    /// unless field `direction` has value `.flipped`,
    /// in which case the signs are reversed.
    delta_y: i32,
    /// On macOS, devices are often by default configured to have
    /// "natural" scrolling direction, which flips the sign of both delta values.
    /// In this case, this field will have value `.flipped` instead of `.normal`.
    direction: Direction,

    pub fn fromNative(native: c.SDL_MouseWheelEvent) MouseWheelEvent {
        std.debug.assert(native.type == c.SDL_MOUSEWHEEL);
        return .{
            .timestamp = native.timestamp,
            .window_id = native.windowID,
            .mouse_instance_id = native.which,
            .delta_x = native.x,
            .delta_y = native.y,
            .direction = @intToEnum(Direction, @intCast(u8, native.direction)),
        };
    }
};

pub const JoyAxisEvent = struct {
    timestamp: u32,
    joystick_id: c.SDL_JoystickID,
    axis: u8,
    value: i16,

    pub fn fromNative(native: c.SDL_JoyAxisEvent) JoyAxisEvent {
        switch (native.type) {
            else => unreachable,
            c.SDL_JOYAXISMOTION => {},
        }
        return .{
            .timestamp = native.timestamp,
            .joystick_id = native.which,
            .axis = native.axis,
            .value = native.value,
        };
    }

    pub fn normalizedValue(self: JoyAxisEvent, comptime FloatType: type) FloatType {
        const denominator = if (self.value > 0)
            @intToFloat(FloatType, c.SDL_JOYSTICK_AXIS_MAX)
        else
            @intToFloat(FloatType, c.SDL_JOYSTICK_AXIS_MIN);
        return @intToFloat(FloatType, self.value) / @fabs(denominator);
    }
};

pub const JoyHatEvent = struct {
    pub const HatValue = enum(u8) {
        centered = c.SDL_HAT_CENTERED,
        up = c.SDL_HAT_UP,
        right = c.SDL_HAT_RIGHT,
        down = c.SDL_HAT_DOWN,
        left = c.SDL_HAT_LEFT,
        right_up = c.SDL_HAT_RIGHTUP,
        right_down = c.SDL_HAT_RIGHTDOWN,
        left_up = c.SDL_HAT_LEFTUP,
        left_down = c.SDL_HAT_LEFTDOWN,
    };

    timestamp: u32,
    joystick_id: c.SDL_JoystickID,
    hat: u8,
    value: HatValue,

    pub fn fromNative(native: c.SDL_JoyHatEvent) JoyHatEvent {
        switch (native.type) {
            else => unreachable,
            c.SDL_JOYHATMOTION => {},
        }
        return .{
            .timestamp = native.timestamp,
            .joystick_id = native.which,
            .hat = native.hat,
            .value = @intToEnum(HatValue, native.value),
        };
    }
};

pub const JoyBallEvent = struct {
    timestamp: u32,
    joystick_id: c.SDL_JoystickID,
    ball: u8,
    relative_x: i16,
    relative_y: i16,

    pub fn fromNative(native: c.SDL_JoyBallEvent) JoyBallEvent {
        switch (native.type) {
            else => unreachable,
            c.SDL_JOYBALLMOTION => {},
        }
        return .{
            .timestamp = native.timestamp,
            .joystick_id = native.which,
            .ball = native.ball,
            .relative_x = native.xrel,
            .relative_y = native.yrel,
        };
    }
};

pub const JoyButtonEvent = struct {
    pub const ButtonState = enum(u8) {
        released = c.SDL_RELEASED,
        pressed = c.SDL_PRESSED,
    };

    timestamp: u32,
    joystick_id: c.SDL_JoystickID,
    button: u8,
    button_state: ButtonState,

    pub fn fromNative(native: c.SDL_JoyButtonEvent) JoyButtonEvent {
        switch (native.type) {
            else => unreachable,
            c.SDL_JOYBUTTONDOWN, c.SDL_JOYBUTTONUP => {},
        }
        return .{
            .timestamp = native.timestamp,
            .joystick_id = native.which,
            .button = native.button,
            .button_state = @intToEnum(ButtonState, native.state),
        };
    }
};

pub const ControllerAxisEvent = struct {
    timestamp: u32,
    joystick_id: c.SDL_JoystickID,
    axis: GameController.Axis,
    value: i16,

    pub fn fromNative(native: c.SDL_ControllerAxisEvent) ControllerAxisEvent {
        switch (native.type) {
            else => unreachable,
            c.SDL_CONTROLLERAXISMOTION => {},
        }
        return .{
            .timestamp = native.timestamp,
            .joystick_id = native.which,
            .axis = @intToEnum(GameController.Axis, native.axis),
            .value = native.value,
        };
    }

    pub fn normalizedValue(self: ControllerAxisEvent, comptime FloatType: type) FloatType {
        const denominator = if (self.value > 0)
            @intToFloat(FloatType, c.SDL_JOYSTICK_AXIS_MAX)
        else
            @intToFloat(FloatType, c.SDL_JOYSTICK_AXIS_MIN);
        return @intToFloat(FloatType, self.value) / @fabs(denominator);
    }
};

pub const ControllerButtonEvent = struct {
    pub const ButtonState = enum(u8) {
        released = c.SDL_RELEASED,
        pressed = c.SDL_PRESSED,
    };

    timestamp: u32,
    joystick_id: c.SDL_JoystickID,
    button: GameController.Button,
    button_state: ButtonState,

    pub fn fromNative(native: c.SDL_ControllerButtonEvent) ControllerButtonEvent {
        switch (native.type) {
            else => unreachable,
            c.SDL_CONTROLLERBUTTONDOWN, c.SDL_CONTROLLERBUTTONUP => {},
        }
        return .{
            .timestamp = native.timestamp,
            .joystick_id = native.which,
            .button = @intToEnum(GameController.Button, native.button),
            .button_state = @intToEnum(ButtonState, native.state),
        };
    }
};

pub const EventType = std.meta.Tag(Event);
pub const Event = union(enum) {
    pub const CommonEvent = c.SDL_CommonEvent;
    pub const DisplayEvent = c.SDL_DisplayEvent;
    pub const TextEditingEvent = c.SDL_TextEditingEvent;
    pub const TextInputEvent = c.SDL_TextInputEvent;
    pub const JoyDeviceEvent = c.SDL_JoyDeviceEvent;
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
            c.SDL_KEYDOWN => Event{ .key_down = KeyboardEvent.fromNative(raw.key) },
            c.SDL_KEYUP => Event{ .key_up = KeyboardEvent.fromNative(raw.key) },
            c.SDL_TEXTEDITING => Event{ .text_editing = raw.edit },
            c.SDL_TEXTINPUT => Event{ .text_input = raw.text },
            c.SDL_KEYMAPCHANGED => Event{ .key_map_changed = raw.common },
            c.SDL_MOUSEMOTION => Event{ .mouse_motion = MouseMotionEvent.fromNative(raw.motion) },
            c.SDL_MOUSEBUTTONDOWN => Event{ .mouse_button_down = MouseButtonEvent.fromNative(raw.button) },
            c.SDL_MOUSEBUTTONUP => Event{ .mouse_button_up = MouseButtonEvent.fromNative(raw.button) },
            c.SDL_MOUSEWHEEL => Event{ .mouse_wheel = MouseWheelEvent.fromNative(raw.wheel) },
            c.SDL_JOYAXISMOTION => Event{ .joy_axis_motion = JoyAxisEvent.fromNative(raw.jaxis) },
            c.SDL_JOYBALLMOTION => Event{ .joy_ball_motion = JoyBallEvent.fromNative(raw.jball) },
            c.SDL_JOYHATMOTION => Event{ .joy_hat_motion = JoyHatEvent.fromNative(raw.jhat) },
            c.SDL_JOYBUTTONDOWN => Event{ .joy_button_down = JoyButtonEvent.fromNative(raw.jbutton) },
            c.SDL_JOYBUTTONUP => Event{ .joy_button_up = JoyButtonEvent.fromNative(raw.jbutton) },
            c.SDL_JOYDEVICEADDED => Event{ .joy_device_added = raw.jdevice },
            c.SDL_JOYDEVICEREMOVED => Event{ .joy_device_removed = raw.jdevice },
            c.SDL_CONTROLLERAXISMOTION => Event{ .controller_axis_motion = ControllerAxisEvent.fromNative(raw.caxis) },
            c.SDL_CONTROLLERBUTTONDOWN => Event{ .controller_button_down = ControllerButtonEvent.fromNative(raw.cbutton) },
            c.SDL_CONTROLLERBUTTONUP => Event{ .controller_button_up = ControllerButtonEvent.fromNative(raw.cbutton) },
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

/// This function should only be called from
/// the thread that initialized the video subsystem.
pub fn pumpEvents() void {
    c.SDL_PumpEvents();
}

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

/// Waits indefinitely to pump a new event into the queue.
/// May not conserve energy on some systems, in some versions/situations.
/// This function should only be called from
/// the thread that initialized the video subsystem.
pub fn waitEvent() !Event {
    var ev: c.SDL_Event = undefined;
    if (c.SDL_WaitEvent(&ev) != 0)
        return Event.from(ev);
    return makeError();
}

/// Waits `timeout` milliseconds
/// to pump the next available event into the queue.
/// May not conserve energy on some systems, in some versions/situations.
/// This function should only be called from
/// the thread that initialized the video subsystem.
pub fn waitEventTimeout(timeout: usize) ?Event {
    var ev: c.SDL_Event = undefined;
    if (c.SDL_WaitEventTimeout(&ev, @intCast(c_int, timeout)) != 0)
        return Event.from(ev);
    return null;
}

pub const MouseState = struct {
    x: c_int,
    y: c_int,
    buttons: MouseButtonState,
};

pub fn getMouseState() MouseState {
    var ms: MouseState = undefined;
    const buttons = c.SDL_GetMouseState(&ms.x, &ms.y);
    ms.buttons = MouseButtonState.fromNative(buttons);
    return ms;
}

pub const Scancode = enum(c.SDL_Scancode) {
    unknown = c.SDL_SCANCODE_UNKNOWN,
    a = c.SDL_SCANCODE_A,
    b = c.SDL_SCANCODE_B,
    c = c.SDL_SCANCODE_C,
    d = c.SDL_SCANCODE_D,
    e = c.SDL_SCANCODE_E,
    f = c.SDL_SCANCODE_F,
    g = c.SDL_SCANCODE_G,
    h = c.SDL_SCANCODE_H,
    i = c.SDL_SCANCODE_I,
    j = c.SDL_SCANCODE_J,
    k = c.SDL_SCANCODE_K,
    l = c.SDL_SCANCODE_L,
    m = c.SDL_SCANCODE_M,
    n = c.SDL_SCANCODE_N,
    o = c.SDL_SCANCODE_O,
    p = c.SDL_SCANCODE_P,
    q = c.SDL_SCANCODE_Q,
    r = c.SDL_SCANCODE_R,
    s = c.SDL_SCANCODE_S,
    t = c.SDL_SCANCODE_T,
    u = c.SDL_SCANCODE_U,
    v = c.SDL_SCANCODE_V,
    w = c.SDL_SCANCODE_W,
    x = c.SDL_SCANCODE_X,
    y = c.SDL_SCANCODE_Y,
    z = c.SDL_SCANCODE_Z,
    @"1" = c.SDL_SCANCODE_1,
    @"2" = c.SDL_SCANCODE_2,
    @"3" = c.SDL_SCANCODE_3,
    @"4" = c.SDL_SCANCODE_4,
    @"5" = c.SDL_SCANCODE_5,
    @"6" = c.SDL_SCANCODE_6,
    @"7" = c.SDL_SCANCODE_7,
    @"8" = c.SDL_SCANCODE_8,
    @"9" = c.SDL_SCANCODE_9,
    @"0" = c.SDL_SCANCODE_0,
    @"return" = c.SDL_SCANCODE_RETURN,
    escape = c.SDL_SCANCODE_ESCAPE,
    backspace = c.SDL_SCANCODE_BACKSPACE,
    tab = c.SDL_SCANCODE_TAB,
    space = c.SDL_SCANCODE_SPACE,
    minus = c.SDL_SCANCODE_MINUS,
    equals = c.SDL_SCANCODE_EQUALS,
    left_bracket = c.SDL_SCANCODE_LEFTBRACKET,
    right_bracket = c.SDL_SCANCODE_RIGHTBRACKET,
    backslash = c.SDL_SCANCODE_BACKSLASH,
    non_us_hash = c.SDL_SCANCODE_NONUSHASH,
    semicolon = c.SDL_SCANCODE_SEMICOLON,
    apostrophe = c.SDL_SCANCODE_APOSTROPHE,
    grave = c.SDL_SCANCODE_GRAVE,
    comma = c.SDL_SCANCODE_COMMA,
    period = c.SDL_SCANCODE_PERIOD,
    slash = c.SDL_SCANCODE_SLASH,
    ///capital letters lock
    caps_lock = c.SDL_SCANCODE_CAPSLOCK,
    f1 = c.SDL_SCANCODE_F1,
    f2 = c.SDL_SCANCODE_F2,
    f3 = c.SDL_SCANCODE_F3,
    f4 = c.SDL_SCANCODE_F4,
    f5 = c.SDL_SCANCODE_F5,
    f6 = c.SDL_SCANCODE_F6,
    f7 = c.SDL_SCANCODE_F7,
    f8 = c.SDL_SCANCODE_F8,
    f9 = c.SDL_SCANCODE_F9,
    f10 = c.SDL_SCANCODE_F10,
    f11 = c.SDL_SCANCODE_F11,
    f12 = c.SDL_SCANCODE_F12,
    print_screen = c.SDL_SCANCODE_PRINTSCREEN,
    scroll_lock = c.SDL_SCANCODE_SCROLLLOCK,
    pause = c.SDL_SCANCODE_PAUSE,
    insert = c.SDL_SCANCODE_INSERT,
    home = c.SDL_SCANCODE_HOME,
    page_up = c.SDL_SCANCODE_PAGEUP,
    delete = c.SDL_SCANCODE_DELETE,
    end = c.SDL_SCANCODE_END,
    page_down = c.SDL_SCANCODE_PAGEDOWN,
    right = c.SDL_SCANCODE_RIGHT,
    left = c.SDL_SCANCODE_LEFT,
    down = c.SDL_SCANCODE_DOWN,
    up = c.SDL_SCANCODE_UP,
    ///numeric lock, "Clear" key on Apple keyboards
    num_lock_clear = c.SDL_SCANCODE_NUMLOCKCLEAR,
    keypad_divide = c.SDL_SCANCODE_KP_DIVIDE,
    keypad_multiply = c.SDL_SCANCODE_KP_MULTIPLY,
    keypad_minus = c.SDL_SCANCODE_KP_MINUS,
    keypad_plus = c.SDL_SCANCODE_KP_PLUS,
    keypad_enter = c.SDL_SCANCODE_KP_ENTER,
    keypad_1 = c.SDL_SCANCODE_KP_1,
    keypad_2 = c.SDL_SCANCODE_KP_2,
    keypad_3 = c.SDL_SCANCODE_KP_3,
    keypad_4 = c.SDL_SCANCODE_KP_4,
    keypad_5 = c.SDL_SCANCODE_KP_5,
    keypad_6 = c.SDL_SCANCODE_KP_6,
    keypad_7 = c.SDL_SCANCODE_KP_7,
    keypad_8 = c.SDL_SCANCODE_KP_8,
    keypad_9 = c.SDL_SCANCODE_KP_9,
    keypad_0 = c.SDL_SCANCODE_KP_0,
    keypad_period = c.SDL_SCANCODE_KP_PERIOD,
    non_us_backslash = c.SDL_SCANCODE_NONUSBACKSLASH,
    application = c.SDL_SCANCODE_APPLICATION,
    power = c.SDL_SCANCODE_POWER,
    keypad_equals = c.SDL_SCANCODE_KP_EQUALS,
    f13 = c.SDL_SCANCODE_F13,
    f14 = c.SDL_SCANCODE_F14,
    f15 = c.SDL_SCANCODE_F15,
    f16 = c.SDL_SCANCODE_F16,
    f17 = c.SDL_SCANCODE_F17,
    f18 = c.SDL_SCANCODE_F18,
    f19 = c.SDL_SCANCODE_F19,
    f20 = c.SDL_SCANCODE_F20,
    f21 = c.SDL_SCANCODE_F21,
    f22 = c.SDL_SCANCODE_F22,
    f23 = c.SDL_SCANCODE_F23,
    f24 = c.SDL_SCANCODE_F24,
    execute = c.SDL_SCANCODE_EXECUTE,
    help = c.SDL_SCANCODE_HELP,
    menu = c.SDL_SCANCODE_MENU,
    select = c.SDL_SCANCODE_SELECT,
    stop = c.SDL_SCANCODE_STOP,
    again = c.SDL_SCANCODE_AGAIN,
    undo = c.SDL_SCANCODE_UNDO,
    cut = c.SDL_SCANCODE_CUT,
    copy = c.SDL_SCANCODE_COPY,
    paste = c.SDL_SCANCODE_PASTE,
    find = c.SDL_SCANCODE_FIND,
    mute = c.SDL_SCANCODE_MUTE,
    volume_up = c.SDL_SCANCODE_VOLUMEUP,
    volume_down = c.SDL_SCANCODE_VOLUMEDOWN,
    keypad_comma = c.SDL_SCANCODE_KP_COMMA,
    keypad_equals_as_400 = c.SDL_SCANCODE_KP_EQUALSAS400,
    international_1 = c.SDL_SCANCODE_INTERNATIONAL1,
    international_2 = c.SDL_SCANCODE_INTERNATIONAL2,
    international_3 = c.SDL_SCANCODE_INTERNATIONAL3,
    international_4 = c.SDL_SCANCODE_INTERNATIONAL4,
    international_5 = c.SDL_SCANCODE_INTERNATIONAL5,
    international_6 = c.SDL_SCANCODE_INTERNATIONAL6,
    international_7 = c.SDL_SCANCODE_INTERNATIONAL7,
    international_8 = c.SDL_SCANCODE_INTERNATIONAL8,
    international_9 = c.SDL_SCANCODE_INTERNATIONAL9,
    language_1 = c.SDL_SCANCODE_LANG1,
    language_2 = c.SDL_SCANCODE_LANG2,
    language_3 = c.SDL_SCANCODE_LANG3,
    language_4 = c.SDL_SCANCODE_LANG4,
    language_5 = c.SDL_SCANCODE_LANG5,
    language_6 = c.SDL_SCANCODE_LANG6,
    language_7 = c.SDL_SCANCODE_LANG7,
    language_8 = c.SDL_SCANCODE_LANG8,
    language_9 = c.SDL_SCANCODE_LANG9,
    alternate_erase = c.SDL_SCANCODE_ALTERASE,
    ///aka "Attention"
    system_request = c.SDL_SCANCODE_SYSREQ,
    cancel = c.SDL_SCANCODE_CANCEL,
    clear = c.SDL_SCANCODE_CLEAR,
    prior = c.SDL_SCANCODE_PRIOR,
    return_2 = c.SDL_SCANCODE_RETURN2,
    separator = c.SDL_SCANCODE_SEPARATOR,
    out = c.SDL_SCANCODE_OUT,
    ///Don't know what this stands for, operator? operation? operating system? Couldn't find it anywhere.
    oper = c.SDL_SCANCODE_OPER,
    ///technically named "Clear/Again"
    clear_again = c.SDL_SCANCODE_CLEARAGAIN,
    ///aka "CrSel/Props" (properties)
    cursor_selection = c.SDL_SCANCODE_CRSEL,
    extend_selection = c.SDL_SCANCODE_EXSEL,
    keypad_00 = c.SDL_SCANCODE_KP_00,
    keypad_000 = c.SDL_SCANCODE_KP_000,
    thousands_separator = c.SDL_SCANCODE_THOUSANDSSEPARATOR,
    decimal_separator = c.SDL_SCANCODE_DECIMALSEPARATOR,
    currency_unit = c.SDL_SCANCODE_CURRENCYUNIT,
    currency_subunit = c.SDL_SCANCODE_CURRENCYSUBUNIT,
    keypad_left_parenthesis = c.SDL_SCANCODE_KP_LEFTPAREN,
    keypad_right_parenthesis = c.SDL_SCANCODE_KP_RIGHTPAREN,
    keypad_left_brace = c.SDL_SCANCODE_KP_LEFTBRACE,
    keypad_right_brace = c.SDL_SCANCODE_KP_RIGHTBRACE,
    keypad_tab = c.SDL_SCANCODE_KP_TAB,
    keypad_backspace = c.SDL_SCANCODE_KP_BACKSPACE,
    keypad_a = c.SDL_SCANCODE_KP_A,
    keypad_b = c.SDL_SCANCODE_KP_B,
    keypad_c = c.SDL_SCANCODE_KP_C,
    keypad_d = c.SDL_SCANCODE_KP_D,
    keypad_e = c.SDL_SCANCODE_KP_E,
    keypad_f = c.SDL_SCANCODE_KP_F,
    ///keypad exclusive or
    keypad_xor = c.SDL_SCANCODE_KP_XOR,
    keypad_power = c.SDL_SCANCODE_KP_POWER,
    keypad_percent = c.SDL_SCANCODE_KP_PERCENT,
    keypad_less = c.SDL_SCANCODE_KP_LESS,
    keypad_greater = c.SDL_SCANCODE_KP_GREATER,
    keypad_ampersand = c.SDL_SCANCODE_KP_AMPERSAND,
    keypad_double_ampersand = c.SDL_SCANCODE_KP_DBLAMPERSAND,
    keypad_vertical_bar = c.SDL_SCANCODE_KP_VERTICALBAR,
    keypad_double_vertical_bar = c.SDL_SCANCODE_KP_DBLVERTICALBAR,
    keypad_colon = c.SDL_SCANCODE_KP_COLON,
    keypad_hash = c.SDL_SCANCODE_KP_HASH,
    keypad_space = c.SDL_SCANCODE_KP_SPACE,
    keypad_at_sign = c.SDL_SCANCODE_KP_AT,
    keypad_exclamation_mark = c.SDL_SCANCODE_KP_EXCLAM,
    keypad_memory_store = c.SDL_SCANCODE_KP_MEMSTORE,
    keypad_memory_recall = c.SDL_SCANCODE_KP_MEMRECALL,
    keypad_memory_clear = c.SDL_SCANCODE_KP_MEMCLEAR,
    keypad_memory_add = c.SDL_SCANCODE_KP_MEMADD,
    keypad_memory_subtract = c.SDL_SCANCODE_KP_MEMSUBTRACT,
    keypad_memory_multiply = c.SDL_SCANCODE_KP_MEMMULTIPLY,
    keypad_memory_divide = c.SDL_SCANCODE_KP_MEMDIVIDE,
    keypad_plus_minus = c.SDL_SCANCODE_KP_PLUSMINUS,
    keypad_clear = c.SDL_SCANCODE_KP_CLEAR,
    keypad_clear_entry = c.SDL_SCANCODE_KP_CLEARENTRY,
    keypad_binary = c.SDL_SCANCODE_KP_BINARY,
    keypad_octal = c.SDL_SCANCODE_KP_OCTAL,
    keypad_decimal = c.SDL_SCANCODE_KP_DECIMAL,
    keypad_hexadecimal = c.SDL_SCANCODE_KP_HEXADECIMAL,
    left_control = c.SDL_SCANCODE_LCTRL,
    left_shift = c.SDL_SCANCODE_LSHIFT,
    ///left alternate
    left_alt = c.SDL_SCANCODE_LALT,
    left_gui = c.SDL_SCANCODE_LGUI,
    right_control = c.SDL_SCANCODE_RCTRL,
    right_shift = c.SDL_SCANCODE_RSHIFT,
    ///right alternate
    right_alt = c.SDL_SCANCODE_RALT,
    right_gui = c.SDL_SCANCODE_RGUI,
    mode = c.SDL_SCANCODE_MODE,
    audio_next = c.SDL_SCANCODE_AUDIONEXT,
    audio_previous = c.SDL_SCANCODE_AUDIOPREV,
    audio_stop = c.SDL_SCANCODE_AUDIOSTOP,
    audio_play = c.SDL_SCANCODE_AUDIOPLAY,
    audio_mute = c.SDL_SCANCODE_AUDIOMUTE,
    media_select = c.SDL_SCANCODE_MEDIASELECT,
    www = c.SDL_SCANCODE_WWW,
    mail = c.SDL_SCANCODE_MAIL,
    calculator = c.SDL_SCANCODE_CALCULATOR,
    computer = c.SDL_SCANCODE_COMPUTER,
    application_control_search = c.SDL_SCANCODE_AC_SEARCH,
    application_control_home = c.SDL_SCANCODE_AC_HOME,
    application_control_back = c.SDL_SCANCODE_AC_BACK,
    application_control_forward = c.SDL_SCANCODE_AC_FORWARD,
    application_control_stop = c.SDL_SCANCODE_AC_STOP,
    application_control_refresh = c.SDL_SCANCODE_AC_REFRESH,
    application_control_bookmarks = c.SDL_SCANCODE_AC_BOOKMARKS,
    brightness_down = c.SDL_SCANCODE_BRIGHTNESSDOWN,
    brightness_up = c.SDL_SCANCODE_BRIGHTNESSUP,
    display_switch = c.SDL_SCANCODE_DISPLAYSWITCH,
    keyboard_illumination_toggle = c.SDL_SCANCODE_KBDILLUMTOGGLE,
    keyboard_illumination_down = c.SDL_SCANCODE_KBDILLUMDOWN,
    keyboard_illumination_up = c.SDL_SCANCODE_KBDILLUMUP,
    eject = c.SDL_SCANCODE_EJECT,
    sleep = c.SDL_SCANCODE_SLEEP,
    application_1 = c.SDL_SCANCODE_APP1,
    application_2 = c.SDL_SCANCODE_APP2,
    audio_rewind = c.SDL_SCANCODE_AUDIOREWIND,
    audio_fast_forward = c.SDL_SCANCODE_AUDIOFASTFORWARD,
    _,
};

pub const KeyboardState = struct {
    states: []const u8,

    pub fn isPressed(ks: KeyboardState, scancode: Scancode) bool {
        return ks.states[@intCast(usize, @enumToInt(scancode))] != 0;
    }
};

pub fn getKeyboardState() KeyboardState {
    var len: c_int = undefined;
    const slice = c.SDL_GetKeyboardState(&len);
    return KeyboardState{
        .states = slice[0..@intCast(usize, len)],
    };
}
pub const getModState = getKeyboardModifierState;
pub fn getKeyboardModifierState() KeyModifierSet {
    return KeyModifierSet.fromNative(@intCast(u16, c.SDL_GetModState()));
}

pub const Keycode = enum(c.SDL_Keycode) {
    unknown = c.SDLK_UNKNOWN,
    @"return" = c.SDLK_RETURN,
    escape = c.SDLK_ESCAPE,
    backspace = c.SDLK_BACKSPACE,
    tab = c.SDLK_TAB,
    space = c.SDLK_SPACE,
    exclamation_mark = c.SDLK_EXCLAIM,
    quote = c.SDLK_QUOTEDBL,
    hash = c.SDLK_HASH,
    percent = c.SDLK_PERCENT,
    dollar = c.SDLK_DOLLAR,
    ampersand = c.SDLK_AMPERSAND,
    apostrophe = c.SDLK_QUOTE,
    left_parenthesis = c.SDLK_LEFTPAREN,
    right_parenthesis = c.SDLK_RIGHTPAREN,
    asterisk = c.SDLK_ASTERISK,
    plus = c.SDLK_PLUS,
    comma = c.SDLK_COMMA,
    minus = c.SDLK_MINUS,
    period = c.SDLK_PERIOD,
    slash = c.SDLK_SLASH,
    @"0" = c.SDLK_0,
    @"1" = c.SDLK_1,
    @"2" = c.SDLK_2,
    @"3" = c.SDLK_3,
    @"4" = c.SDLK_4,
    @"5" = c.SDLK_5,
    @"6" = c.SDLK_6,
    @"7" = c.SDLK_7,
    @"8" = c.SDLK_8,
    @"9" = c.SDLK_9,
    colon = c.SDLK_COLON,
    semicolon = c.SDLK_SEMICOLON,
    less = c.SDLK_LESS,
    equals = c.SDLK_EQUALS,
    greater = c.SDLK_GREATER,
    question_mark = c.SDLK_QUESTION,
    at_sign = c.SDLK_AT,
    left_bracket = c.SDLK_LEFTBRACKET,
    backslash = c.SDLK_BACKSLASH,
    right_bracket = c.SDLK_RIGHTBRACKET,
    caret = c.SDLK_CARET,
    underscore = c.SDLK_UNDERSCORE,
    grave = c.SDLK_BACKQUOTE,
    a = c.SDLK_a,
    b = c.SDLK_b,
    c = c.SDLK_c,
    d = c.SDLK_d,
    e = c.SDLK_e,
    f = c.SDLK_f,
    g = c.SDLK_g,
    h = c.SDLK_h,
    i = c.SDLK_i,
    j = c.SDLK_j,
    k = c.SDLK_k,
    l = c.SDLK_l,
    m = c.SDLK_m,
    n = c.SDLK_n,
    o = c.SDLK_o,
    p = c.SDLK_p,
    q = c.SDLK_q,
    r = c.SDLK_r,
    s = c.SDLK_s,
    t = c.SDLK_t,
    u = c.SDLK_u,
    v = c.SDLK_v,
    w = c.SDLK_w,
    x = c.SDLK_x,
    y = c.SDLK_y,
    z = c.SDLK_z,
    ///capital letters lock
    caps_lock = c.SDLK_CAPSLOCK,
    f1 = c.SDLK_F1,
    f2 = c.SDLK_F2,
    f3 = c.SDLK_F3,
    f4 = c.SDLK_F4,
    f5 = c.SDLK_F5,
    f6 = c.SDLK_F6,
    f7 = c.SDLK_F7,
    f8 = c.SDLK_F8,
    f9 = c.SDLK_F9,
    f10 = c.SDLK_F10,
    f11 = c.SDLK_F11,
    f12 = c.SDLK_F12,
    print_screen = c.SDLK_PRINTSCREEN,
    scroll_lock = c.SDLK_SCROLLLOCK,
    pause = c.SDLK_PAUSE,
    insert = c.SDLK_INSERT,
    home = c.SDLK_HOME,
    page_up = c.SDLK_PAGEUP,
    delete = c.SDLK_DELETE,
    end = c.SDLK_END,
    page_down = c.SDLK_PAGEDOWN,
    right = c.SDLK_RIGHT,
    left = c.SDLK_LEFT,
    down = c.SDLK_DOWN,
    up = c.SDLK_UP,
    ///numeric lock, "Clear" key on Apple keyboards
    num_lock_clear = c.SDLK_NUMLOCKCLEAR,
    keypad_divide = c.SDLK_KP_DIVIDE,
    keypad_multiply = c.SDLK_KP_MULTIPLY,
    keypad_minus = c.SDLK_KP_MINUS,
    keypad_plus = c.SDLK_KP_PLUS,
    keypad_enter = c.SDLK_KP_ENTER,
    keypad_1 = c.SDLK_KP_1,
    keypad_2 = c.SDLK_KP_2,
    keypad_3 = c.SDLK_KP_3,
    keypad_4 = c.SDLK_KP_4,
    keypad_5 = c.SDLK_KP_5,
    keypad_6 = c.SDLK_KP_6,
    keypad_7 = c.SDLK_KP_7,
    keypad_8 = c.SDLK_KP_8,
    keypad_9 = c.SDLK_KP_9,
    keypad_0 = c.SDLK_KP_0,
    keypad_period = c.SDLK_KP_PERIOD,
    application = c.SDLK_APPLICATION,
    power = c.SDLK_POWER,
    keypad_equals = c.SDLK_KP_EQUALS,
    f13 = c.SDLK_F13,
    f14 = c.SDLK_F14,
    f15 = c.SDLK_F15,
    f16 = c.SDLK_F16,
    f17 = c.SDLK_F17,
    f18 = c.SDLK_F18,
    f19 = c.SDLK_F19,
    f20 = c.SDLK_F20,
    f21 = c.SDLK_F21,
    f22 = c.SDLK_F22,
    f23 = c.SDLK_F23,
    f24 = c.SDLK_F24,
    execute = c.SDLK_EXECUTE,
    help = c.SDLK_HELP,
    menu = c.SDLK_MENU,
    select = c.SDLK_SELECT,
    stop = c.SDLK_STOP,
    again = c.SDLK_AGAIN,
    undo = c.SDLK_UNDO,
    cut = c.SDLK_CUT,
    copy = c.SDLK_COPY,
    paste = c.SDLK_PASTE,
    find = c.SDLK_FIND,
    mute = c.SDLK_MUTE,
    volume_up = c.SDLK_VOLUMEUP,
    volume_down = c.SDLK_VOLUMEDOWN,
    keypad_comma = c.SDLK_KP_COMMA,
    keypad_equals_as_400 = c.SDLK_KP_EQUALSAS400,
    alternate_erase = c.SDLK_ALTERASE,
    ///aka "Attention"
    system_request = c.SDLK_SYSREQ,
    cancel = c.SDLK_CANCEL,
    clear = c.SDLK_CLEAR,
    prior = c.SDLK_PRIOR,
    return_2 = c.SDLK_RETURN2,
    separator = c.SDLK_SEPARATOR,
    out = c.SDLK_OUT,
    ///Don't know what this stands for, operator? operation? operating system? Couldn't find it anywhere.
    oper = c.SDLK_OPER,
    ///technically named "Clear/Again"
    clear_again = c.SDLK_CLEARAGAIN,
    ///aka "CrSel/Props" (properties)
    cursor_selection = c.SDLK_CRSEL,
    extend_selection = c.SDLK_EXSEL,
    keypad_00 = c.SDLK_KP_00,
    keypad_000 = c.SDLK_KP_000,
    thousands_separator = c.SDLK_THOUSANDSSEPARATOR,
    decimal_separator = c.SDLK_DECIMALSEPARATOR,
    currency_unit = c.SDLK_CURRENCYUNIT,
    currency_subunit = c.SDLK_CURRENCYSUBUNIT,
    keypad_left_parenthesis = c.SDLK_KP_LEFTPAREN,
    keypad_right_parenthesis = c.SDLK_KP_RIGHTPAREN,
    keypad_left_brace = c.SDLK_KP_LEFTBRACE,
    keypad_right_brace = c.SDLK_KP_RIGHTBRACE,
    keypad_tab = c.SDLK_KP_TAB,
    keypad_backspace = c.SDLK_KP_BACKSPACE,
    keypad_a = c.SDLK_KP_A,
    keypad_b = c.SDLK_KP_B,
    keypad_c = c.SDLK_KP_C,
    keypad_d = c.SDLK_KP_D,
    keypad_e = c.SDLK_KP_E,
    keypad_f = c.SDLK_KP_F,
    ///keypad exclusive or
    keypad_xor = c.SDLK_KP_XOR,
    keypad_power = c.SDLK_KP_POWER,
    keypad_percent = c.SDLK_KP_PERCENT,
    keypad_less = c.SDLK_KP_LESS,
    keypad_greater = c.SDLK_KP_GREATER,
    keypad_ampersand = c.SDLK_KP_AMPERSAND,
    keypad_double_ampersand = c.SDLK_KP_DBLAMPERSAND,
    keypad_vertical_bar = c.SDLK_KP_VERTICALBAR,
    keypad_double_vertical_bar = c.SDLK_KP_DBLVERTICALBAR,
    keypad_colon = c.SDLK_KP_COLON,
    keypad_hash = c.SDLK_KP_HASH,
    keypad_space = c.SDLK_KP_SPACE,
    keypad_at_sign = c.SDLK_KP_AT,
    keypad_exclamation_mark = c.SDLK_KP_EXCLAM,
    keypad_memory_store = c.SDLK_KP_MEMSTORE,
    keypad_memory_recall = c.SDLK_KP_MEMRECALL,
    keypad_memory_clear = c.SDLK_KP_MEMCLEAR,
    keypad_memory_add = c.SDLK_KP_MEMADD,
    keypad_memory_subtract = c.SDLK_KP_MEMSUBTRACT,
    keypad_memory_multiply = c.SDLK_KP_MEMMULTIPLY,
    keypad_memory_divide = c.SDLK_KP_MEMDIVIDE,
    keypad_plus_minus = c.SDLK_KP_PLUSMINUS,
    keypad_clear = c.SDLK_KP_CLEAR,
    keypad_clear_entry = c.SDLK_KP_CLEARENTRY,
    keypad_binary = c.SDLK_KP_BINARY,
    keypad_octal = c.SDLK_KP_OCTAL,
    keypad_decimal = c.SDLK_KP_DECIMAL,
    keypad_hexadecimal = c.SDLK_KP_HEXADECIMAL,
    left_control = c.SDLK_LCTRL,
    left_shift = c.SDLK_LSHIFT,
    ///left alternate
    left_alt = c.SDLK_LALT,
    left_gui = c.SDLK_LGUI,
    right_control = c.SDLK_RCTRL,
    right_shift = c.SDLK_RSHIFT,
    ///right alternate
    right_alt = c.SDLK_RALT,
    right_gui = c.SDLK_RGUI,
    mode = c.SDLK_MODE,
    audio_next = c.SDLK_AUDIONEXT,
    audio_previous = c.SDLK_AUDIOPREV,
    audio_stop = c.SDLK_AUDIOSTOP,
    audio_play = c.SDLK_AUDIOPLAY,
    audio_mute = c.SDLK_AUDIOMUTE,
    media_select = c.SDLK_MEDIASELECT,
    www = c.SDLK_WWW,
    mail = c.SDLK_MAIL,
    calculator = c.SDLK_CALCULATOR,
    computer = c.SDLK_COMPUTER,
    application_control_search = c.SDLK_AC_SEARCH,
    application_control_home = c.SDLK_AC_HOME,
    application_control_back = c.SDLK_AC_BACK,
    application_control_forward = c.SDLK_AC_FORWARD,
    application_control_stop = c.SDLK_AC_STOP,
    application_control_refresh = c.SDLK_AC_REFRESH,
    application_control_bookmarks = c.SDLK_AC_BOOKMARKS,
    brightness_down = c.SDLK_BRIGHTNESSDOWN,
    brightness_up = c.SDLK_BRIGHTNESSUP,
    display_switch = c.SDLK_DISPLAYSWITCH,
    keyboard_illumination_toggle = c.SDLK_KBDILLUMTOGGLE,
    keyboard_illumination_down = c.SDLK_KBDILLUMDOWN,
    keyboard_illumination_up = c.SDLK_KBDILLUMUP,
    eject = c.SDLK_EJECT,
    sleep = c.SDLK_SLEEP,
    application_1 = c.SDLK_APP1,
    application_2 = c.SDLK_APP2,
    audio_rewind = c.SDLK_AUDIOREWIND,
    audio_fast_forward = c.SDLK_AUDIOFASTFORWARD,
    _,
};

pub const Clipboard = struct {
    pub fn get() !?[]const u8 {
        if (c.SDL_HasClipboardText() == c.SDL_FALSE)
            return null;
        const c_string = c.SDL_GetClipboardText();
        const txt = std.mem.sliceTo(c_string, 0);
        if (txt.len == 0) {
            c.SDL_free(c_string);
            return makeError();
        }
        return txt;
    }
    /// free is to be called with a previously fetched clipboard content
    pub fn free(txt: []const u8) void {
        c.SDL_free(@ptrCast([*c]const u8, txt));
    }
    pub fn set(txt: []const u8) !void {
        if (c.SDL_SetClipboardText(@ptrCast([*c]const u8, txt)) != 0)
            return makeError();
    }
};

pub fn getTicks() u32 {
    return c.SDL_GetTicks();
}

pub fn getTicks64() u64 {
    return c.SDL_GetTicks64();
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
        return std.mem.span(c.SDL_GameControllerNameForIndex(joystick_index));
    }

    pub const Button = enum(i32) {
        a = c.SDL_CONTROLLER_BUTTON_A,
        b = c.SDL_CONTROLLER_BUTTON_B,
        x = c.SDL_CONTROLLER_BUTTON_X,
        y = c.SDL_CONTROLLER_BUTTON_Y,
        back = c.SDL_CONTROLLER_BUTTON_BACK,
        guide = c.SDL_CONTROLLER_BUTTON_GUIDE,
        start = c.SDL_CONTROLLER_BUTTON_START,
        left_stick = c.SDL_CONTROLLER_BUTTON_LEFTSTICK,
        right_stick = c.SDL_CONTROLLER_BUTTON_RIGHTSTICK,
        left_shoulder = c.SDL_CONTROLLER_BUTTON_LEFTSHOULDER,
        right_shoulder = c.SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,
        dpad_up = c.SDL_CONTROLLER_BUTTON_DPAD_UP,
        dpad_down = c.SDL_CONTROLLER_BUTTON_DPAD_DOWN,
        dpad_left = c.SDL_CONTROLLER_BUTTON_DPAD_LEFT,
        dpad_right = c.SDL_CONTROLLER_BUTTON_DPAD_RIGHT,
        /// Xbox Series X share button, PS5 microphone button, Nintendo Switch Pro capture button, Amazon Luna microphone button
        misc_1 = c.SDL_CONTROLLER_BUTTON_MISC1,
        /// Xbox Elite paddle P1
        paddle_1 = c.SDL_CONTROLLER_BUTTON_PADDLE1,
        /// Xbox Elite paddle P2
        paddle_2 = c.SDL_CONTROLLER_BUTTON_PADDLE2,
        /// Xbox Elite paddle P3
        paddle_3 = c.SDL_CONTROLLER_BUTTON_PADDLE3,
        /// Xbox Elite paddle P4
        paddle_4 = c.SDL_CONTROLLER_BUTTON_PADDLE4,
        /// PS4/PS5 touchpad button
        touchpad = c.SDL_CONTROLLER_BUTTON_TOUCHPAD,
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

pub const AudioDevice = struct {
    pub fn makeUninitialized() AudioDevice {
        return .{
            .id = 0,
        };
    }

    id: c.SDL_AudioDeviceID,

    pub fn isInitialized(self: AudioDevice) bool {
        return self.id != 0;
    }

    pub fn close(self: AudioDevice) void {
        c.SDL_CloseAudioDevice(self.id);
    }

    pub fn pause(self: AudioDevice, do_pause: bool) void {
        c.SDL_PauseAudioDevice(self.id, @boolToInt(do_pause));
    }

    pub fn lock(self: AudioDevice) void {
        c.SDL_LockAudioDevice(self.id);
    }

    pub fn unlock(self: AudioDevice) void {
        c.SDL_UnlockAudioDevice(self.id);
    }
};

const is_little_endian = @import("builtin").target.cpu.arch.endian() == .Little;

pub const AudioFormat = struct {
    pub const @"u8" = AudioFormat{
        .sample_length_bits = 8,
    };
    pub const s8 = AudioFormat{
        .sample_length_bits = 8,
        .is_signed = true,
    };
    pub const u16_lsb = AudioFormat{
        .sample_length_bits = 16,
    };
    pub const s16_lsb = AudioFormat{
        .sample_length_bits = 16,
        .is_signed = true,
    };
    pub const u16_msb = AudioFormat{
        .sample_length_bits = 16,
        .is_big_endian = true,
    };
    pub const s16_msb = AudioFormat{
        .sample_length_bits = 16,
        .is_big_endian = true,
        .is_signed = true,
    };
    pub const @"u16" = u16_lsb;
    pub const s16 = s16_lsb;
    pub const u16_sys = if (is_little_endian) u16_lsb else u16_msb;
    pub const s16_sys = if (is_little_endian) s16_lsb else s16_msb;
    pub const s32_lsb = AudioFormat{
        .sample_length_bits = 32,
        .is_signed = true,
    };
    pub const s32_msb = AudioFormat{
        .sample_length_bits = 32,
        .is_big_endian = true,
        .is_signed = true,
    };
    pub const s32 = s32_lsb;
    pub const s32_sys = if (is_little_endian) s32_lsb else s32_msb;
    pub const f32_lsb = AudioFormat{
        .sample_length_bits = 32,
        .is_float = true,
        .is_signed = true,
    };
    pub const f32_msb = AudioFormat{
        .sample_length_bits = 32,
        .is_float = true,
        .is_big_endian = true,
        .is_signed = true,
    };
    pub const @"f32" = f32_lsb;
    pub const f32_sys = if (is_little_endian) f32_lsb else f32_msb;

    sample_length_bits: u8 = 32,
    is_float: bool = false,
    is_big_endian: bool = false,
    is_signed: bool = false,

    pub fn fromNative(native_packed: u16) AudioFormat {
        return .{
            .sample_length_bits = unpackSampleLengthBits(native_packed),
            .is_float = unpackFloat(native_packed),
            .is_big_endian = unpackBigEndian(native_packed),
            .is_signed = unpackSigned(native_packed),
        };
    }
    pub fn toNative(format: AudioFormat) u16 {
        return (if (format.is_signed) @as(u16, c.SDL_AUDIO_MASK_SIGNED) else 0) |
            (if (format.is_big_endian) @as(u16, c.SDL_AUDIO_MASK_ENDIAN) else 0) |
            (if (format.is_float) @as(u16, c.SDL_AUDIO_MASK_DATATYPE) else 0) |
            format.sample_length_bits;
    }

    pub fn unpackSampleLengthBits(native_packed: u16) u8 {
        return @intCast(u8, native_packed & @as(u8, c.SDL_AUDIO_MASK_BITSIZE));
    }
    pub fn unpackFloat(native_packed: u16) bool {
        return (native_packed & @as(u16, c.SDL_AUDIO_MASK_DATATYPE)) != 0;
    }
    pub fn unpackBigEndian(native_packed: u16) bool {
        return (native_packed & @as(u16, c.SDL_AUDIO_MASK_ENDIAN)) != 0;
    }
    pub fn unpackSigned(native_packed: u16) bool {
        return (native_packed & @as(u16, c.SDL_AUDIO_MASK_SIGNED)) != 0;
    }
};

pub const AudioSpecRequest = struct {
    ///in Hz, 0 obtains a supported value, values < 0 are not sane, values > 48000 are discouraged
    ///(field originally named "freq")
    sample_rate: c_int = 0,
    ///AudioFormat.fromNative(0) obtains a supported standard format, like s16
    buffer_format: AudioFormat = AudioFormat.fromNative(0),
    ///0 obtains a supported value, otherwise either 1 (mono), 2 (stereo), 4 (quad), 6 (5.1 surround), or 8 (7.1 surround)
    channel_count: u8 = 0,
    ///frame = channel_count number of samples;
    ///0 obtains a supported value, f.e. 46ms worth of buffer,
    ///otherwise must be a power of two!
    buffer_size_in_frames: u16 = 0,
    ///periodically called to fill the audio buffer;
    ///may be null for use in queueing mode (call c.SDL_QueueAudio periodically)
    callback: c.SDL_AudioCallback,
    ///passed to .callback
    userdata: ?*anyopaque,
};
pub const AudioSpecResponse = struct {
    ///in Hz, values <= 0 are not sane
    ///(field originally named "freq")
    sample_rate: c_int,
    buffer_format: AudioFormat,
    ///either 1 (mono), 2 (stereo), 4 (quadrophonic), 6 (5.1 surround), or 8 (7.1 surround)
    channel_count: u8,
    ///frame = channel_count number of samples;
    ///will be a power of two
    ///(field originally named "samples")
    buffer_size_in_frames: u16,
    ///(field originally named "size")
    buffer_size_in_bytes: u32,
};

pub const OpenAudioDeviceAllowedChanges = struct {
    pub const everything = .{ .sample_rate = true, .buffer_format = true, .channel_count = true, .buffer_size = true };

    sample_rate: bool = false,
    buffer_format: bool = false,
    channel_count: bool = false,
    buffer_size: bool = false,

    pub fn toNative(self: OpenAudioDeviceAllowedChanges) c_int {
        return (if (self.sample_rate) c.SDL_AUDIO_ALLOW_FREQUENCY_CHANGE else 0) |
            (if (self.buffer_format) c.SDL_AUDIO_ALLOW_FORMAT_CHANGE else 0) |
            (if (self.channel_count) c.SDL_AUDIO_ALLOW_CHANNELS_CHANGE else 0) |
            (if (self.buffer_size) c.SDL_AUDIO_ALLOW_SAMPLES_CHANGE else 0);
    }
};
pub const OpenAudioDeviceOptions = struct {
    device_name: ?[*:0]const u8 = null,
    is_capture: bool = false,
    desired_spec: AudioSpecRequest,
    allowed_changes_from_desired: OpenAudioDeviceAllowedChanges = .{},
};
pub const OpenAudioDeviceResult = struct {
    device: AudioDevice,
    obtained_spec: AudioSpecResponse,
};

pub fn openAudioDevice(options: OpenAudioDeviceOptions) !OpenAudioDeviceResult {
    const desired_spec = std.mem.zeroInit(c.SDL_AudioSpec, .{
        .freq = options.desired_spec.sample_rate,
        .format = options.desired_spec.buffer_format.toNative(),
        .channels = options.desired_spec.channel_count,
        .samples = options.desired_spec.buffer_size_in_frames,
        .callback = options.desired_spec.callback,
        .userdata = options.desired_spec.userdata,
    });
    var obtained_spec = std.mem.zeroInit(c.SDL_AudioSpec, .{});
    switch (c.SDL_OpenAudioDevice(options.device_name, @boolToInt(options.is_capture), &desired_spec, &obtained_spec, options.allowed_changes_from_desired.toNative())) {
        0 => return makeError(),
        else => |device_id| return OpenAudioDeviceResult{
            .device = .{
                .id = device_id,
            },
            .obtained_spec = .{
                .sample_rate = obtained_spec.freq,
                .buffer_format = AudioFormat.fromNative(obtained_spec.format),
                .channel_count = obtained_spec.channels,
                .buffer_size_in_frames = obtained_spec.samples,
                .buffer_size_in_bytes = obtained_spec.size,
            },
        },
    }
}

pub const SystemCursor = enum(c_uint) {
    arrow = c.SDL_SYSTEM_CURSOR_ARROW,
    ibeam = c.SDL_SYSTEM_CURSOR_IBEAM,
    wait = c.SDL_SYSTEM_CURSOR_WAIT,
    crosshair = c.SDL_SYSTEM_CURSOR_CROSSHAIR,
    wait_arrow = c.SDL_SYSTEM_CURSOR_WAITARROW,
    size_nwse = c.SDL_SYSTEM_CURSOR_SIZENWSE,
    size_nesw = c.SDL_SYSTEM_CURSOR_SIZENESW,
    size_we = c.SDL_SYSTEM_CURSOR_SIZEWE,
    size_ns = c.SDL_SYSTEM_CURSOR_SIZENS,
    size_all = c.SDL_SYSTEM_CURSOR_SIZEALL,
    size_no = c.SDL_SYSTEM_CURSOR_NO,
    hand = c.SDL_SYSTEM_CURSOR_HAND,
};

pub const Cursor = struct {
    ptr: *c.SDL_Cursor,

    pub fn destroy(self: *Cursor) void {
        c.SDL_FreeCursor(self.ptr);
    }
};

pub fn createCursor(data: []const u8, mask: []const u8, width: u32, height: u32, hot_x: i32, hot_y: i32) !Cursor {
    std.debug.assert(data.len >= width * height);
    std.debug.assert(mask.len >= width * height);
    return Cursor{
        .ptr = c.SDL_CreateCursor(
            data.ptr,
            mask.ptr,
            @intCast(c_int, width),
            @intCast(c_int, height),
            hot_x,
            hot_y,
        ) orelse return makeError(),
    };
}

pub fn createColorCursor(surface: Surface, hot_x: i32, hot_y: i32) !Cursor {
    return Cursor{
        .ptr = c.SDL_CreateColorCursor(surface.ptr, hot_x, hot_y) orelse return makeError(),
    };
}

pub fn createSystemCursor(id: SystemCursor) !Cursor {
    return Cursor{
        .ptr = c.SDL_CreateSystemCursor(@enumToInt(id)) orelse return makeError(),
    };
}

pub fn setCursor(cursor: ?Cursor) void {
    c.SDL_SetCursor(if (cursor) |cur| cur.ptr else null);
}

pub fn getCursor() !Cursor {
    return Cursor{
        .ptr = c.SDL_GetCursor() orelse return makeError(),
    };
}

pub fn getDefaultCursor() !Cursor {
    return Cursor{
        .ptr = c.SDL_GetDefaultCursor() orelse return makeError(),
    };
}

pub fn showCursor(toggle: ?bool) !bool {
    const t = if (toggle) |show| @boolToInt(show) else c.SDL_QUERY;
    const ret = c.SDL_ShowCursor(t);
    if (ret < 0) {
        return makeError();
    } else return ret == c.SDL_ENABLE;
}

pub const Wav = struct {
    format: AudioSpecResponse,
    buffer: []u8,

    pub fn destroy(self: Wav) void {
        c.SDL_FreeWAV(self.buffer.ptr);
    }
};

pub fn loadWav(file: [:0]const u8) !Wav {
    if (c.SDL_RWFromFile(file, "rb")) |rwops| {
        var spec: c.SDL_AudioSpec = undefined;
        var buffer: [*c]u8 = undefined;
        var bufferlen: u32 = undefined;

        if (c.SDL_LoadWAV_RW(rwops, 1, &spec, &buffer, &bufferlen)) |obtainedSpec| {
            const format = AudioSpecResponse{
                .sample_rate = obtainedSpec.*.freq,
                .buffer_format = AudioFormat.fromNative(obtainedSpec.*.format),
                .channel_count = obtainedSpec.*.channels,
                .buffer_size_in_frames = obtainedSpec.*.samples,
                .buffer_size_in_bytes = obtainedSpec.*.size,
            };
            return Wav{
                .buffer = buffer[0..bufferlen],
                .format = format,
            };
        }
    }

    return makeError();
}

pub const AudioStream = struct {
    stream: *c.SDL_AudioStream,

    const Self = @This();

    pub fn put(self: *Self, buffer: []u8) !void {
        const res = c.SDL_AudioStreamPut(self.stream, buffer.ptr, @intCast(c_int, buffer.len));
        if (res == -1) {
            return error.SdlError;
        }
    }

    pub fn get(self: *Self, buffer: []u8) ![]u8 {
        const res = c.SDL_AudioStreamGet(self.stream, buffer.ptr, @intCast(c_int, buffer.len));
        if (res == -1) {
            return error.SdlError;
        }
        return buffer[0..@intCast(usize, res)];
    }

    pub fn available(self: *Self) usize {
        const res = c.SDL_AudioStreamAvailable(self.stream);
        return @intCast(usize, res);
    }

    pub fn flush(self: *Self) !void {
        if (c.SDL_AudioStreamFlush(self.stream) != 0) {
            return error.SdlError;
        }
    }

    pub fn clear(self: *Self) !void {
        c.SDL_AudioStreamClear(self.stream);
    }

    pub fn free(self: *Self) void {
        c.SDL_FreeAudioStream(self.stream);
    }
};

pub fn newAudioStream(
    src_format: AudioFormat,
    src_channels: u8,
    src_rate: i32,
    dst_format: AudioFormat,
    dst_channels: u8,
    dst_rate: i32,
) !AudioStream {
    var stream = c.SDL_NewAudioStream(
        src_format.toNative(),
        src_channels,
        @intCast(c_int, src_rate),
        dst_format.toNative(),
        dst_channels,
        @intCast(c_int, dst_rate),
    );
    if (stream) |s| {
        return AudioStream{
            .stream = s,
        };
    } else {
        return error.SdlError;
    }
}

pub const mix_maxvolume = c.SDL_MIX_MAXVOLUME;

pub fn mixAudioFormat(dst: []u8, src: []const u8, format: AudioFormat, volume: c_int) void {
    c.SDL_MixAudioFormat(
        @ptrCast([*c]u8, dst),
        @ptrCast([*c]const u8, src),
        format.toNative(),
        @intCast(u32, std.math.min(dst.len, src.len)),
        volume,
    );
}

pub const MessageBoxFlags = struct {
    @"error": bool = false,
    warning: bool = false,
    information: bool = false,

    pub fn toNative(self: MessageBoxFlags) u32 {
        var val: u32 = 0;
        if (self.@"error") val |= c.SDL_MESSAGEBOX_ERROR;
        if (self.warning) val |= c.SDL_MESSAGEBOX_WARNING;
        if (self.information) val |= c.SDL_MESSAGEBOX_INFORMATION;
        return val;
    }
};

pub fn showSimpleMessageBox(flags: MessageBoxFlags, title: [:0]const u8, message: [:0]const u8, window: ?Window) !void {
    if (c.SDL_ShowSimpleMessageBox(flags.toNative(), title, message, if (window) |w| w.ptr else null) != 0) {
        log.debug("Message box failed! title: {s}, message: {s}", .{ title, message });
        return makeError();
    }
}
