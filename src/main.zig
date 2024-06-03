const std = @import("std");
const fs = std.fs;

pub fn main() !u8 {
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();

    const args = std.process.argsAlloc(std.heap.page_allocator) catch |err| {
        stderr.print("Memory error: {}\n", .{err}) catch {};
        return 1;
    };
    defer std.process.argsFree(std.heap.page_allocator, args);

    const targetDirArg = if (args.len > 1) args[1] else "./";

    var dir = std.fs.cwd().openDir(targetDirArg, .{ .iterate = true }) catch |err| {
        switch (err) {
            error.AccessDenied => stderr.print("l: {s}: Operation not permitted\n", .{targetDirArg}) catch {},
            error.FileNotFound => stderr.print("l: {s}: No such file or directory\n", .{targetDirArg}) catch {},
            error.NotDir => stderr.print("l: {s}: Not a directory\n", .{targetDirArg}) catch {},
            else => {
                stderr.print("l: {}: {s}\n", .{ err, targetDirArg }) catch {};
            },
        }
        return 1;
    };
    defer dir.close();

    var iterator = dir.iterate();
    while (try iterator.next()) |file| {
        try stdout.print("{s}\n", .{file.name});
    }
    return 0;
}
