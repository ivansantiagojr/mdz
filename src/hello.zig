const py = @import("pydust");

const root = @This();

pub fn hello() !py.PyString(root) {
    return try py.PyString(root).create("Hello!");
}

comptime {
    py.rootmodule(root);
}
