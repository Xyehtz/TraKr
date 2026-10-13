const std = @import("std");

const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const dir = Io.Dir.cwd();

    // Hostnames are technically only up to 255 bytes (according to https://softpanorama.org/DNS/maximum_hostname_length.shtml)
    var buffer: [64]u8 = undefined;

    const content = try Io.Dir.readFile(dir, io, "/etc/hostname", &buffer);

    std.debug.print("Hostname: {s}", .{content});
}
