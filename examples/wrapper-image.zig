const std = @import("std");
const sdl = @import("sdl2");

pub fn main() !void {
    try sdl.init(.{
        .video = true,
        .events = true,
        .audio = true,
    });
    defer sdl.quit();
    try sdl.image.init(.{ .png = true });
    defer sdl.image.quit();

    var window = try sdl.createWindow(
        "Render Image Demo",
        .{ .centered = {} },
        .{ .centered = {} },
        640,
        480,
        .{ .vis = .shown },
    );
    defer window.destroy();

    var renderer = try sdl.createRenderer(window, null, .{ .accelerated = true });
    defer renderer.destroy();

    const img = @embedFile("zero.png");
    const texture = try sdl.image.loadTextureMem(renderer, img[0..], sdl.image.ImgFormat.png);
    defer texture.destroy();

    mainLoop: while (true) {
        while (sdl.pollEvent()) |ev| {
            switch (ev) {
                .quit => break :mainLoop,
                .key_down => |key| {
                    switch (key.scancode) {
                        .escape => break :mainLoop,
                        else => std.debug.print("Pressed key: {}\n", .{key.scancode}),
                    }
                },
                else => {},
            }
        }

        try renderer.setColorRGB(0xF7, 0xA4, 0x1D);
        try renderer.clear();
        try renderer.copy(texture, null, null);

        renderer.present();
    }
}
