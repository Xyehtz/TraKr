const std = @import("std");

const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const dir = Io.Dir.cwd();

    try getHostInfo(io, dir);
}

fn getHostInfo(io: Io, dir: std.Io.Dir) !void {

    // Hostnames are technically only up to 64 bytes (according to https://softpanorama.org/DNS/maximum_hostname_length.shtml)
    var buffer: [64]u8 = undefined;

    const content = try Io.Dir.readFile(dir, io, "/etc/hostname", &buffer);
    std.debug.print("Hostname: {s}", .{content});

    // NOTE: To self
    // If I wanted to return the hostname back to main or whatever is calling this method
    // I would have get an Allocator, then use said allocator to allocate data where the
    // Hostname would be saved
    // Simply returning the content would result on a dangling pointer and would print �
}
