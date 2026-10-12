const std = @import("std");

const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;
    const dir = Io.Dir.cwd();

    const file = try Io.Dir.openFile(
        dir,
        io,
        "/etc/hostname",
        .{ .mode = .read_only },
    );

    const file_stats = try file.stat(io);
    const file_size: u64 = file_stats.size;

    std.debug.print("File size: {d}\n", .{file_size});

    // var read_buffer: [file_size]u8 = undefined;

    // Probably a better buffer option for this (&buffer on readFile)
    // var buffer: [256]u8 = undefined; // Hostnames are technically only up to 255 bytes

    // Only reserve in memory the acutal size of the hostname file nothing more
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    _ = try Io.Dir.readFile(dir, io, "/etc/hostname", buffer);

    std.debug.print("File: {s}", .{buffer});
}
