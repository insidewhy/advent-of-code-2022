.PHONY: default

BUILD := g++ -Wall -std=c++20 -fmodules-ts -o
IMPORTS := -x c++-system-header iostream fstream set exception vector algorithm

default: day03-part1 day03-part2

day03-part1: solutions/day03-part1.cc
	${BUILD} $@ $^ ${IMPORTS} && ./$@

day03-part2: solutions/day03-part2.cc
	${BUILD} $@ $^ ${IMPORTS} && ./$@
