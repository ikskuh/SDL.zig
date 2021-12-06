const std = @import("std");
const SDL = @import("sdl2");

pub fn main() !void {
    try SDL.init(.{
        .video = true,
        .events = true,
        .audio = true,
    });
    defer SDL.quit();

    var window = try SDL.createWindow(
        "SDL.zig Basic Demo",
        .{ .centered = {} },
        .{ .centered = {} },
        640,
        480,
        .{ .shown = true },
    );
    defer window.destroy();

    var renderer = try SDL.createRenderer(window, null, .{ .accelerated = true });
    defer renderer.destroy();

    mainLoop: while (true) {
        while (SDL.pollEvent()) |ev| {
            switch (ev) {
                .quit => {
                    break :mainLoop;
                },
                .key_down => |key| {
                    switch (key.scancode) {
                        .escape => break :mainLoop,
                        else => std.log.info("key pressed: {}\n", .{key.scancode}),
                    }
                },

                else => {},
            }
        }

        try renderer.setColorRGB(0, 0, 0);
        try renderer.clear();

        try renderer.setColor(SDL.Color.parse("#F7A41D") catch unreachable);
        try renderer.drawRect(SDL.Rectangle{
            .x = 270,
            .y = 215,
            .width = 100,
            .height = 50,
        });

        renderer.present();
    }
}
