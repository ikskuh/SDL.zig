const sdl = @import("sdl.zig");
const std = @import("std");

pub fn init() !void {
    if (sdl.c.TTF_Init() == -1)
        return makeError();
}

pub fn wasInit() c_int {
    return sdl.c.TTF_WasInit();
}

pub fn quit() void {
    sdl.c.TTF_Quit();
}

pub const Font = struct {
    ptr: *sdl.c.TTF_Font,

    pub const Style = struct {
        italic: bool = false,
        bold: bool = false,
        underline: bool = false,

        pub const normal = Style{};
    };

    pub fn getStyle(self: Font) Style {
        const value = sdl.c.TTF_GetFontStyle(self.ptr);
        var result = Style.normal;
        if (value & sdl.c.TTF_STYLE_ITALIC) result.italic = true;
        if (value & sdl.c.TTF_STYLE_BOLD) result.bold = true;
        if (value & sdl.c.TTF_STYLE_UNDERLINE) result.underline = true;
        return result;
    }

    pub fn setStyle(self: Font, style: Style) void {
        var value: c_int = 0;
        if (style.italic) value |= sdl.c.TTF_STYLE_ITALIC;
        if (style.bold) value |= sdl.c.TTF_STYLE_BOLD;
        if (style.underline) value |= sdl.c.TTF_STYLE_UNDERLINE;
        sdl.c.TTF_SetFontStyle(self.ptr, value);
    }

    pub fn height(self: Font) c_int {
        return sdl.c.TTF_FontHeight(self.ptr);
    }

    pub fn sizeText(self: Font, text: [:0]const u8) !sdl.Size {
        var w: c_int = undefined;
        var h: c_int = undefined;
        if (sdl.c.TTF_SizeText(self.ptr, text, &w, &h) == -1) return makeError();
        return sdl.Size{ .width = w, .height = h };
    }

    pub fn renderTextSolid(self: Font, text: [:0]const u8, foreground: sdl.Color) !sdl.Surface {
        return sdl.Surface{
            .ptr = sdl.c.TTF_RenderText_Solid(
                self.ptr,
                text.ptr,
                .{ .r = foreground.r, .g = foreground.g, .b = foreground.b, .a = foreground.a },
            ) orelse return makeError(),
        };
    }

    pub fn renderTextShaded(
        self: Font,
        text: [:0]const u8,
        foreground: sdl.Color,
        background: sdl.Color,
    ) !sdl.Surface {
        return sdl.Surface{
            .ptr = sdl.c.TTF_RenderText_Shaded(
                self.ptr,
                text.ptr,
                .{ .r = foreground.r, .g = foreground.g, .b = foreground.b, .a = foreground.a },
                .{ .r = background.r, .g = background.g, .b = background.b, .a = background.a },
            ) orelse return makeError(),
        };
    }

    pub fn renderTextBlended(self: Font, text: [:0]const u8, foreground: sdl.Color) !sdl.Surface {
        return sdl.Surface{
            .ptr = sdl.c.TTF_RenderText_Blended(
                self.ptr,
                text.ptr,
                .{ .r = foreground.r, .g = foreground.g, .b = foreground.b, .a = foreground.a },
            ) orelse return makeError(),
        };
    }

    pub fn close(self: Font) void {
        sdl.c.TTF_CloseFont(self.ptr);
    }
};

pub fn makeError() error{TtfError} {
    if (sdl.c.TTF_GetError()) |ptr| {
        std.log.debug("{s}\n", .{
            std.mem.span(ptr),
        });
    }
    return error.TtfError;
}

pub fn openFont(file: [:0]const u8, point_size: c_int) !Font {
    if (sdl.c.TTF_OpenFont(file.ptr, point_size)) |value| {
        return Font{ .ptr = value };
    } else {
        return makeError();
    }
}

pub fn openFontMem(file: [:0]const u8, free: bool, point_size: c_int) !Font {
    const rw = sdl.c.SDL_RWFromConstMem(
        @ptrCast(*const anyopaque, &file[0]),
        @intCast(c_int, file.len),
    ) orelse return makeError();

    return openFontRw(rw, free, point_size);
}

pub fn openFontRw(src: *sdl.c.SDL_RWops, free: bool, point_size: c_int) !Font {
    if (sdl.c.TTF_OpenFontRW(src, @boolToInt(free), point_size)) |value| {
        return Font{ .ptr = value };
    } else {
        return makeError();
    }
}
