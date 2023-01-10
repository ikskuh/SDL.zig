const std = @import("std");

const emit_comment = true;
const short_names = true;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const argv = try std.process.argsAlloc(allocator);

    if (argv.len != 3) @panic("invalid args");

    const entries: []ApiEntry = blk: {
        const json_data = try std.fs.cwd().readFileAlloc(allocator, argv[1], 10_000_000);

        var token_stream = std.json.TokenStream.init(json_data);

        break :blk try std.json.parse([]ApiEntry, &token_stream, .{
            .allocator = allocator,
        });
    };

    var outfile = try std.fs.cwd().createFile(argv[2], .{});
    defer outfile.close();

    var bufferd_writer = std.io.bufferedWriter(outfile.writer());

    const writer = bufferd_writer.writer();

    try writer.writeAll(
        \\const std = @import("std");
        \\
        \\
    );

    for (entries) |entry| {
        std.debug.assert(entry.parameter.len == entry.parameter_name.len);

        // render comment:
        if (emit_comment) {
            var lines = std.mem.split(u8, entry.comment, "\n");
            while (lines.next()) |line| {
                const comment = if (std.mem.startsWith(u8, line, "/**"))
                    line[3..]
                else if (std.mem.startsWith(u8, line, " * "))
                    line[3..]
                else if (std.mem.startsWith(u8, line, " */"))
                    line[3..]
                else if (std.mem.startsWith(u8, line, " *"))
                    line[2..]
                else
                    line;

                try writer.print("/// {s}\n", .{comment});
            }
        }

        if (short_names) {
            try writer.print("pub const {} = {};\n", .{ std.zig.fmtId(removePrefix(entry.name)), std.zig.fmtId(entry.name) });
            try writer.print("extern fn {}(", .{std.zig.fmtId(entry.name)});
        } else {
            try writer.print("pub extern fn {}(", .{std.zig.fmtId(entry.name)});
        }

        if (entry.parameter.len == 1 and std.mem.eql(u8, entry.parameter[0], "void") and std.mem.eql(u8, entry.parameter_name[0], "")) {
            // special case: "retval name(void)" parameter, so "none"
        } else {
            try writer.writeAll("\n");
            for (entry.parameter) |raw_param_type, i| {
                const param_name = entry.parameter_name[i];

                var output_buffer: [1024]u8 = undefined;

                const param_type_len = std.mem.replacementSize(u8, raw_param_type, "REWRITE_NAME", "");

                const replacement_count = std.mem.replace(u8, raw_param_type, "REWRITE_NAME", "", &output_buffer);
                // std.debug.assert(replacement_count == 1);
                _ = replacement_count;
                const param_type = output_buffer[0..param_type_len];

                if (std.mem.eql(u8, param_type, "...")) {
                    try writer.print("    ...,\n", .{});
                } else {
                    try writer.print("    {}: {},\n", .{
                        std.zig.fmtId(param_name),
                        CType.new(param_type),
                    });
                }
            }
        }

        try writer.print(") {};\n\n", .{
            CType.new(entry.retval),
        });
    }

    try bufferd_writer.flush();
}

fn removePrefix(name: []const u8) []const u8 {
    return if (std.mem.startsWith(u8, name, "SDL_"))
        name[4..]
    else
        name;
}

const CType = struct {
    decl: []const u8,

    pub fn new(text: []const u8) CType {
        return CType{ .decl = std.mem.trim(u8, text, " \t") };
    }

    pub fn format(ctype: CType, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;

        var decl_buffer: [1024]u8 = undefined;
        var decl_writer = std.io.fixedBufferStream(&decl_buffer);
        {
            var tokenizer = std.c.Tokenizer{ .buffer = ctype.decl };

            // std.debug.print("translate '{s}': {{", .{decl});
            while (true) {
                const tok = tokenizer.next();
                if (tok.id == .Eof)
                    break;
                if (decl_writer.pos > 0)
                    try decl_writer.writer().writeAll(" ");

                switch (tok.id) {
                    .Identifier => try decl_writer.writer().writeAll(
                        ctype.decl[tok.start..tok.end],
                    ),
                    else => try decl_writer.writer().writeAll(tok.id.symbol()),
                }

                // std.debug.print(" {s}", .{tok.id.symbol()});
            }
            // std.debug.print(" }}\n", .{});
        }

        const decl = decl_writer.getWritten();

        // std.debug.print("{s}\n", .{decl});

        for (well_knowns) |known| {
            if (std.mem.eql(u8, decl, known.c)) {
                if (std.mem.eql(u8, known.zig, "<-skip->")) {
                    return try writer.print("@panic(\"cannot translate {s}\")", .{known.c});
                }
                return try writer.writeAll(known.zig);
            }
        }

        std.debug.print("{s}\n", .{decl});
    }

    const WellKnown = struct {
        c: []const u8,
        zig: []const u8,
    };

    fn wellKnown(c: []const u8, zig: []const u8) WellKnown {
        return WellKnown{ .c = c, .zig = zig };
    }

    fn objectPtr(comptime name: []const u8) WellKnown {
        return WellKnown{
            .c = comptime (name ++ " *"),
            .zig = comptime ("?*" ++ name),
        };
    }

    fn literal(comptime name: []const u8) WellKnown {
        return WellKnown{ .c = name, .zig = name };
    }

    const well_knowns = [_]WellKnown{
        // AUX:
        wellKnown("void", "void"),
        wellKnown("va_list", "va_list"),
        wellKnown("...", "..."),

        // C  integers:
        wellKnown("short", "c_short"),
        wellKnown("int", "c_int"),
        wellKnown("long", "c_long"),
        wellKnown("unsigned short", "c_ushort"),
        wellKnown("unsigned int", "c_uint"),
        wellKnown("unsigned long", "c_ulong"),
        wellKnown("size_t", "usize"),

        // C floats:
        wellKnown("float", "f32"),
        wellKnown("double", "f64"),

        // SDL integers:
        wellKnown("Sint8", "i8"),
        wellKnown("Sint16", "i16"),
        wellKnown("Sint32", "i32"),
        wellKnown("Sint64", "i64"),
        wellKnown("Uint8", "u8"),
        wellKnown("Uint16", "u16"),
        wellKnown("Uint32", "u32"),
        wellKnown("Uint64", "u64"),
        wellKnown("SDL_bool", "bool"),

        // pointers:
        wellKnown("const size_t", "usize"),
        wellKnown("char *", "?[*:0]u8"),
        wellKnown("char * *", "?[*c][*c]u8"),
        wellKnown("char * [ ]", "?[*c][*c]u8"),
        wellKnown("const char * *", "?[*c]const [*c]u8"),
        wellKnown("wchar_t *", "?[*:0]c_wchar"),
        wellKnown("const char *", "?[*:0]const u8"),
        wellKnown("const wchar_t *", "?[*:0]const c_wchar"),
        wellKnown("void *", "?*anyopaque"),
        wellKnown("const void *", "?*const anyopaque"),
        wellKnown("const Uint8 *", "?[*]const u8"),
        wellKnown("float *", "*f32"),
        wellKnown("double *", "*f64"),
        wellKnown("int *", "*c_int"),
        wellKnown("size_t *", "*usize"),
        wellKnown("void * *", "[*c][*c]anyopaque"),
        wellKnown("unsigned int *", "?*c_uint"),

        wellKnown("Uint32 *", "?*u32"),
        wellKnown("Uint8 *", "?*u8"),
        wellKnown("Uint8 * *", "?[*c][*c]u8"),
        wellKnown("const double", "?*const f64"),
        wellKnown("const float *", "?*const f32"),
        wellKnown("const int *", "?*const c_int"),
        wellKnown("const unsigned char *", "?[*c]const u8"),
        wellKnown("unsigned char *", "?[*c]u8"),

        // SDL types:
        literal("SDL_SystemCursor"),
        literal("SDL_Keymod"),
        literal("SDL_Scancode"),
        literal("SDL_Keycode"),
        literal("SDL_LogPriority"),
        literal("SDL_LogOutputFunction"),
        literal("SDL_TouchID"),
        literal("SDL_TouchDeviceType"),
        literal("SDL_eventaction"),
        literal("SDL_EventFilter"),
        literal("SDL_JoystickID"),
        literal("SDL_JoystickGUID"),
        literal("SDL_JoystickType"),
        literal("SDL_JoystickPowerLevel"),

        literal("SDL_malloc_func"),
        literal("SDL_calloc_func"),
        literal("SDL_realloc_func"),
        literal("SDL_free_func"),

        literal("SDL_iconv_t"),
        literal("SDL_main_func"),
        literal("SDL_SensorID"),
        literal("SDL_HintPriority"),
        literal("SDL_SensorType"),
        literal("SDL_HintCallback"),
        literal("SDL_FunctionPointer"),
        literal("VkInstance"),
        literal("SDL_GamepadType"),
        literal("SDL_GamepadAxis"),
        literal("SDL_GamepadBinding"),
        literal("SDL_GamepadBinding"),

        literal("SDL_AssertState"),
        literal("SDL_AssertionHandler"),
        literal("SDL_AudioDeviceID"),
        literal("SDL_AudioFormat"),
        literal("SDL_AudioStatus"),
        literal("SDL_BlendFactor"),
        literal("SDL_BlendMode"),
        literal("SDL_BlendOperation"),
        literal("SDL_DisplayOrientation"),
        literal("SDL_EGLAttribArrayCallback"),
        literal("SDL_EGLConfig"),
        literal("SDL_EGLDisplay"),
        literal("SDL_EGLIntArrayCallback"),
        literal("SDL_EGLSurface"),
        literal("SDL_FlashOperation"),
        literal("SDL_GLContext"),
        literal("SDL_GLattr"),
        literal("SDL_GUID"),
        literal("SDL_GamepadButton"),
        literal("SDL_HitTest"),
        literal("SDL_MetalView"),
        literal("SDL_PowerState"),
        literal("SDL_ScaleMode"),
        literal("pfnSDL_CurrentBeginThread"),
        literal("pfnSDL_CurrentEndThread"),
        literal("SDL_TLSID"),
        literal("SDL_ThreadFunction"),
        literal("SDL_ThreadPriority"),
        literal("SDL_TimerCallback"),
        literal("SDL_TimerID"),
        literal("SDL_WinRT_DeviceFamily"),
        literal("SDL_WinRT_Path"),
        literal("SDL_WindowID"),
        literal("SDL_WindowsMessageHook"),
        literal("SDL_YUV_CONVERSION_MODE"),
        literal("SDL_errorcode"),
        literal("SDL_threadID"),

        // SDL pointers:
        objectPtr("SDL_RWops"),
        objectPtr("SDL_Haptic"),
        objectPtr("SDL_PixelFormat"),
        objectPtr("SDL_Palette"),
        objectPtr("SDL_hid_device"),
        objectPtr("SDL_Surface"),
        objectPtr("SDL_Window"),
        objectPtr("SDL_DisplayMode"),
        objectPtr("SDL_Cursor"),
        objectPtr("SDL_Joystick"),
        objectPtr("SDL_JoystickID"),
        objectPtr("SDL_Finger"),
        objectPtr("SDL_Locale"),
        objectPtr("SDL_Gamepad"),
        objectPtr("SDL_Sensor"),
        objectPtr("SDL_Texture"),
        objectPtr("SDL_Thread"),
        objectPtr("SDL_Renderer"),
        objectPtr("SDL_SensorID"),
        objectPtr("IDirect3DDevice9"),
        objectPtr("ID3D11Device"),
        objectPtr("ID3D12Device"),
        objectPtr("SDL_hid_device_info"),
        objectPtr("SDL_cond"),
        objectPtr("SDL_AudioSpec"),
        objectPtr("SDL_sem"),
        objectPtr("SDL_mutex"),
        objectPtr("SDL_AudioStream"),
        objectPtr("SDL_Rect"),
        objectPtr("SDL_SpinLock"),
        objectPtr("SDL_atomic_t"),
        objectPtr("SDL_Event"),
        objectPtr("SDL_EventFilter"),
        objectPtr("SDL_LogOutputFunction"),
        objectPtr("VkSurfaceKHR"),
        objectPtr("SDL_AssertData"),
        objectPtr("SDL_BlendMode"),
        objectPtr("SDL_AudioCVT"),
        objectPtr("SDL_HapticEffect"),
        objectPtr("SDL_RendererInfo"),
        objectPtr("SDL_ScaleMode"),
        objectPtr("SDL_SysWMinfo"),
        objectPtr("SDL_WindowShapeMode"),
        objectPtr("SDL_version"),
        objectPtr("XTaskQueueHandle"),
        wellKnown("const SDL_AssertData *", "?*const SDL_AssertData"),
        wellKnown("const SDL_Rect *", "?*const SDL_Rect"),
        wellKnown("SDL_FRect *", "?*SDL_FRect"),
        wellKnown("const SDL_FRect *", "?*const SDL_FRect"),
        wellKnown("const SDL_FPoint *", "?*const SDL_FPoint"),
        wellKnown("const SDL_Point *", "?*const SDL_Point"),
        wellKnown("const SDL_VirtualJoystickDesc *", "?*const SDL_VirtualJoystickDesc"),
        wellKnown("Uint16 *", "?[*c]u16"),
        wellKnown("Sint16 *", "?[*c]i16"),
        wellKnown("SDL_malloc_func *", "?*SDL_malloc_func"),
        wellKnown("SDL_calloc_func *", "?*SDL_calloc_func"),
        wellKnown("SDL_realloc_func *", "?*SDL_realloc_func"),
        wellKnown("SDL_free_func *", "?*SDL_free_func"),
        wellKnown("const SDL_MessageBoxData *", "?* const SDL_MessageBoxData"),

        // special:
        wellKnown("SDL_PRINTF_FORMAT_STRING const char *", "[*:0]const u8"),
        wellKnown("SDL_SCANF_FORMAT_STRING const char *", "[*:0]const u8"),
        wellKnown("int ( SDLCALL * ) ( const void * , const void * )", "*const fn(?*const anyopaque, ?*const anyopaque) c_int"),
        wellKnown("SDL_OUT_BYTECAP ( SDL_OUT_BYTECAP ( len ) void * dst * ) void * dst", "<-skip->"),
        wellKnown("SDL_IN_BYTECAP ( SDL_IN_BYTECAP ( len ) const void * src * ) const void * src", "<-skip->"),
        wellKnown("SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( maxlen ) wchar_t * dst * ) wchar_t * dst", "<-skip->"),
        wellKnown("SDL_INOUT_Z_CAP ( SDL_INOUT_Z_CAP ( maxlen ) wchar_t * dst * ) wchar_t * dst", "<-skip->"),
        wellKnown("SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( maxlen ) char * dst * ) char * dst", "<-skip->"),
        wellKnown("SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( dst_bytes ) char * dst * ) char * dst", "<-skip->"),
        wellKnown("SDL_INOUT_Z_CAP ( SDL_INOUT_Z_CAP ( maxlen ) char * dst * ) char * dst", "<-skip->"),
        wellKnown("SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( maxlen ) char * text * ) char * text", "<-skip->"),

        wellKnown("void ( SDLCALL * ) ( void * )", "<-skip->"),

        wellKnown("SDL_Renderer * *", "?[*c]*SDL_Renderer"),
        wellKnown("SDL_Surface * *", "?[*c]*SDL_Surface"),
        wellKnown("SDL_Window * *", "?[*c]*SDL_Window"),
        wellKnown("const SDL_AudioSpec *", "?*const SDL_AudioSpec"),
        wellKnown("const SDL_Color *", "?*const SDL_Color"),
        wellKnown("const SDL_DisplayMode *", "?*const SDL_DisplayMode"),
        wellKnown("const SDL_PixelFormat *", "?*const SDL_PixelFormat"),
        wellKnown("const SDL_RendererFlip", "?*const SDL_RendererFlip"),
        wellKnown("const SDL_Vertex *", "?*const SDL_Vertex"),
        wellKnown("const SDL_Window *", "?*const SDL_Window"),
    };
};

const ApiEntry = struct {
    comment: []const u8 = "",
    header: []const u8 = "",
    name: []const u8 = "",
    parameter: []const []const u8 = &.{},
    parameter_name: []const []const u8 = &.{},
    retval: []const u8 = "",
};
