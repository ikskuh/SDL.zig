const std = @import("std");

const Sdk = @import("Sdk.zig");

const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const sdk = Sdk.init(b);

    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const lib_test = b.addTest("src/lib.zig");
    lib_test.setTarget(.{
        // copy over the abi so we compile the test with -msvc or -gnu for windows
        .abi = if (target.isWindows())
            target.abi
        else
            null,
    });
    sdk.link(lib_test, .dynamic);

    const demo_basic = b.addExecutable("demo-basic", "examples/basic.zig");
    demo_basic.setBuildMode(mode);
    demo_basic.setTarget(target);
    sdk.link(demo_basic, .dynamic);
    demo_basic.addPackage(sdk.getWrapperPackage("sdl2"));
    demo_basic.install();

    const run_demo_basic = demo_basic.run();
    run_demo_basic.step.dependOn(b.getInstallStep());

    const test_lib_step = b.step("test", "Runs the library tests.");
    test_lib_step.dependOn(&lib_test.step);

    const run_demo_basic_step = b.step("demo-basic", "Runs the demo 'basic'");
    run_demo_basic_step.dependOn(&run_demo_basic.step);
}
