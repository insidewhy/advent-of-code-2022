#!/usr/bin/env python
from re import split
from itertools import count

occupied: set[(int, int)] = set()


def parse_coordinates(pair: str) -> (int, int):
    x_str, y_str = split(",", pair)
    return int(x_str), int(y_str)


def range_inclusive(frm: int, to: int):
    if frm < to:
        return range(frm, to + 1)
    else:
        return range(to, frm + 1)


def add_line(frm: (int, int), to: (int, int)) -> None:
    if frm[0] != to[0]:
        for x in range_inclusive(frm[0], to[0]):
            occupied.add((x, frm[1]))
    elif frm[1] != to[1]:
        for x in range_inclusive(frm[1], to[1]):
            occupied.add((frm[0], x))
    else:
        occupied.add(frm)


with open('input-14.txt', 'r') as f:
    for line in f.readlines():
        first_pair, *rest = split(" -> ", line.strip())
        prev = parse_coordinates(first_pair)
        for next_pair in rest:
            current = parse_coordinates(next_pair)
            add_line(prev, current)
            prev = current

max_y = 0
for cell in occupied:
    max_y = max(cell[1], max_y)

spawn_point = 500, 0
while (below := (spawn_point[0], spawn_point[1] + 1)) not in occupied:
    spawn_point = below

for sand_count in count(start=1):
    next_cell = spawn_point
    while True:
        candidate = next_cell[0], next_cell[1] + 1
        if candidate in occupied:
            candidate = candidate[0] - 1, candidate[1]
            if candidate in occupied:
                candidate = candidate[0] + 2, candidate[1]
                if candidate in occupied:
                    occupied.add(next_cell)
                    if next_cell == spawn_point:
                        spawn_point = spawn_point[0], spawn_point[1] - 1
                    break
        next_cell = candidate
        if next_cell[1] == max_y:
            print(sand_count - 1)
            exit(0)
