const std = @import("std");

const Sdk = @import("Sdk.zig");

const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const sdk = Sdk.init(b);

    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const sdl_linkage = b.option(std.build.LibExeObjStep.Linkage, "link", "Defines how to link SDL2 when building with mingw32") orelse .dynamic;

    const skip_tests = b.option(bool, "skip-test", "When set, skips the test suite to be run. This is required for cross-builds") orelse false;

    if (!skip_tests) {
        const lib_test = b.addTest("src/wrapper/sdl.zig");
        lib_test.setTarget(.{
            // copy over the abi so we compile the test with -msvc or -gnu for windows
            .abi = if (target.isWindows())
                target.abi
            else
                null,
        });
        lib_test.addPackage(sdk.getNativePackage("sdl-native"));
        lib_test.linkSystemLibrary("sdl2_image");
        sdk.link(lib_test, .dynamic);

        const test_lib_step = b.step("test", "Runs the library tests.");
        test_lib_step.dependOn(&lib_test.step);
    }

    const demo_wrapper = b.addExecutable("demo-wrapper", "examples/wrapper.zig");
    demo_wrapper.setBuildMode(mode);
    demo_wrapper.setTarget(target);
    sdk.link(demo_wrapper, sdl_linkage);
    demo_wrapper.addPackage(sdk.getWrapperPackage("sdl2"));
    demo_wrapper.install();

    const demo_native = b.addExecutable("demo-native", "examples/native.zig");
    demo_native.setBuildMode(mode);
    demo_native.setTarget(target);
    sdk.link(demo_native, sdl_linkage);
    demo_native.addPackage(sdk.getNativePackage("sdl2"));
    demo_native.install();

    const run_demo_wrappr = demo_wrapper.run();
    run_demo_wrappr.step.dependOn(b.getInstallStep());

    const run_demo_native = demo_wrapper.run();
    run_demo_native.step.dependOn(b.getInstallStep());

    const run_demo_wrapper_step = b.step("run-wrapper", "Runs the demo for the SDL2 wrapper library");
    run_demo_wrapper_step.dependOn(&run_demo_wrappr.step);

    const run_demo_native_step = b.step("run-native", "Runs the demo for the SDL2 native library");
    run_demo_native_step.dependOn(&run_demo_native.step);
}
