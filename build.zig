//! SDL2 Zig SDK
//! ============
//! This file provides a build api that allows you to link and use
//! SDL2 from zig.
//!

const std = @import("std");

const Builder = std.Build.Builder;

pub fn build(b: *Builder) !void {
    const sdk = Sdk.init(b, null);

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const sdl_linkage = b.option(std.Build.LibExeObjStep.Linkage, "link", "Defines how to link SDL2 when building with mingw32") orelse .dynamic;

    const skip_tests = b.option(bool, "skip-test", "When set, skips the test suite to be run. This is required for cross-builds") orelse false;

    if (!skip_tests) {
        const lib_test = b.addTest(.{
            .root_source_file = .{ .path = "src/wrapper/sdl.zig" },
            .target = .{ .abi = if (target.isWindows()) target.abi else null },
        });
        lib_test.addModule("sdl-native", sdk.getNativeModule());
        lib_test.linkSystemLibrary("sdl2_image");
        lib_test.linkSystemLibrary("sdl2_ttf");
        if (lib_test.target.isDarwin()) {
            // SDL_TTF
            lib_test.linkSystemLibrary("freetype");
            lib_test.linkSystemLibrary("harfbuzz");
            lib_test.linkSystemLibrary("bz2");
            lib_test.linkSystemLibrary("zlib");
            lib_test.linkSystemLibrary("graphite2");

            // SDL_IMAGE
            lib_test.linkSystemLibrary("jpeg");
            lib_test.linkSystemLibrary("libpng");
            lib_test.linkSystemLibrary("tiff");
            lib_test.linkSystemLibrary("sdl2");
            lib_test.linkSystemLibrary("webp");
        }
        sdk.link(lib_test, .dynamic);

        const test_lib_step = b.step("test", "Runs the library tests.");
        test_lib_step.dependOn(&lib_test.step);
    }

    const demo_wrapper = b.addExecutable(.{
        .name = "demo-wrapper",
        .root_source_file = .{ .path = "examples/wrapper.zig" },
        .target = target,
        .optimize = optimize,
    });
    sdk.link(demo_wrapper, sdl_linkage);
    demo_wrapper.addModule("sdl2", sdk.getWrapperModule());
    demo_wrapper.install();

    const demo_wrapper_image = b.addExecutable(.{
        .name = "demo-wrapper-image",
        .root_source_file = .{ .path = "examples/wrapper-image.zig" },
        .target = target,
        .optimize = optimize,
    });
    sdk.link(demo_wrapper_image, sdl_linkage);
    demo_wrapper_image.addModule("sdl2", sdk.getWrapperModule());
    demo_wrapper_image.linkSystemLibrary("sdl2_image");
    demo_wrapper_image.linkSystemLibrary("jpeg");
    demo_wrapper_image.linkSystemLibrary("libpng");
    demo_wrapper_image.linkSystemLibrary("tiff");
    demo_wrapper_image.linkSystemLibrary("webp");
    demo_wrapper_image.install();

    const demo_native = b.addExecutable(.{
        .name = "demo-native",
        .root_source_file = .{ .path = "examples/native.zig" },
        .target = target,
        .optimize = optimize,
    });
    sdk.link(demo_native, sdl_linkage);
    demo_native.addModule("sdl2", sdk.getNativeModule());
    demo_native.install();

    const run_demo_wrappr = demo_wrapper.run();
    run_demo_wrappr.step.dependOn(&demo_wrapper.install_step.?.step);

    const run_demo_wrappr_image = demo_wrapper_image.run();
    run_demo_wrappr_image.step.dependOn(&demo_wrapper_image.install_step.?.step);

    const run_demo_native = demo_native.run();
    run_demo_native.step.dependOn(&demo_native.install_step.?.step);

    const run_demo_wrapper_step = b.step("run-wrapper", "Runs the demo for the SDL2 wrapper library");
    run_demo_wrapper_step.dependOn(&run_demo_wrappr.step);

    const run_demo_wrapper_image_step = b.step("run-wrapper-image", "Runs the demo for the SDL2 wrapper library");
    run_demo_wrapper_image_step.dependOn(&run_demo_wrappr_image.step);

    const run_demo_native_step = b.step("run-native", "Runs the demo for the SDL2 native library");
    run_demo_native_step.dependOn(&run_demo_native.step);
}

const host_system = @import("builtin").target;

const Build = std.Build;
const Step = Build.Step;
const FileSource = Build.FileSource;
const GeneratedFile = Build.GeneratedFile;
const LibExeObjStep = Build.LibExeObjStep;

const Sdk = @This();

fn sdkPath(comptime suffix: []const u8) []const u8 {
    if (suffix[0] != '/') @compileError("relToPath requires an absolute path!");
    return comptime blk: {
        const root_dir = std.fs.path.dirname(@src().file) orelse ".";
        break :blk root_dir ++ suffix;
    };
}

const sdl2_symbol_definitions = @embedFile("stubs/libSDL2.def");

build: *Build,
config_path: []const u8,

prepare_sources: *PrepareStubSourceStep,

/// Creates a instance of the Sdk and initializes internal steps.
/// Initialize once, use everywhere (in your `build` function).
pub fn init(b: *Build, maybe_config_path: ?[]const u8) *Sdk {
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");
    const config_path = maybe_config_path orelse std.fs.path.join(
        b.allocator,
        &[_][]const u8{
            b.pathFromRoot(".build_config"),
            "sdl.json",
        },
    ) catch @panic("out of memory");

    sdk.* = .{
        .build = b,
        .config_path = config_path,
        .prepare_sources = undefined,
    };
    sdk.prepare_sources = PrepareStubSourceStep.create(sdk);

    return sdk;
}

/// Returns a module with the raw SDL api with proper argument types, but no functional/logical changes
/// for a more *ziggy* feeling.
/// This is similar to the *C import* result.
pub fn getNativeModule(sdk: *Sdk) *Build.Module {
    const build_options = sdk.build.addOptions();
    build_options.addOption(bool, "vulkan", false);
    return sdk.build.createModule(.{
        .source_file = .{ .path = sdkPath("/src/binding/sdl.zig") },
        .dependencies = &.{
            .{
                .name = sdk.build.dupe("build_options"),
                .module = build_options.createModule(),
            },
        },
    });
}

/// Returns a module with the raw SDL api with proper argument types, but no functional/logical changes
/// for a more *ziggy* feeling, with Vulkan support! The Vulkan module provided by `vulkan-zig` must be
/// provided as an argument.
/// This is similar to the *C import* result.
pub fn getNativeModuleVulkan(sdk: *Sdk, vulkan: *Build.Module) *Build.Module {
    const build_options = sdk.build.addOptions();
    build_options.addOption(bool, "vulkan", true);
    return sdk.build.createModule(.{
        .source_file = .{ .path = sdkPath("/src/binding/sdl.zig") },
        .dependencies = &.{
            .{
                .name = sdk.build.dupe("build_options"),
                .module = build_options.createModule(),
            },
            .{
                .name = sdk.build.dupe("vulkan"),
                .module = vulkan,
            },
        },
    });
}

/// Returns the smart wrapper for the SDL api. Contains convenient zig types, tagged unions and so on.
pub fn getWrapperModule(sdk: *Sdk) *Build.Module {
    return sdk.build.createModule(.{
        .source_file = .{ .path = sdkPath("/src/wrapper/sdl.zig") },
        .dependencies = &.{
            .{
                .name = sdk.build.dupe("sdl-native"),
                .module = sdk.getNativeModule(),
            },
        },
    });
}

/// Returns the smart wrapper with Vulkan support. The Vulkan module provided by `vulkan-zig` must be
/// provided as an argument.
pub fn getWrapperModuleVulkan(sdk: *Sdk, vulkan: *Build.Module) *Build.Module {
    return sdk.build.createModule(.{
        .source_file = .{ .path = sdkPath("/src/wrapper/sdl.zig") },
        .dependencies = &.{
            .{
                .name = sdk.build.dupe("vulkan"),
                .module = vulkan,
            },
        },
    });
}

pub fn linkTtf(_: *Sdk, exe: *LibExeObjStep) void {
    const target = (std.zig.system.NativeTargetInfo.detect(exe.target) catch @panic("failed to detect native target info!")).target;

    // This is required on all platforms
    exe.linkLibC();

    if (target.os.tag == .linux) {
        exe.linkSystemLibrary("sdl2_ttf");
    } else if (target.os.tag == .windows) {
        @compileError("Not implemented yet");
    } else if (target.isDarwin()) {

        // on MacOS, we require a brew install
        // requires sdl_ttf to be installed via brew

        exe.linkSystemLibrary("sdl2_ttf");
        exe.linkSystemLibrary("freetype");
        exe.linkSystemLibrary("harfbuzz");
        exe.linkSystemLibrary("bz2");
        exe.linkSystemLibrary("zlib");
        exe.linkSystemLibrary("graphite2");
    } else {
        // on all other platforms, just try the system way:
        exe.linkSystemLibrary("sdl2_ttf");
    }
}

/// Links SDL2 to the given exe and adds required installs if necessary.
/// **Important:** The target of the `exe` must already be set, otherwise the Sdk will do the wrong thing!
pub fn link(sdk: *Sdk, exe: *LibExeObjStep, linkage: LibExeObjStep.Linkage) void {
    // TODO: Implement

    const b = sdk.build;
    const target = (std.zig.system.NativeTargetInfo.detect(exe.target) catch @panic("failed to detect native target info!")).target;
    const is_native = exe.target.isNative();

    // This is required on all platforms
    exe.linkLibC();

    if (target.os.tag == .linux and !is_native) {
        // for cross-compilation to Linux, we use a magic trick:
        // we compile a stub .so file we will link against an SDL2.so even if that file
        // doesn't exist on our system

        const build_linux_sdl_stub = b.addSharedLibrary(.{
            .name = "SDL2",
            .target = exe.target,
            .optimize = exe.optimize,
        });
        build_linux_sdl_stub.addAssemblyFileSource(sdk.prepare_sources.getStubFile());

        // We need to link against libc
        exe.linkLibC();

        // link against the output of our stub
        exe.linkLibrary(build_linux_sdl_stub);
    } else if (target.os.tag == .linux) {
        // on linux with compilation for native target,
        // we should rely on the system libraries to "just work"
        exe.linkSystemLibrary("sdl2");
    } else if (target.os.tag == .windows) {
        // try linking with vcpkg
        // TODO: Implement proper vcpkg support
        exe.addVcpkgPaths(linkage) catch {};
        if (exe.vcpkg_bin_path) |path| {

            // we found SDL2 in vcpkg, just install and use this variant
            const src_path = std.fs.path.join(b.allocator, &.{ path, "SDL2.dll" }) catch @panic("out of memory");

            if (std.fs.cwd().access(src_path, .{})) {
                // we found SDL2.dll, so just link via vcpkg:
                exe.linkSystemLibrary("sdl2");
                b.installBinFile(src_path, "SDL2.dll");
                return;
            } else |_| {
                //
            }
        }

        const sdk_paths = sdk.getPaths(target) catch |err| {
            const writer = std.io.getStdErr().writer();

            const target_name = tripleName(sdk.build.allocator, target) catch @panic("out of memory");

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
                    writer.writeAll(
                        \\
                        \\You can obtain a SDL2 sdk for windows from https://www.libsdl.org/download-2.0.php
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
                    writer.writeAll(
                        \\
                        \\You can obtain a SDL2 sdk for windows from https://www.libsdl.org/download-2.0.php
                        \\
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
            exe.addIncludePath(include_path);
        } else {
            exe.addIncludePath(sdk_paths.include);
        }

        // link the right libraries
        if (target.abi == .msvc) {
            // and links those as normal libraries
            exe.addLibraryPath(sdk_paths.libs);
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
            const sdl2_dll_path = std.fs.path.join(sdk.build.allocator, &[_][]const u8{
                sdk_paths.bin,
                "SDL2.dll",
            }) catch @panic("out of memory");
            sdk.build.installBinFile(sdl2_dll_path, "SDL2.dll");
        }
    } else if (target.isDarwin()) {
        // TODO: Implement cross-compilaton to macOS via system root provisioning
        if (!host_system.os.tag.isDarwin())
            @panic("Cannot cross-compile to macOS yet.");

        // on MacOS, we require a brew install
        // requires sdl2 and sdl2_image to be installed via brew
        exe.linkSystemLibrary("sdl2");

        exe.linkFramework("IOKit");
        exe.linkFramework("Cocoa");
        exe.linkFramework("CoreAudio");
        exe.linkFramework("Carbon");
        exe.linkFramework("Metal");
        exe.linkFramework("QuartzCore");
        exe.linkFramework("AudioToolbox");
        exe.linkFramework("ForceFeedback");
        exe.linkFramework("GameController");
        exe.linkFramework("CoreHaptics");
        exe.linkSystemLibrary("iconv");
    } else {
        const triple_string = target.zigTriple(b.allocator) catch "unkown-unkown-unkown";
        std.log.warn("Linking SDL2 for {s} is not tested, linking might fail!", .{triple_string});

        // on all other platforms, just try the system way:
        exe.linkSystemLibrary("sdl2");
    }
}

const Paths = struct {
    include: []const u8,
    libs: []const u8,
    bin: []const u8,
};

fn getPaths(sdk: *Sdk, target_local: std.Target) error{ MissingTarget, FileNotFound, InvalidJson, InvalidTarget }!Paths {
    const json_data = std.fs.cwd().readFileAlloc(sdk.build.allocator, sdk.config_path, 1 << 20) catch |err| switch (err) {
        error.FileNotFound => return error.FileNotFound,
        else => |e| @panic(@errorName(e)),
    };

    var parser = std.json.Parser.init(sdk.build.allocator, false);

    var tree = parser.parse(json_data) catch return error.InvalidJson;

    var root_node = tree.root.Object;

    var config_iterator = root_node.iterator();
    while (config_iterator.next()) |entry| {
        const config_cross_target = std.zig.CrossTarget.parse(.{
            .arch_os_abi = entry.key_ptr.*,
        }) catch return error.InvalidTarget;
        const config_target = (std.zig.system.NativeTargetInfo.detect(config_cross_target) catch @panic("out of memory")).target;

        if (target_local.cpu.arch != config_target.cpu.arch)
            continue;
        if (target_local.os.tag != config_target.os.tag)
            continue;
        if (target_local.abi != config_target.abi)
            continue;
        // load paths

        const node = entry.value_ptr.*.Object;

        return Paths{
            .include = node.get("include").?.String,
            .libs = node.get("libs").?.String,
            .bin = node.get("bin").?.String,
        };
    }
    return error.MissingTarget;
}

const PrepareStubSourceStep = struct {
    const Self = @This();

    step: Step,
    sdk: *Sdk,

    assembly_source: GeneratedFile,

    pub fn create(sdk: *Sdk) *PrepareStubSourceStep {
        const psss = sdk.build.allocator.create(Self) catch @panic("out of memory");

        psss.* = .{
            .step = Step.init(
                .{
                    .id = .custom,
                    .name = "Prepare SDL2 stub sources",
                    .owner = sdk.build,
                    .makeFn = make,
                },
            ),
            .sdk = sdk,
            .assembly_source = .{ .step = &psss.step },
        };

        return psss;
    }

    pub fn getStubFile(self: *Self) FileSource {
        return .{ .generated = &self.assembly_source };
    }

    fn make(step: *Step, prog_node: *std.Progress.Node) !void {
        _ = prog_node;
        const self = @fieldParentPtr(Self, "step", step);

        var cache = CacheBuilder.init(self.sdk.build, "sdl");

        cache.addBytes(sdl2_symbol_definitions);

        var dirpath = try cache.createAndGetDir();
        defer dirpath.dir.close();

        var file = try dirpath.dir.createFile("sdl.S", .{});
        defer file.close();

        var writer = file.writer();
        try writer.writeAll(".text\n");

        var iter = std.mem.split(u8, sdl2_symbol_definitions, "\n");
        while (iter.next()) |line| {
            const sym = std.mem.trim(u8, line, " \r\n\t");
            if (sym.len == 0)
                continue;
            try writer.print(".global {s}\n", .{sym});
            try writer.writeAll(".align 4\n");
            try writer.print("{s}:\n", .{sym});
            try writer.writeAll("  .byte 0\n");
        }

        self.assembly_source.path = try std.fs.path.join(self.sdk.build.allocator, &[_][]const u8{
            dirpath.path,
            "sdl.S",
        });
    }
};

fn tripleName(allocator: std.mem.Allocator, target_local: std.Target) ![]u8 {
    const arch_name = @tagName(target_local.cpu.arch);
    const os_name = @tagName(target_local.os.tag);
    const abi_name = @tagName(target_local.abi);

    return std.fmt.allocPrint(allocator, "{s}-{s}-{s}", .{ arch_name, os_name, abi_name });
}

const CacheBuilder = struct {
    const Self = @This();

    build: *std.Build,
    hasher: std.crypto.hash.Sha1,
    subdir: ?[]const u8,

    pub fn init(builder: *std.Build, subdir: ?[]const u8) Self {
        return Self{
            .build = builder,
            .hasher = std.crypto.hash.Sha1.init(.{}),
            .subdir = if (subdir) |s|
                builder.dupe(s)
            else
                null,
        };
    }

    pub fn addBytes(self: *Self, bytes: []const u8) void {
        self.hasher.update(bytes);
    }

    pub fn addFile(self: *Self, file: FileSource) !void {
        const path = file.getPath(self.build);

        const data = try std.fs.cwd().readFileAlloc(self.build.allocator, path, 1 << 32); // 4 GB
        defer self.build.allocator.free(data);

        self.addBytes(data);
    }

    fn createPath(self: *Self) ![]const u8 {
        var hash: [20]u8 = undefined;
        self.hasher.final(&hash);

        const path = if (self.subdir) |subdir|
            try std.fmt.allocPrint(
                self.build.allocator,
                "{s}/{s}/o/{}",
                .{
                    self.build.cache_root.path.?,
                    subdir,
                    std.fmt.fmtSliceHexLower(&hash),
                },
            )
        else
            try std.fmt.allocPrint(
                self.build.allocator,
                "{s}/o/{}",
                .{
                    self.build.cache_root.path.?,
                    std.fmt.fmtSliceHexLower(&hash),
                },
            );

        return path;
    }

    pub const DirAndPath = struct {
        dir: std.fs.Dir,
        path: []const u8,
    };
    pub fn createAndGetDir(self: *Self) !DirAndPath {
        const path = try self.createPath();
        return DirAndPath{
            .path = path,
            .dir = try std.fs.cwd().makeOpenPath(path, .{}),
        };
    }

    pub fn createAndGetPath(self: *Self) ![]const u8 {
        const path = try self.createPath();
        try std.fs.cwd().makePath(path);
        return path;
    }
};
