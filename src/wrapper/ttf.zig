const sdl = @import("sdl.zig");
const std = @import("std");

pub fn init() !void {
    if(sdl.c.TTF_Init() == -1)
        return makeError();
}

pub fn quit() void {
    sdl.c.TTF_Quit();
}

pub const Font = struct {
    ptr: *sdl.c.TTF_Font,

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
    if(sdl.c.TTF_OpenFont(file, point_size)) |value| {
        return Font {.ptr = value};
    } else {
        return makeError();
    }
}

pub fn openFontRw(src: *sdl.c.RWops, free: bool, point_size: c_int) !Font {
    if(sdl.c.TTF_OpenFontRW(src, @boolToInt(free), point_size)) |value| {
        return Font {.ptr = value};
    } else {
        return makeError();
    }
}
