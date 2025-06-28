const py = @import("pydust");
const std = @import("std");

const Zmd = @import("zmd").Zmd;
const fragments = @import("zmd").html.DefaultFragments;

const root = @This();

pub fn hello() !py.PyString(root) {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var zmd = Zmd.init(allocator);
    defer zmd.deinit();

    try zmd.parse(
        \\# Header
        \\## Sub-header
        \\### Sub-sub-header
        \\
        \\some text in **bold** and _italic_
        \\
        \\a paragraph
        \\
        \\```zig
        \\some code
        \\```
        \\some more text with a `code` fragment
    );

    const html = try zmd.toHtml(fragments);

    return py.PyString(root).create(html);
}

comptime {
    py.rootmodule(root);
}
