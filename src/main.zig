const std = @import("std");

const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const dir = Io.Dir.cwd();
    const allocator = init.gpa;

    const log = std.log.scoped(.agent);

    try getHostInfo(io, dir, log);
    try getOSInfo(io, dir, allocator, log);
}

fn getHostInfo(io: Io, dir: Io.Dir, log: type) !void {

    // Hostnames are technically only up to 64 bytes (according to https://softpanorama.org/DNS/maximum_hostname_length.shtml)
    var buffer: [64]u8 = undefined;

    const content = try Io.Dir.readFile(dir, io, "/etc/hostname", &buffer);

    log.debug("Hostname obtained from \"/etc/hostname\" is {s}", .{content});

    // NOTE: To self
    // If I wanted to return the hostname back to main or whatever is calling this method
    // I would have get an Allocator, then use said allocator to allocate data where the
    // Hostname would be saved
    // Simply returning the content would result on a dangling pointer and would print �
}

fn getOSInfo(io: Io, dir: Io.Dir, allocator: std.mem.Allocator, log: type) !void {
    // The file size of /etc/os-release may differ from OS to OS
    // Even in the case of NixOS it may change because of Version, Codename, Build ID, etc...
    const file = try dir.openFile(io, "/etc/os-release", .{ .mode = .read_only });
    const file_stats = try file.stat(io);
    const file_size = file_stats.size;

    const buffer = try allocator.alloc(u8, file_size);

    // This is returning everything on the file, but I don't need all that,
    // so probably using File.reader to get what I need would be the best option
    const content = try dir.readFile(io, "/etc/os-release", buffer);

    log.debug("{s}", .{content});

    defer allocator.free(buffer);
}
