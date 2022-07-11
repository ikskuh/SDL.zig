//! SDL2 Zig SDK
//! ============
//! This file provides a build api that allows you to link and use
//! SDL2 from build.zig.
//!
//!
const std = @import("std");
const host_system = @import("builtin").target;

const Builder = std.build.Builder;
const Step = std.build.Step;
const FileSource = std.build.FileSource;
const GeneratedFile = std.build.GeneratedFile;
const LibExeObjStep = std.build.LibExeObjStep;

const Sdk = @This();

fn sdkRoot() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

const sdl2_symbol_definitions = @embedFile("stubs/libSDL2.def");

builder: *Builder,
config_path: []const u8,

prepare_sources: *PrepareStubSourceStep,

/// Creates a instance of the Sdk and initializes internal steps.
/// Initialize once, use everywhere (in your `build` function).
pub fn init(b: *Builder) *Sdk {
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");
    sdk.* = .{
        .builder = b,
        .config_path = std.fs.path.join(b.allocator, &[_][]const u8{
            b.pathFromRoot(".build_config"),
            "sdl.json",
        }) catch @panic("out of memory"),
        .prepare_sources = undefined,
    };
    sdk.prepare_sources = PrepareStubSourceStep.create(sdk);

    return sdk;
}

/// Returns a package with the raw SDL api with proper argument types, but no functional/logical changes
/// for a more *ziggy* feeling.
/// This is similar to the *C import* result.
pub fn getNativePackage(sdk: *Sdk, package_name: []const u8) std.build.Pkg {
    const build_options = sdk.builder.addOptions();
    build_options.addOption(bool, "vulkan", false);
    return std.build.Pkg{
        .name = sdk.builder.dupe(package_name),
        .source = .{ .path = sdkRoot() ++ "/src/binding/sdl.zig" },
        .dependencies = &[_]std.build.Pkg{
            build_options.getPackage("build_options"),
        },
    };
}

/// Returns a package with the raw SDL api with proper argument types, but no functional/logical changes
/// for a more *ziggy* feeling, with Vulkan support! The Vulkan package provided by `vulkan-zig` must be
/// provided as an argument.
/// This is similar to the *C import* result.
pub fn getNativePackageVulkan(sdk: *Sdk, package_name: []const u8, vulkan: std.build.Pkg) std.build.Pkg {
    const build_options = sdk.builder.addOptions();
    build_options.addOption(bool, "vulkan", true);
    return std.build.Pkg{
        .name = sdk.builder.dupe(package_name),
        .source = .{ .path = sdkRoot() ++ "/src/binding/sdl.zig" },
        .dependencies = &[_]std.build.Pkg{
            build_options.getPackage("build_options"),
            vulkan,
        },
    };
}

/// Returns the smart wrapper for the SDL api. Contains convenient zig types, tagged unions and so on.
pub fn getWrapperPackage(sdk: *Sdk, package_name: []const u8) std.build.Pkg {
    return sdk.builder.dupePkg(std.build.Pkg{
        .name = sdk.builder.dupe(package_name),
        .source = .{ .path = sdkRoot() ++ "/src/wrapper/sdl.zig" },
        .dependencies = &[_]std.build.Pkg{
            sdk.getNativePackage("sdl-native"),
        },
    });
}

/// Returns the smart wrapper with Vulkan support. The Vulkan package provided by `vulkan-zig` must be
/// provided as an argument.
pub fn getWrapperPackageVulkan(sdk: *Sdk, package_name: []const u8, vulkan: std.build.Pkg) std.build.Pkg {
    return sdk.builder.dupePkg(std.build.Pkg{
        .name = sdk.builder.dupe(package_name),
        .source = .{ .path = sdkRoot() ++ "/src/wrapper/sdl.zig" },
        .dependencies = &[_]std.build.Pkg{
            sdk.getNativePackageVulkan("sdl-native", vulkan),
        },
    });
}

/// Links SDL2 to the given exe and adds required installs if necessary.
/// **Important:** The target of the `exe` must already be set, otherwise the Sdk will do the wrong thing!
pub fn link(sdk: *Sdk, exe: *LibExeObjStep, linkage: std.build.LibExeObjStep.Linkage) void {
    // TODO: Implement

    const b = sdk.builder;
    const target = (std.zig.system.NativeTargetInfo.detect(b.allocator, exe.target) catch @panic("failed to detect native target info!")).target;
    const is_native = exe.target.isNative();

    // This is required on all platforms
    exe.linkLibC();

    if (target.os.tag == .linux and !is_native) {
        // for cross-compilation to Linux, we use a magic trick:
        // we compile a stub .so file we will link against an SDL2.so even if that file
        // doesn't exist on our system

        const build_linux_sdl_stub = b.addSharedLibrary("SDL2", null, .unversioned);
        build_linux_sdl_stub.addAssemblyFileSource(sdk.prepare_sources.getStubFile());
        build_linux_sdl_stub.setTarget(exe.target);

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
    const json_data = std.fs.cwd().readFileAlloc(sdk.builder.allocator, sdk.config_path, 1 << 20) catch |err| switch (err) {
        error.FileNotFound => return error.FileNotFound,
        else => |e| @panic(@errorName(e)),
    };

    var parser = std.json.Parser.init(sdk.builder.allocator, false);

    var tree = parser.parse(json_data) catch return error.InvalidJson;

    var root_node = tree.root.Object;

    var config_iterator = root_node.iterator();
    while (config_iterator.next()) |entry| {
        const config_cross_target = std.zig.CrossTarget.parse(.{
            .arch_os_abi = entry.key_ptr.*,
        }) catch return error.InvalidTarget;
        const config_target = (std.zig.system.NativeTargetInfo.detect(sdk.builder.allocator, config_cross_target) catch @panic("out of memory")).target;

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
        const psss = sdk.builder.allocator.create(Self) catch @panic("out of memory");

        psss.* = .{
            .step = std.build.Step.init(
                .custom,
                "Prepare SDL2 stub sources",
                sdk.builder.allocator,
                make,
            ),
            .sdk = sdk,
            .assembly_source = .{ .step = &psss.step },
        };

        return psss;
    }

    pub fn getStubFile(self: *Self) FileSource {
        return .{ .generated = &self.assembly_source };
    }

    fn make(step: *Step) !void {
        const self = @fieldParentPtr(Self, "step", step);

        var cache = CacheBuilder.init(self.sdk.builder, "sdl");

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

        self.assembly_source.path = try std.fs.path.join(self.sdk.builder.allocator, &[_][]const u8{
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

    builder: *std.build.Builder,
    hasher: std.crypto.hash.Sha1,
    subdir: ?[]const u8,

    pub fn init(builder: *std.build.Builder, subdir: ?[]const u8) Self {
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

    pub fn addFile(self: *Self, file: std.build.FileSource) !void {
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
                    self.builder.cache_root,
                    subdir,
                    std.fmt.fmtSliceHexLower(&hash),
                },
            )
        else
            try std.fmt.allocPrint(
                self.builder.allocator,
                "{s}/o/{}",
                .{
                    self.builder.cache_root,
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
