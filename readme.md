# Advent of code 2022

[solutions](./solutions)

| solution | language | sources | fun had out of 5 |
| - | - | - | - |
| 1 | ruby | [part1](./solutions/day1-part1.rb) [part2](./solutions/day1-part2.rb) | 4 |
| 2 | typescript | [part1](./solutions/day2-part1.ts) [part2](./solutions/day2-part2.ts) | 4 |
| 3 | c++ (c++20) | [part1](./solutions/day3-part1.cc) [part2](./solutions/day3-part2.cc) | 3 |
| 4 | dart | [part1](./solutions/day4-part1.dart) [part2](./solutions/day4-part2.dart) | 2 |
| 5 | scala | [part1](./solutions/day5-part1.scala) [part2](./solutions/day5-part2.scala) | 5 |
| 6 | haskell | [part1](./solutions/day6-part1.hs) [part2](./solutions/day6-part2.hs) | 4 |
| 7 | php | [part1](./solutions/day7-part1.php) [part2](./solutions/day7-part2.php) | 2 |
| 8 | rust | [part1](./solutions/day8-part1.rs) [part2](./solutions/day8-part2.rs) | 4 |
| 9 | crystal | [part1](./solutions/day9-part1.cr) [part2](./solutions/day9-part2.cr) | 5 |

# General comments

## ruby

The first problem was very easy, in each case two lines of code.
There's a lot I like about Ruby but when they added the type system I became really disappointed.
In order to type code I have to repeat all of my interfaces in a second file and in this one I can
add types.
- I don't want to repeat myself.
- I don't want to keep switching back and forth between two files to remind myself what the type of a variable is.

## crystal

Crystal is a compiled version of Ruby where the types are colocated, it's not 100% compatible but close enough.
I used this for solution 9 and it was fun.
I'd love to be able to use this language more but it doesn't seem to be getting much attention.
I wish I could use const variables and mark data as immutable.

## TypeScript

I use TypeScript more than any other language in the last few years so it wasn't that fun to write this but it suited the problem fairly well.
The problem wasn't very hard but there were two small areas where you could use modular arithmetic in a fun way.
I checked some other solutions online and many people just used a lookup table where they passed the line from the file and this works in both cases since there are only six combinations of hands.

## c++

C++ gets a lot of hate and I understand why but I find it quite pleasant to use if you ignore the historical baggage.
A lot of people dislike the more recent versions of C++ and want to ignore it all.
This is weird to me given that the enhancements make the language safer, terser and easier to use
e.g. the error messages you get when you use concepts are far more understandable than old-school templates.
In this case there wasn't much need to use any modern C++.
The solution is quite neat and performs very well.

# Future

## familiar languages not yet used

- c#
- kotlin
- d
- python
- go: getting more desperate now
- java: and more
- perl 5: and more

## unknown languages that might be used

- raku (aka perl 6)
- carbon
- purescript
- nim
- zig
- groovy

## familiar languages not interested in

- javascript: already did typescript and it's basically a subset
- c: as above but for c++
- basic: haven't used it for over 20 years and don't want to
