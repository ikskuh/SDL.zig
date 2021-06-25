//! SDL2 Zig SDK
//! ============
//! This file provides a build api that allows you to link and use
//! SDL2 from build.zig.
//!
//!
const std = @import("std");

const Builder = std.build.Builder;
const FileSource = std.build.FileSource;
const LibExeObjStep = std.build.LibExeObjStep;

const Sdk = @This();

fn sdkRoot() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

builder: *Builder,
config_path: []const u8,

pub fn init(b: *Builder) *Sdk {
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");
    sdk.* = .{
        .builder = b,
        .config_path = std.fs.path.join(b.allocator, &[_][]const u8{
            b.pathFromRoot(".build_config"),
            "sdl.json",
        }) catch @panic("out of memory"),
    };
    return sdk;
}

/// Returns a package with the raw SDL api with proper argument types, but no functional/logical changes
/// for a more *ziggy* feeling.
/// This is similar to the *C import* result.
pub fn getNativePackage(sdk: *Sdk, package_name: []const u8) std.build.Pkg {
    return std.build.Pkg{
        .name = sdk.builder.dupe(package_name),
        .path = .{ .path = sdkRoot() ++ "/src/binding/sdl.zig" },
    };
}

/// Returns the smart wrapper for the SDL api. Contains convenient zig types, tagged unions and so on.
pub fn getWrapperPackage(sdk: *Sdk, package_name: []const u8) std.build.Pkg {
    return std.build.Pkg{
        .name = sdk.builder.dupe(package_name),
        .path = .{ .path = sdkRoot() ++ "/src/lib.zig" },
    };
}

/// Links SDL2 to the given exe and adds required installs if necessary.
/// **Important:** The target of the `exe` must already be set, otherwise the Sdk will do the wrong thing!
pub fn link(sdk: *Sdk, exe: *LibExeObjStep, linkage: std.build.LibExeObjStep.Linkage) void {
    // TODO: Implement

    const b = sdk.builder;
    const target = (std.zig.system.NativeTargetInfo.detect(b.allocator, exe.target) catch @panic("failed to detect native target info!")).target;

    // This is required on all platforms
    exe.linkLibC();

    if (target.os.tag == .windows) {
        // try linking with vcpkg
        // TODO: Implement proper vcpkg support
        exe.addVcpkgPaths(linkage) catch {};
        if (exe.vcpkg_bin_path) |path| {
            exe.linkSystemLibrary("sdl2");
            // we found SDL2 in vcpkg, just install and use this variant
            const src_path = std.fs.path.join(b.allocator, &.{ path, "SDL2.dll" }) catch @panic("out of memory");
            b.installBinFile(src_path, "SDL2.dll");
            return;
        }

        const sdk_paths = sdk.getPaths(target) catch |err| {
            const writer = std.io.getStdErr().writer();

            const target_name = tripleName(sdk.builder.allocator, target) catch @panic("out of memory");

            switch (err) {
                error.FileNotFound => {
                    writer.print("Could not auto-detect SDL2 sdk configuration. Please provide {s} with the following contents filled out:\n", .{
                        sdk.config_path,
                    }) catch @panic("io error");
                    writer.print("{{\n  \"{s}\": {{\n", .{target_name}) catch @panic("io error");
                    writer.writeAll(
                        \\    "include": "<path to sdl2 sdk>/include",
                        \\    "libs": "<path to sdl2 sdk>/lib",
                        \\    "bin": "<path to sdl2 sdk>/bin"
                        \\  }
                        \\}
                        \\
                    ) catch @panic("io error");
                },
                error.MissingTarget => {
                    writer.print("{s} is missing a SDK definition for {s}. Please add the following section to the file and fill the paths:\n", .{
                        sdk.config_path,
                        target_name,
                    }) catch @panic("io error");
                    writer.print("  \"{s}\": {{\n", .{target_name}) catch @panic("io error");
                    writer.writeAll(
                        \\  "include": "<path to sdl2 sdk>/include",
                        \\  "libs": "<path to sdl2 sdk>/lib",
                        \\  "bin": "<path to sdl2 sdk>/bin"
                        \\}
                    ) catch @panic("io error");
                },
                error.InvalidJson => {
                    writer.print("{s} contains invalid JSON. Please fix that file!\n", .{
                        sdk.config_path,
                    }) catch @panic("io error");
                },
                error.InvalidTarget => {
                    writer.print("{s} contains a invalid zig triple. Please fix that file!\n", .{
                        sdk.config_path,
                    }) catch @panic("io error");
                },
            }

            std.os.exit(1);
        };

        // linking on windows is sadly not as trivial as on linux:
        // we have to respect 6 different configurations {x86,x64}-{msvc,mingw}-{dynamic,static}

        if (target.abi == .msvc and linkage != .dynamic)
            @panic("SDL cannot be linked statically for MSVC");

        // These will be added for C-Imports or C files.
        if (target.abi != .msvc) {
            // SDL2 (mingw) ships the SDL include files under `include/SDL2/` which is very inconsitent with
            // all other platforms, so we just remove this prefix here
            const include_path = std.fs.path.join(b.allocator, &[_][]const u8{
                sdk_paths.include,
                "SDL2",
            }) catch @panic("out of memory");
            exe.addIncludeDir(include_path);
        } else {
            exe.addIncludeDir(sdk_paths.include);
        }

        // link the right libraries
        if (target.abi == .msvc) {
            // and links those as normal libraries
            exe.addLibPath(sdk_paths.libs);
            exe.linkSystemLibraryName("SDL2");
        } else {
            const file_name = switch (linkage) {
                .static => "libSDL2.a",
                .dynamic => "libSDL2.dll.a",
            };

            const lib_path = std.fs.path.join(b.allocator, &[_][]const u8{
                sdk_paths.libs,
                file_name,
            }) catch @panic("out of memory");

            exe.addObjectFile(lib_path);

            if (linkage == .static) {
                // link all system libraries required for SDL2:
                const static_libs = [_][]const u8{
                    "setupapi",
                    "user32",
                    "gdi32",
                    "winmm",
                    "imm32",
                    "ole32",
                    "oleaut32",
                    "shell32",
                    "version",
                    "uuid",
                };
                for (static_libs) |lib|
                    exe.linkSystemLibrary(lib);
            }
        }

        if (linkage == .dynamic and exe.kind == .exe) {
            // On window, we need to copy SDL2.dll to the bin directory
            // for executables
            const sdl2_dll_path = std.fs.path.join(sdk.builder.allocator, &[_][]const u8{
                sdk_paths.bin,
                "SDL2.dll",
            }) catch @panic("out of memory");
            sdk.builder.installBinFile(sdl2_dll_path, "SDL2.dll");
        }
    } else if (target.os.tag == .linux) {
        // on linux, we should rely on the system libraries to "just work"
        exe.linkSystemLibrary("sdl2");
    } else if (target.isDarwin()) {
        // on MacOS, we require a brew install
        // requires sdl2 and sdl2_image to be installed via brew
        exe.linkSystemLibrary("sdl2");
    } else {
        // on all other platforms, just try the system way:
        exe.linkSystemLibrary("sdl2");
    }
}

const Paths = struct {
    include: []const u8,
    libs: []const u8,
    bin: []const u8,
};

fn getPaths(sdk: *Sdk, target: std.Target) error{ MissingTarget, FileNotFound, InvalidJson, InvalidTarget }!Paths {
    const json_data = std.fs.cwd().readFileAlloc(sdk.builder.allocator, sdk.config_path, 1 << 20) catch |err| switch (err) {
        error.FileNotFound => return error.FileNotFound,
        else => |e| @panic(@errorName(e)),
    };

    var parser = std.json.Parser.init(sdk.builder.allocator, false);

    var tree = parser.parse(json_data) catch return error.InvalidJson;

    var root_node = tree.root.Object;

    var config_iterator = root_node.iterator();
    while (config_iterator.next()) |entry| {
        std.debug.print("parse config {s}\n", .{entry.key_ptr.*});
        const config_cross_target = std.zig.CrossTarget.parse(.{
            .arch_os_abi = entry.key_ptr.*,
        }) catch return error.InvalidTarget;
        const config_target = (std.zig.system.NativeTargetInfo.detect(sdk.builder.allocator, config_cross_target) catch @panic("out of memory")).target;

        std.debug.print("  triple: {s}-{s}-{s}\n", .{
            config_target.cpu.arch,
            config_target.os.tag,
            config_target.abi,
        });

        if (target.cpu.arch != config_target.cpu.arch)
            continue;
        if (target.os.tag != config_target.os.tag)
            continue;
        if (target.abi != config_target.abi)
            continue;
        // load paths

        const node = entry.value_ptr.*.Object;

        std.debug.print("selected config {s}\n", .{
            tripleName(sdk.builder.allocator, target) catch @panic("out of memory"),
        });

        return Paths{
            .include = node.get("include").?.String,
            .libs = node.get("libs").?.String,
            .bin = node.get("bin").?.String,
        };
    }
    return error.MissingTarget;
}

fn tripleName(allocator: *std.mem.Allocator, target: std.Target) ![]u8 {
    const arch_name = @tagName(target.cpu.arch);
    const os_name = @tagName(target.os.tag);
    const abi_name = @tagName(target.abi);

    return std.fmt.allocPrint(allocator, "{s}-{s}-{s}", .{ arch_name, os_name, abi_name });
}
