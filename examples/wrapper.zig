const std = @import("std");
const SDL = @import("sdl2");
const target_os = @import("builtin").os;

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
        .{ .vis = .shown },
    );
    defer window.destroy();

    var renderer = try SDL.createRenderer(window, null, .{ .accelerated = true });
    defer renderer.destroy();

    const p = [_]SDL.Point{ .{.x = 0, .y = 0 }, .{ .x = 200, .y = 10 },
                            .{ .x = 100, .y = 300 }, .{ .x = 400, .y = 400 }};
    
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

        try renderer.setColor(SDL.Color.parse("#22A41D") catch unreachable);
        try renderer.drawLines(&p);

        try renderer.setColor(SDL.Color.parse("#FF0000") catch unreachable);
        try renderer.drawPoints(&p);


        if (target_os.tag != .linux) {
            // Ubuntu CI doesn't have this function available yet
            try renderer.drawGeometry(
                null,
                &[_]SDL.Vertex{
                    .{
                        .position = .{ .x = 400, .y = 150 },
                        .color = SDL.Color.rgb(255, 0, 0),
                    },
                    .{
                        .position = .{ .x = 350, .y = 200 },
                        .color = SDL.Color.rgb(0, 0, 255),
                    },
                    .{
                        .position = .{ .x = 450, .y = 200 },
                        .color = SDL.Color.rgb(0, 255, 0),
                    },
                },
                null,
            );
        }

        renderer.present();
    }
}
