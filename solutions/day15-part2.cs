#!/usr/bin/env csharp

using System.IO;
using System.Text.RegularExpressions;

var lineMatch = new Regex(
  @"^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$",
  RegexOptions.Compiled
);

// mono top-level statement bug: setting these as const makes csharp think the values are 0 >:-(
int MIN_COORDINATE = 0;
int END_COORDINATE = 4_000_000;
var beaconsOnRow = new HashSet<int>();

// A list of ranges that will merge intersecting ranges
class RangeList {
  // no record struct in mono :(
  LinkedList<(int begin, int end)> ranges = new LinkedList<(int begin, int end)>();

  // add a range, potentially merging with any other ranges to avoid intersections
  public void AddRange(int begin, int end) {
    var overlap = ranges.First;
    for (; overlap != null; overlap = overlap.Next) {
      if (end < overlap.Value.begin) {
        ranges.AddBefore(overlap, (begin, end));
        return;
      } else if (begin <= overlap.Value.end) {
        // intersection: begin <= overlap.end && end >= overlap.begin
        overlap.Value = (
          Math.Min(overlap.Value.begin, begin),
          Math.Max(overlap.Value.end, end)
        );
        break;
      }
    }
    if (overlap == null) {
      ranges.AddLast((begin, end));
    } else {
      // merge extended range with subsequent ranges as necessary
      while (overlap.Next != null && overlap.Value.end >= overlap.Next.Value.begin) {
        if (overlap.Next.Value.end > overlap.Value.end) {
          overlap.Value = (overlap.Value.begin, overlap.Next.Value.end);
        }
        ranges.Remove(overlap.Next);
      }
    }
  }

  // Return -1 if there is no break, otherwise return the column of the break point
  public int HasBreak() {
    if (ranges.Count == 0) {
      return 0;
    } else if (ranges.Count == 1) {
      return -1;
    } else {
      return ranges.First.Value.end + 1;
    }
  }
}

var rows = new RangeList[END_COORDINATE];
for (int y = 0; y < END_COORDINATE; ++y) {
  rows[y] = new RangeList();
}

var lines = File.ReadLines("input-15.txt");
foreach (var line in lines) {
  Match match = lineMatch.Match(line);
  if (! match.Success) {
    throw new Exception($"Bad line found: {line}");
  }
  var groups = match.Groups;
  if (groups.Count != 5) {
    throw new Exception($"Bad line found: {line}");
  }
  int sensorX = int.Parse(groups[1].Value);
  int sensorY = int.Parse(groups[2].Value);
  int beaconX = int.Parse(groups[3].Value);
  int beaconY = int.Parse(groups[4].Value);

  int beaconDistance = Math.Abs(sensorX - beaconX) + Math.Abs(sensorY - beaconY);
  int endRow = Math.Min(sensorY + beaconDistance, END_COORDINATE);
  for (int y = Math.Max(MIN_COORDINATE, sensorY - beaconDistance); y < endRow; ++y) {
    int sideDistance = beaconDistance - Math.Abs(y - sensorY);
    int first = Math.Max(MIN_COORDINATE, sensorX - sideDistance);
    int last = Math.Min(END_COORDINATE - 1, sensorX + sideDistance);
    if (last >= first) {
      rows[y].AddRange(first, last);
    }
  }

  if (
    beaconX >= MIN_COORDINATE && beaconX < END_COORDINATE &&
    beaconY >= MIN_COORDINATE && beaconY < END_COORDINATE
  ) {
    rows[beaconY].AddRange(beaconX, beaconY);
  }
}

int solutionCount = 0;
for (int y = 0; y < END_COORDINATE; ++y) {
  var x = rows[y].HasBreak();
  if (x != -1) {
    ++solutionCount;
    Console.WriteLine(((long) x * END_COORDINATE) + y);
  }
}
if (solutionCount != 1) {
  throw new Exception($"Expected one solution but got {solutionCount}");
}
