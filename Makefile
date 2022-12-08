day3-part1: solutions/solution-day3-part1.cc
	g++ -Wall -std=c++20 -fmodules-ts -o $@ $^ \
		-x c++-system-header iostream fstream set exception vector algorithm
