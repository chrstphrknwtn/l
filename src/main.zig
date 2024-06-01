const std = @import("std");
const fs = std.fs;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    const targetDir = if (args.len > 1) args[1] else "./";

    var dir = try fs.cwd().openDir(targetDir, .{ .iterate = true });
    var iterator = dir.iterate();

    while (try iterator.next()) |file| {
        try stdout.print("{s}\n", .{file.name});
    }

    dir.close();
}
