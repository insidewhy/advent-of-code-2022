#!/usr/bin/env csharp

using System.IO;
using System.Text.RegularExpressions;

var lineMatch = new Regex(
  @"^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$",
  RegexOptions.Compiled
);

// mono top-level statement bug: setting this as const makes csharp think the value is 0 >:-(
int ROW_OF_INTEREST = 2_000_000;
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

  // sum the differences of all ranges
  public int SumDifferences() =>
    ranges.Aggregate(0, (acc, range) => acc + (range.end - range.begin) + 1);

  public bool PointIntersects(int value) =>
    ranges.Any((range) => value >= range.begin && value <= range.end);
}

var covered = new RangeList();
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
  int rowDistance = Math.Abs(sensorY - ROW_OF_INTEREST);
  if (rowDistance <= beaconDistance) {
    int sideDistance = beaconDistance - rowDistance;
    covered.AddRange(sensorX - sideDistance, sensorX + sideDistance);
  }
  if (beaconY == ROW_OF_INTEREST) {
    beaconsOnRow.Add(beaconX);
  }
}

int coveredBeaconCount = beaconsOnRow.Aggregate(
  0,
  (acc, x) => acc + (covered.PointIntersects(x) ? 1 : 0)
);
Console.WriteLine(covered.SumDifferences() - coveredBeaconCount);
