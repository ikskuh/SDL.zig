//! SDL2 Zig SDK
//! ============
//! This file provides a build api that allows you to link and use
//! SDL2 from zig.
//!

const std = @import("std");
const builtin = @import("builtin");

pub const Library = enum { SDL2, SDL2_ttf };

pub fn build(b: *std.Build) !void {
    const sdk = Sdk.init(b, .{ .dep_name = null });

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const sdl_linkage = b.option(std.builtin.LinkMode, "link", "Defines how to link SDL2 when building with mingw32") orelse .dynamic;

    const skip_tests = b.option(bool, "skip-test", "When set, skips the test suite to be run. This is required for cross-builds") orelse false;

    if (!skip_tests) {
        const lib_test = b.addTest(.{
            .root_source_file = .{ .cwd_relative = "src/wrapper/sdl.zig" },
            .target = if (target.result.os.tag == .windows)
                b.resolveTargetQuery(.{ .abi = target.result.abi })
            else
                null,
        });
        lib_test.root_module.addImport("sdl-native", sdk.getNativeModule());
        lib_test.linkSystemLibrary("sdl2_image");
        lib_test.linkSystemLibrary("sdl2_ttf");
        if (lib_test.rootModuleTarget().isDarwinLibC()) {
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
        sdk.link(lib_test, .dynamic, .SDL2);

        const test_lib_step = b.step("test", "Runs the library tests.");
        test_lib_step.dependOn(&lib_test.step);
    }

    const demo_wrapper = b.addExecutable(.{
        .name = "demo-wrapper",
        .root_source_file = .{ .cwd_relative = "examples/wrapper.zig" },
        .target = target,
        .optimize = optimize,
    });
    sdk.link(demo_wrapper, sdl_linkage, .SDL2);
    demo_wrapper.root_module.addImport("sdl2", sdk.getWrapperModule());
    b.installArtifact(demo_wrapper);

    const demo_wrapper_image = b.addExecutable(.{
        .name = "demo-wrapper-image",
        .root_source_file = .{ .cwd_relative = "examples/wrapper-image.zig" },
        .target = target,
        .optimize = optimize,
    });
    sdk.link(demo_wrapper_image, sdl_linkage, .SDL2);
    demo_wrapper_image.root_module.addImport("sdl2", sdk.getWrapperModule());
    demo_wrapper_image.linkSystemLibrary("sdl2_image");
    demo_wrapper_image.linkSystemLibrary("jpeg");
    demo_wrapper_image.linkSystemLibrary("libpng");
    demo_wrapper_image.linkSystemLibrary("tiff");
    demo_wrapper_image.linkSystemLibrary("webp");

    if (target.query.isNative() and target.result.os.tag == .linux) {
        b.installArtifact(demo_wrapper_image);
    }

    const demo_native = b.addExecutable(.{
        .name = "demo-native",
        .root_source_file = .{ .cwd_relative = "examples/native.zig" },
        .target = target,
        .optimize = optimize,
    });
    sdk.link(demo_native, sdl_linkage, .SDL2);
    demo_native.root_module.addImport("sdl2", sdk.getNativeModule());
    b.installArtifact(demo_native);

    const run_demo_wrappr = b.addRunArtifact(demo_wrapper);

    const run_demo_wrappr_image = b.addRunArtifact(demo_wrapper_image);

    const run_demo_native = b.addRunArtifact(demo_native);

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
const LazyPath = Build.LazyPath;
const GeneratedFile = Build.GeneratedFile;
const Compile = Build.Step.Compile;

const Sdk = @This();

const sdl2_symbol_definitions = @embedFile("stubs/libSDL2.def");

const SdkOption = struct {
    dep_name: ?[]const u8 = "sdl",
    maybe_config_path: ?[]const u8 = null,
    maybe_sdl_ttf_config_path: ?[]const u8 = null,
};

builder: *Build,
sdl_config_path: []const u8,

prepare_sources: *PrepareStubSourceStep,
sdl_ttf_config_path: []const u8,

/// Creates a instance of the Sdk and initializes internal steps.
/// Initialize once, use everywhere (in your `build` function).
pub fn init(b: *Build, opt: SdkOption) *Sdk {
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");

    const sdl_config_path = opt.maybe_config_path orelse std.fs.path.join(
        b.allocator,
        &[_][]const u8{ b.pathFromRoot(".build_config"), "sdl.json" },
    ) catch @panic("out of memory");

    const sdl_ttf_config_path = opt.maybe_sdl_ttf_config_path orelse std.fs.path.join(
        b.allocator,
        &[_][]const u8{ b.pathFromRoot(".build_config"), "sdl_ttf.json" },
    ) catch @panic("out of memory");

    const builder = if (opt.dep_name) |name|
        b.dependency(name, .{}).builder
    else
        b;

    sdk.* = .{
        .builder = builder,
        .sdl_config_path = sdl_config_path,
        .sdl_ttf_config_path = sdl_ttf_config_path,
        .prepare_sources = undefined,
    };
    sdk.prepare_sources = PrepareStubSourceStep.create(sdk);

    return sdk;
}

/// Returns a module with the raw SDL api with proper argument types, but no functional/logical changes
/// for a more *ziggy* feeling.
/// This is similar to the *C import* result.
pub fn getNativeModule(sdk: *Sdk) *Build.Module {
    const build_options = sdk.builder.addOptions();
    build_options.addOption(bool, "vulkan", false);
    return sdk.builder.createModule(.{
        .root_source_file = sdk.builder.path("src/binding/sdl.zig"),
        .imports = &.{
            .{
                .name = sdk.builder.dupe("build_options"),
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
    const build_options = sdk.builder.addOptions();
    build_options.addOption(bool, "vulkan", true);
    return sdk.builder.createModule(.{
        .root_source_file = sdk.builder.path("src/binding/sdl.zig"),
        .imports = &.{
            .{
                .name = sdk.builder.dupe("build_options"),
                .module = build_options.createModule(),
            },
            .{
                .name = sdk.builder.dupe("vulkan"),
                .module = vulkan,
            },
        },
    });
}

/// Returns the smart wrapper for the SDL api. Contains convenient zig types, tagged unions and so on.
pub fn getWrapperModule(sdk: *Sdk) *Build.Module {
    return sdk.builder.createModule(.{
        .root_source_file = sdk.builder.path("src/wrapper/sdl.zig"),
        .imports = &.{
            .{
                .name = sdk.builder.dupe("sdl-native"),
                .module = sdk.getNativeModule(),
            },
        },
    });
}

/// Returns the smart wrapper with Vulkan support. The Vulkan module provided by `vulkan-zig` must be
/// provided as an argument.
pub fn getWrapperModuleVulkan(sdk: *Sdk, vulkan: *Build.Module) *Build.Module {
    return sdk.builder.createModule(.{
        .root_source_file = sdk.builder.path("src/wrapper/sdl.zig"),
        .imports = &.{
            .{
                .name = sdk.builder.dupe("sdl-native"),
                .module = sdk.getNativeModuleVulkan(vulkan),
            },
            .{
                .name = sdk.builder.dupe("vulkan"),
                .module = vulkan,
            },
        },
    });
}

fn linkLinuxCross(sdk: *Sdk, exe: *Compile) !void {
    const build_linux_sdl_stub = sdk.builder.addSharedLibrary(.{
        .name = "SDL2",
        .target = exe.root_module.resolved_target.?,
        .optimize = exe.root_module.optimize.?,
    });
    build_linux_sdl_stub.addAssemblyFile(sdk.prepare_sources.getStubFile());
    exe.linkLibrary(build_linux_sdl_stub);
}

fn linkWindows(
    sdk: *Sdk,
    exe: *Compile,
    linkage: std.builtin.LinkMode,
    comptime library: Library,
    paths: Paths,
) !void {
    exe.addIncludePath(.{ .cwd_relative = paths.include });
    exe.addLibraryPath(.{ .cwd_relative = paths.libs });

    const lib_name = switch (library) {
        .SDL2 => "SDL2",
        .SDL2_ttf => "SDL2_ttf",
    };

    if (exe.root_module.resolved_target.?.result.abi == .msvc) {
        exe.linkSystemLibrary2(lib_name, .{ .use_pkg_config = .no });
    } else {
        const file_name = try std.fmt.allocPrint(sdk.builder.allocator, "lib{s}.{s}", .{
            lib_name,
            if (linkage == .static) "a" else "dll.a",
        });
        defer sdk.builder.allocator.free(file_name);

        const lib_path = try std.fs.path.join(sdk.builder.allocator, &[_][]const u8{ paths.libs, file_name });
        defer sdk.builder.allocator.free(lib_path);

        exe.addObjectFile(.{ .cwd_relative = lib_path });

        if (linkage == .static and library == .SDL2) {
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
            for (static_libs) |lib| exe.linkSystemLibrary(lib);
        }
    }

    if (linkage == .dynamic and exe.kind == .exe) {
        const dll_name = try std.fmt.allocPrint(sdk.builder.allocator, "{s}.dll", .{lib_name});
        defer sdk.builder.allocator.free(dll_name);

        const dll_path = try std.fs.path.join(sdk.builder.allocator, &[_][]const u8{ paths.bin, dll_name });
        defer sdk.builder.allocator.free(dll_path);

        const install_bin = sdk.builder.addInstallBinFile(.{ .cwd_relative = dll_path }, dll_name);
        exe.step.dependOn(&install_bin.step);
    }
}

fn linkMacOS(exe: *Compile, comptime library: Library) !void {
    exe.linkSystemLibrary(switch (library) {
        .SDL2 => "sdl2",
        .SDL2_ttf => "sdl2_ttf",
    });

    switch (library) {
        .SDL2 => {
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
        },
        .SDL2_ttf => {
            exe.linkSystemLibrary("freetype");
            exe.linkSystemLibrary("harfbuzz");
            exe.linkSystemLibrary("bz2");
            exe.linkSystemLibrary("zlib");
            exe.linkSystemLibrary("graphite2");
        },
    }
}

/// Links SDL2 or SDL2_ttf to the given exe and adds required installs if necessary.
/// **Important:** The target of the `exe` must already be set, otherwise the Sdk will do the wrong thing!
pub fn link(
    sdk: *Sdk,
    exe: *Compile,
    linkage: std.builtin.LinkMode,
    comptime library: Library,
) void {
    const b = sdk.builder;
    const target = exe.root_module.resolved_target.?;
    const is_native = target.query.isNativeOs();

    exe.linkLibC();

    if (target.result.os.tag == .linux) {
        if (!is_native) {
            if (library == .SDL2) {
                linkLinuxCross(sdk, exe) catch |err| {
                    std.debug.panic("Failed to link {s} for Linux cross-compilation: {s}", .{ @tagName(library), @errorName(err) });
                };
            } else {
                std.debug.panic("Cross-compilation not supported for {s} on Linux", .{@tagName(library)});
            }
        } else {
            exe.linkSystemLibrary(switch (library) {
                .SDL2 => "sdl2",
                .SDL2_ttf => "sdl2_ttf",
            });
        }
    } else if (target.result.os.tag == .windows) {
        const paths = switch (library) {
            .SDL2 => getPaths(sdk, sdk.sdl_config_path, target, .SDL2),
            .SDL2_ttf => getPaths(sdk, sdk.sdl_ttf_config_path, target, .SDL2_ttf),
        } catch |err| {
            std.debug.panic("Failed to get paths for {s}: {s}", .{ @tagName(library), @errorName(err) });
        };

        linkWindows(sdk, exe, linkage, library, paths) catch |err| {
            std.debug.panic("Failed to link {s} for Windows: {s}", .{ @tagName(library), @errorName(err) });
        };
    } else if (target.result.isDarwinLibC()) {
        if (!host_system.os.tag.isDarwin()) {
            std.debug.panic("Cross-compilation not supported for {s} on macOS", .{@tagName(library)});
        }
        linkMacOS(exe, library) catch |err| {
            std.debug.panic("Failed to link {s} for macOS: {s}", .{ @tagName(library), @errorName(err) });
        };
    } else {
        const triple_string = target.query.zigTriple(b.allocator) catch |err| {
            std.debug.panic("Failed to get target triple: {s}", .{@errorName(err)});
        };
        defer b.allocator.free(triple_string);
        std.log.warn("Linking {s} for {s} is not tested, linking might fail!", .{ @tagName(library), triple_string });
        exe.linkSystemLibrary(switch (library) {
            .SDL2 => "sdl2",
            .SDL2_ttf => "sdl2_ttf",
        });
    }
}

const Paths = struct {
    include: []const u8,
    libs: []const u8,
    bin: []const u8,
};

const GetPathsError = error{
    FileNotFound,
    InvalidJson,
    InvalidTarget,
    MissingTarget,
};

fn printPathsErrorMessage(sdk: *Sdk, config_path: []const u8, target_local: std.Build.ResolvedTarget, err: GetPathsError, library: Library) !void {
    const writer = std.io.getStdErr().writer();
    const target_name = try tripleName(sdk.builder.allocator, target_local);
    defer sdk.builder.allocator.free(target_name);

    const lib_name = switch (library) {
        .SDL2 => "SDL2",
        .SDL2_ttf => "SDL2_ttf",
    };

    const download_url = switch (library) {
        .SDL2 => "https://github.com/libsdl-org/SDL/releases",
        .SDL2_ttf => "https://github.com/libsdl-org/SDL_ttf/releases",
    };

    switch (err) {
        GetPathsError.FileNotFound => {
            try writer.print("Could not auto-detect {s} sdk configuration. Please provide {s} with the following contents filled out:\n", .{ lib_name, config_path });
            try writer.print("{{\n  \"{s}\": {{\n", .{target_name});
            try writer.writeAll(
                \\    "include": "<path to sdk>/include",
                \\    "libs": "<path to sdk>/lib",
                \\    "bin": "<path to sdk>/bin"
                \\  }
                \\}
                \\
            );
            try writer.print(
                \\
                \\You can obtain a {s} sdk for Windows from {s}
                \\
            , .{ lib_name, download_url });
        },
        GetPathsError.MissingTarget => {
            try writer.print("{s} is missing a SDK definition for {s}. Please add the following section to the file and fill the paths:\n", .{ config_path, target_name });
            try writer.print("  \"{s}\": {{\n", .{target_name});
            try writer.writeAll(
                \\  "include": "<path to sdk>/include",
                \\  "libs": "<path to sdk>/lib",
                \\  "bin": "<path to sdk>/bin"
                \\}
            );
            try writer.print(
                \\
                \\You can obtain a {s} sdk for Windows from {s}
                \\
            , .{ lib_name, download_url });
        },
        GetPathsError.InvalidJson => {
            try writer.print("{s} contains invalid JSON. Please fix that file!\n", .{config_path});
        },
        GetPathsError.InvalidTarget => {
            try writer.print("{s} contains an invalid zig triple. Please fix that file!\n", .{config_path});
        },
    }
}

fn getPaths(sdk: *Sdk, config_path: []const u8, target_local: std.Build.ResolvedTarget, library: Library) GetPathsError!Paths {
    const json_data = std.fs.cwd().readFileAlloc(sdk.builder.allocator, config_path, 1 << 20) catch |err| switch (err) {
        error.FileNotFound => {
            printPathsErrorMessage(sdk, config_path, target_local, GetPathsError.FileNotFound, library) catch |e| {
                std.debug.panic("Failed to print error message: {s}", .{@errorName(e)});
            };
            return GetPathsError.FileNotFound;
        },
        else => |e| {
            std.log.err("Failed to read config file: {s}", .{@errorName(e)});
            return GetPathsError.FileNotFound;
        },
    };
    defer sdk.builder.allocator.free(json_data);

    const parsed = std.json.parseFromSlice(std.json.Value, sdk.builder.allocator, json_data, .{}) catch {
        printPathsErrorMessage(sdk, config_path, target_local, GetPathsError.InvalidJson, library) catch |e| {
            std.debug.panic("Failed to print error message: {s}", .{@errorName(e)});
        };
        return GetPathsError.InvalidJson;
    };
    defer parsed.deinit();

    var root_node = parsed.value.object;
    var config_iterator = root_node.iterator();
    while (config_iterator.next()) |entry| {
        const config_target = sdk.builder.resolveTargetQuery(
            std.Target.Query.parse(.{ .arch_os_abi = entry.key_ptr.* }) catch {
                std.log.err("Invalid target in config file: {s}", .{entry.key_ptr.*});
                return GetPathsError.InvalidTarget;
            },
        );

        if (target_local.result.cpu.arch != config_target.result.cpu.arch)
            continue;
        if (target_local.result.os.tag != config_target.result.os.tag)
            continue;
        if (target_local.result.abi != config_target.result.abi)
            continue;

        const node = entry.value_ptr.*.object;

        return Paths{
            .include = sdk.builder.allocator.dupe(u8, node.get("include").?.string) catch @panic("out of memory"),
            .libs = sdk.builder.allocator.dupe(u8, node.get("libs").?.string) catch @panic("out of memory"),
            .bin = sdk.builder.allocator.dupe(u8, node.get("bin").?.string) catch @panic("out of memory"),
        };
    }

    printPathsErrorMessage(sdk, config_path, target_local, GetPathsError.MissingTarget, library) catch |e| {
        std.debug.panic("Failed to print error message: {s}", .{@errorName(e)});
    };
    return GetPathsError.MissingTarget;
}

const PrepareStubSourceStep = struct {
    const Self = @This();

    step: Step,
    sdk: *Sdk,

    assembly_source: GeneratedFile,

    pub fn create(sdk: *Sdk) *PrepareStubSourceStep {
        const psss = sdk.builder.allocator.create(Self) catch @panic("out of memory");

        psss.* = .{
            .step = Step.init(
                .{
                    .id = .custom,
                    .name = "Prepare SDL2 stub sources",
                    .owner = sdk.builder,
                    .makeFn = make,
                },
            ),
            .sdk = sdk,
            .assembly_source = .{ .step = &psss.step },
        };

        return psss;
    }

    pub fn getStubFile(self: *Self) LazyPath {
        return .{ .generated = .{ .file = &self.assembly_source } };
    }

    fn make(step: *Step, make_opt: std.Build.Step.MakeOptions) !void {
        _ = make_opt;
        const self: *Self = @fieldParentPtr("step", step);

        var cache = CacheBuilder.init(self.sdk.builder, "sdl");

        cache.addBytes(sdl2_symbol_definitions);

        var dirpath = try cache.createAndGetDir();
        defer dirpath.dir.close();

        var file = try dirpath.dir.createFile("sdl.S", .{});
        defer file.close();

        var writer = file.writer();
        try writer.writeAll(".text\n");

        var iter = std.mem.splitScalar(u8, sdl2_symbol_definitions, '\n');
        while (iter.next()) |line| {
            const sym = std.mem.trim(u8, line, " \r\n\t");
            if (sym.len == 0)
                continue;
            try writer.print(".global {s}\n", .{sym});
            try writer.writeAll(".align 4\n");
            try writer.print("{s}:\n", .{sym});
            try writer.writeAll("  .byte 0\n");
        }

        self.assembly_source.path = try std.fs.path.join(self.sdk.builder.allocator, &[_][]const u8{
            dirpath.path,
            "sdl.S",
        });
    }
};

fn tripleName(allocator: std.mem.Allocator, target_local: std.Build.ResolvedTarget) ![]u8 {
    const arch_name = @tagName(target_local.result.cpu.arch);
    const os_name = @tagName(target_local.result.os.tag);
    const abi_name = @tagName(target_local.result.abi);

    return std.fmt.allocPrint(allocator, "{s}-{s}-{s}", .{ arch_name, os_name, abi_name });
}

const CacheBuilder = struct {
    const Self = @This();

    builder: *std.Build,
    hasher: std.crypto.hash.Sha1,
    subdir: ?[]const u8,

    pub fn init(builder: *std.Build, subdir: ?[]const u8) Self {
        return Self{
            .builder = builder,
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

    pub fn addFile(self: *Self, file: LazyPath) !void {
        const path = file.getPath(self.builder);

        const data = try std.fs.cwd().readFileAlloc(self.builder.allocator, path, 1 << 32); // 4 GB
        defer self.builder.allocator.free(data);

        self.addBytes(data);
    }

    fn createPath(self: *Self) ![]const u8 {
        var hash: [20]u8 = undefined;
        self.hasher.final(&hash);

        const path = if (self.subdir) |subdir|
            try std.fmt.allocPrint(
                self.builder.allocator,
                "{s}/{s}/o/{}",
                .{
                    self.builder.cache_root.path.?,
                    subdir,
                    std.fmt.fmtSliceHexLower(&hash),
                },
            )
        else
            try std.fmt.allocPrint(
                self.builder.allocator,
                "{s}/o/{}",
                .{
                    self.builder.cache_root.path.?,
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
