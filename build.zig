const std = @import("std");
const py = @import("./pydust.build.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptionsQueryOnly(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run library tests");

    const pydust = py.addPydust(b, .{
        .test_step = test_step,
    });

    const zmd = b.dependency("zmd", .{
        .target = target,
        .optimize = optimize,
    });

    var modules: [1]std.Build.Module.Import = undefined;
    modules[0] = std.Build.Module.Import{ .name = "zmd", .module = zmd.module("zmd") };

    _ = pydust.addPythonModule(.{
        .name = "mdz",
        .root_source_file = b.path("src/hello.zig"),
        .limited_api = true,
        .target = target,
        .optimize = optimize,
        .imports = &modules,
    });
}
