const std = @import("std");

test "all decls" {
    std.testing.refAllDecls(@import("sdl.zig"));
}
