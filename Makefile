.PHONY: default

BUILD := g++ -Wall -std=c++20 -fmodules-ts -o
IMPORTS := -x c++-system-header iostream fstream set exception vector algorithm

default: day3-part1 day3-part2

day3-part1: solutions/solution-day3-part1.cc
	${BUILD} $@ $^ ${IMPORTS} && ./$@

day3-part2: solutions/solution-day3-part2.cc
	${BUILD} $@ $^ ${IMPORTS} && ./$@
