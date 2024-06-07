const std = @import("std");
const fs = std.fs;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();

const DirEntry = struct { name: []const u8 };

pub fn main() !u8 {
    const allocator = std.heap.page_allocator;

    //
    // Arguments
    //
    const args = std.process.argsAlloc(allocator) catch |err| {
        stderr.print("Memory error: {}\n", .{err}) catch {};
        return 1;
    };
    defer std.process.argsFree(allocator, args);
    const targetPath: []const u8 = if (args.len > 1) args[1] else "./";

    // TODO: print immediately and exist if targetPath is a file
    //
    // Collect Dir Entries
    //
    const entries = collectEntries(allocator, targetPath) catch |err| {
        switch (err) {
            error.AccessDenied => stderr.print("l: {s}: Operation not permitted\n", .{targetPath}) catch {},
            error.FileNotFound => stderr.print("l: {s}: No such file or directory\n", .{targetPath}) catch {},
            error.NotDir => stderr.print("l: {s}: Not a directory\n", .{targetPath}) catch {},
            else => {
                stderr.print("l: {}: {s}\n", .{ err, targetPath }) catch {};
            },
        }
        return 1;
    };

    //
    // Sort
    //

    //
    // Print
    //
    for (entries) |entry| {
        try printEntry(entry);
    }
    return 0;
}

fn collectEntries(allocator: std.mem.Allocator, targetPath: []const u8) ![]DirEntry {
    var dir = try std.fs.cwd().openDir(targetPath, .{ .iterate = true });
    defer dir.close();

    var iterator = dir.iterate();
    var entry_list = std.ArrayList(DirEntry).init(allocator);

    while (try iterator.next()) |file| {
        const name = try allocator.dupe(u8, file.name);
        try entry_list.append(DirEntry{ .name = name });
    }

    return entry_list.toOwnedSlice();
}

fn printEntry(entry: DirEntry) !void {
    try stdout.print("{s}\n", .{entry.name});
}
