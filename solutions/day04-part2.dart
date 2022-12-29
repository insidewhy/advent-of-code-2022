#!/usr/bin/env dart

import 'dart:core';
import 'dart:io';

void main() async {
  final lines = (await File('input-4.txt').readAsString()).trim().split('\n');
  print(lines.fold<int>(0, (acc, line) {
    final sides = line.split(',');
    if (sides.length != 2) {
      throw Exception('line should contain one comma: ${sides}');
    }
    final range1 = sides[0].split('-').map(int.parse).toList();
    if (range1.length != 2) {
      throw Exception('component should contain one hyphen: ${range1}');
    }
    final range2 = sides[1].split('-').map(int.parse).toList();
    if (range2.length != 2) {
      throw Exception('component should contain one hyphen: ${range2}');
    }

    if (range2[1] >= range1[1]
        ? range1[1] >= range2[0]
        : range2[1] >= range1[0]) {
      return acc + 1;
    } else {
      return acc;
    }
  }));
}
