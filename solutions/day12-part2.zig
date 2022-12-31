//usr/bin/env -S zig run $0 $@; exit
const std = @import("std");

const Location = struct { x: u8 = 0, y: u8 = 0 };

const unknownDistance = std.math.maxInt(u32);

const LocationData = struct {
  height: u8,
  // distance to goal if known
  goalDistance: u32 = unknownDistance,
};

const ArrayList = std.ArrayList;
const Rows = ArrayList(ArrayList(LocationData));

pub fn deinitRows(rows: Rows) void {
  for (rows.items) |row| { row.deinit(); }
  rows.deinit();
}

pub fn readLocationData(endLocation: *Location) !Rows {
  const fs = std.fs;
  const dir: fs.Dir = fs.cwd();
  const file: fs.File = try dir.openFile(
    "input-12.txt",
    .{ .read = true },
  );
  defer file.close();

  const reader = file.reader();
  var buffer: [500]u8 = undefined;

  var y: u8 = 0;
  const allocator = std.heap.page_allocator;
  var rows = Rows.init(allocator);
  errdefer deinitRows(rows);

  while (try reader.readUntilDelimiterOrEof(buffer[0..], '\n')) |line| {
    var row = ArrayList(LocationData).init(allocator);
    for (line) |c, x| {
      var height = c;
      if (c == 'E') {
        height = 'z';
        endLocation.x = @truncate(u8, x);
        endLocation.y = @truncate(u8, y);
      } else if (c == 'S') {
        height = 'a';
      }
      try row.append(LocationData { .height = height });
    }
    try rows.append(row);
    y += 1;
  }
  return rows;
}

pub fn canClimb(currentHeight: u8, destHeight: u8) bool {
  return destHeight <= currentHeight + 1;
}

pub fn findGoalDistanceBeside(
  rows: Rows,
  x: u8,
  y: u8,
  minDistance: *u32,
  currentDistance: u32,
  prevLocation: LocationData,
) void {
  const nextLocation = &rows.items[y].items[x];
  if (
    // reverses from/to as working from the end back to the beginning
    canClimb(nextLocation.height, prevLocation.height)
    and currentDistance < nextLocation.goalDistance
  ) {
    nextLocation.goalDistance = currentDistance;
    if (nextLocation.height == 'a') {
      if (currentDistance < minDistance.*) {
        minDistance.* = currentDistance;
      }
    } else {
      findGoalDistance(rows, x, y, minDistance, currentDistance + 1);
    }
  }
}

pub fn findGoalDistance(
  rows: Rows,
  x: u8,
  y: u8,
  minDistance: *u32,
  currentDistance: u32,
) void {
  var here = rows.items[y].items[x];
  if (currentDistance < minDistance.*) {
    if (y > 0) {
      findGoalDistanceBeside(rows, x, y - 1, minDistance, currentDistance, here);
    }
    if (y < rows.items.len - 1) {
      findGoalDistanceBeside(rows, x, y + 1, minDistance, currentDistance, here);
    }
    if (x > 0) {
      findGoalDistanceBeside(rows, x - 1, y, minDistance, currentDistance, here);
    }
    if (x < rows.items[y].items.len - 1) {
      findGoalDistanceBeside(rows, x + 1, y, minDistance, currentDistance, here);
    }
  }
}

pub fn main() !void {
  var endLocation = Location {};
  var rows = try readLocationData(&endLocation);
  defer deinitRows(rows);

  rows.items[endLocation.y].items[endLocation.x].goalDistance = 0;
  var minDistance: u32 = unknownDistance;
  findGoalDistance(rows, endLocation.x, endLocation.y, &minDistance, 1);
  const stdout = std.io.getStdOut().writer();
  try stdout.print("{}\n", .{minDistance});
}
