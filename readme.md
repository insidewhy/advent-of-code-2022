# Advent of code 2022

| solution | language | sources | fun had out of 5 |
| -  | - | - | - |
| 1  | ruby | [part1](./solutions/day1-part1.rb) [part2](./solutions/day1-part2.rb) | 4 |
| 2  | typescript | [part1](./solutions/day2-part1.ts) [part2](./solutions/day2-part2.ts) | 4 |
| 3  | c++ (c++20) | [part1](./solutions/day3-part1.cc) [part2](./solutions/day3-part2.cc) | 3 |
| 4  | dart | [part1](./solutions/day4-part1.dart) [part2](./solutions/day4-part2.dart) | 2 |
| 5  | scala | [part1](./solutions/day5-part1.scala) [part2](./solutions/day5-part2.scala) | 5 |
| 6  | haskell | [part1](./solutions/day6-part1.hs) [part2](./solutions/day6-part2.hs) | 4 |
| 7  | php | [part1](./solutions/day7-part1.php) [part2](./solutions/day7-part2.php) | 2 |
| 8  | rust | [part1](./solutions/day8-part1.rs) [part2](./solutions/day8-part2.rs) | 4 |
| 9  | crystal | [part1](./solutions/day9-part1.cr) [part2](./solutions/day9-part2.cr) | 5 |
| 10 | go | [part1](./solutions/day10-part1.go) [part2](./solutions/day10-part2.go) | 2 |

# General comments

## ruby

The first problem was very easy, in each case two lines of code.
There's a lot I like about Ruby but I don't like the implementation of the typesystem that was added in 2020.
In order to add types all classes/functions etc. must be repeated in a second file where types are allowed.
- The documentation for types is in another file which leads to much switching back and forth between multiple things.
- "Repeat yourself twice" instead of DRY is kind of sad for a language that is usually expressive.

## crystal

Crystal is a compiled version of Ruby where the types are colocated, it's not 100% compatible but close enough.
- I'd love to be able to use this language more but it doesn't seem to be getting much attention.
- I wish I could use const variables and mark data as immutable.
- The compiler is a little slow.

## TypeScript

I use TypeScript more than any other language in the last few years so it was easy to write this without having to reference any documentation.
The problem wasn't very hard but there were two small areas where you could use modular arithmetic in a fun way.
I checked some other solutions online and many people just used a lookup table where looked up each line from the file against a score and this works in both cases since there are only six combinations of hands.

## c++

C++ gets a lot of hate for being too complicated and for baggage it inherited from C.
On the other hand a lot of people dislike the more recent versions of C++ and only want to use classic C++.
I wonder if the best solution to keep things simple is to take the opposite approach to both these camps and disregard earlier features rather than modern features.
The solution here is quite neat and performs very well.

## dart

Dart is a very conservative language so solutions tend to be quite verbose.
The typesystem is a little conservative also so it can be harder to write typesafe programs without resorting to repetition that can be avoided in TypeScript.
I find it a little joyless to use dart.

## go

Not much to say about go that's different from dart, I don't like writing go so much as it feels very soulless.
Like a language that was written in which to achieve dayjobs, the fun you get is from solving business problems and not from the joy of writing code itself.
I'm not really sure if the verbosity of the code needed to achieve simple things really is a boon for maintanable software.
Surely there's a balance between having to write a lot of boilerplate and writing understandable code?
Error handling in go is a **PAIN**.
Rust doesn't have exceptions either but they added some nice syntax to the language for dealing with errors.

## haskell

Haskell is possibly the opposite of dart/go, the expressiveness of the language is off the charts.
I'm not sure if it's a pragmatic choice for most of the world, Haskell code can be impenetrable even to the people that wrote it.
There's a fine balance between simplicity, verbosity and how fun a language is to use and that depends a lot on your own experience and personality.
For me it's somewhere closer to haskell than go but still very far away from either.

## scala

I had so much fun with this one.
Maybe scala strikes the complexity/readability balance for me.

## php

I was kind of interested to see how far php had come and ended up disappointed.
The typechecking happens at runtime rather than via static analysis!?!?!?
Why would anyone want that?
As usual, the designers of php seem to want things from a programming language that are completely foreign to me.
The way constants are defined is still annoying.
The amount of `$` symbols in php code is still annoying.
They took a lot of nice things from JavaScript and TypeScript that make it more expressive than it used to be but I still strongly dislike it.

## rust

Rust is pretty fun, I've used it a little.
The borrow checker is cool but it might really annoy you until you understand it well.
The macro system is very fun and the shortcuts for error handling are very nice.
It forced me to use integers to index vectors instead of iterators which made some of the code less readable than it could be, but maybe it's worth it to have code that is guaranteed to be safe.

# Future

## familiar languages under consideration

- c#
- kotlin
- d
- python

## unknown languages that may be used

- raku (aka perl 6)
- carbon
- purescript
- nim
- zig
- groovy
- val
- elixir
- clojure
- f#

## familiar languages not interested in

- javascript: already did typescript and it's basically a subset
- c: as above but for c++
- basic: haven't used it for over 20 years and don't want to
- java: when it comes to the jvm I prefer scala/kotlin
- perl 5: one of the first languages i learned but not really into it anymore
