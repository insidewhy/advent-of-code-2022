# Advent of code 2022

| solution | language | sources | fun had out of 5 |
| -  | - | - | - |
| 1  | ruby | [part1](./solutions/day01-part1.rb) [part2](./solutions/day01-part2.rb) | 4 |
| 2  | typescript | [part1](./solutions/day02-part1.ts) [part2](./solutions/day02-part2.ts) | 4 |
| 3  | c++ (c++20) | [part1](./solutions/day03-part1.cc) [part2](./solutions/day03-part2.cc) | 3 |
| 4  | dart | [part1](./solutions/day04-part1.dart) [part2](./solutions/day04-part2.dart) | 2 |
| 5  | scala | [part1](./solutions/day05-part1.scala) [part2](./solutions/day05-part2.scala) | 5 |
| 6  | haskell | [part1](./solutions/day06-part1.hs) [part2](./solutions/day06-part2.hs) | 4 |
| 7  | php | [part1](./solutions/day07-part1.php) [part2](./solutions/day07-part2.php) | 2 |
| 8  | rust | [part1](./solutions/day08-part1.rs) [part2](./solutions/day08-part2.rs) | 4 |
| 9  | crystal | [part1](./solutions/day09-part1.cr) [part2](./solutions/day09-part2.cr) | 5 |
| 10 | go | [part1](./solutions/day10-part1.go) [part2](./solutions/day10-part2.go) | 2 |
| 11 | raku | [part1](./solutions/day11-part1.raku) [part2](./solutions/day11-part2.raku) | 4 |
| 12 | zig | [part1](./solutions/day12-part1.zig) [part2](./solutions/day12-part2.zig) | 3 |
| 13 | f# | [part1](./solutions/day13-part1.fs) [part2](./solutions/day13-part2.fs) | 4 |
| 14 | python | [part1](./solutions/day14-part1.py) [part2](./solutions/day14-part2.py) | 3 |
| 15 | c# | [part1](./solutions/day15-part1.cs) [part2](./solutions/day15-part2.cs) | 3 |

# General comments

## ruby

The first problem was very easy: three lines of code for both days.
There's a lot I like about Ruby but I don't like the implementation of the typesystem that was added in 2020.
In order to add types all classes/functions etc. must be repeated in a second file where types are allowed.
- I don't like having to switch back and forth between my code and the type definition file to lookup types, types are such a useful part of the documentation and the code itself that I feel like they should be colocated.
- "Repeat yourself twice" instead of DRY is kind of sad for a language that is usually expressive.

## crystal

Crystal is a compiled version of Ruby where the types are colocated, it's not 100% compatible but close enough.
- I'd love to be able to use this language more but it doesn't seem to be getting much attention.
- I wish I could use const variables and mark data as immutable.
- The compiler is a little slow.

## TypeScript

I use TypeScript more than any other language in the last few years so it was easy to write this without having to reference any documentation.
The problem wasn't very hard but there were two small areas where you could use modular arithmetic in a fun way.
I checked some other solutions online and many people just used a lookup table with one entry containing the score for each of the six possible hands.

## c++

C++ gets a lot of hate for being too complicated and for baggage it inherited from C.
On the other hand a lot of people dislike the more recent versions of C++ and only want to use classic C++, the version where it's hard to avoid that baggage.
I wonder if the most pragmatic solution to keep things simple is to take the opposite approach to both these camps and disregard earlier features rather than modern features.
The solution here is quite neat and performs very well.

## dart

Dart is a very conservative language so solutions tend to be quite verbose.
This conservatism extends to the typesystem so it can be harder to write typesafe programs without resorting to repetition that can be avoided in other languages.
TypeScript is a lot more expressive in this respect.
I find it a little joyless to use dart, both for this solution and in my day job where I occasionally write flutter apps.

## go

Not much to say about go that's different from dart, I don't like writing go so much as it feels very soulless and a little patronising.
It feels like a language that was written in which to achieve day jobs, the fun you get is from solving business problems and not from the joy of writing code itself.
I'm not really sure if the verbosity of the code needed to achieve simple things really is a boon for maintainable software.
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
Maybe scala strikes the expressiveness/readability balance for me.
There were a lot of instances where I was really impressed at how readable and tersely I could express things.

## php

I was kind of interested to see how far php had come and ended up disappointed.
The typechecking happens at runtime rather than via static analysis!?!?!?
As usual, the designers of php seem to want things from a programming language that are completely foreign to me.
The way constants are defined is still annoying.
The amount of `$` symbols in php code is still annoying.
They took a lot of nice things from JavaScript and TypeScript that make it more expressive than it used to be but I still strongly dislike it.

## rust

Rust is pretty fun, I've used it a little in the past also.
The borrow checker is cool but it might really annoy you until you understand it well.
The macro system is very fun and the shortcuts for error handling are very nice.
It forced me to use integers to index vectors instead of iterators which made some of the code less readable than it could be, but maybe it's worth it to have code that is guaranteed to be safe.

## raku

raku is the successor to perl 5, the third language I learned quite some time ago (after Metacomco basic on the Atari ST and bash).
I haven't used perl in about 15 years and I think it was helpful having some distance because, while raku is reminiscent of perl 5, it's unmistakeably a very different language.
I thought it would be fun to use it for solution 11 as it requires a lot of parsing and raku has the ability to define grammars built into the language (it operates much like a very advanced version of regexes).
There were things I loved about raku and things that confounded me.
The typesystem is a little limiting (no variants, no parametric types).
The difference between constructors and the `BUILD` method was also a little frustrating, you can only assign to private attributes in the latter but this involves duplicating the names of attributes you want to assign directly from arguments.
The amount of sigils in the code also makes it a little difficult to type; they call them twigils in the documentation.
A lot of stuff in raku works (or is named, or is expressed) very differently than you might be used to.
It was fun to learn and use but definitely the language where I hit the most unexpected results and that required the most learning and research.
It's doubtful I'll get to use it again in the future due to its niche popularity.
One thing I really liked about part 2 of this solution is that it relies on your knowledge of modular arithmetic in order to produce a solution that runs in a reasonable length of time.
Without applying this then you'll really start hitting the performance limits of big integers and the code will take several days to provide a solution.

# zig

Zig seems like a pretty nice language, it's like C with metaprogramming and a few extra nice things such as the `defer` keyword (which I first encountered in d) and a neat way of handling errors.
You metaprogram zig in zig itself.
Unfortunately I didn't get to do any metaprogramming with a problem this simple.
This solution was easy once I worked out that I had to start from the destination instead of the source.

# f#

f# was fun to use, it's a lot like haskell but maybe a little more pragmatic.
The pipeline operator is great and makes for much readable code than chaining things together with `$` in haskell.
Most of the code for these solutions is involved with parsing the recursive data structure (which amused me as in python I could just `eval` each line to build the list since the syntax used in the file matches python's list notation).
I wish that the compiler would repeat the line of the error with some kind of indicator pointing at the location, instead it just prints the row and column, since I didn't hook the compiler up to my editor it was harder than it could be to find what was wrong.

# python

I've used python a great deal over the last 15 or so years.
There's a lot to like about it, typing is a highlight for me: annotations + pluggable typesystem.
There's also some limitations that don't make sense to me, for example lambda functions are only allowed to contain one expression.
It's annoying to be forced to name every non-trivial function which can make writing code in a functional style needlessly verbose.
For this solution, being able to use tuples as value types was helpful as I only needed a set of two-tuples as my data structure and didn't have to encode the coordinates.

# c#

C# is a nice solid language that's getting better all the time.
It's not exactly exciting but it feels pragmatic.
I'd have liked to been able to use c# 10 but mono only goes up to C# 6 with partial support for 7.
Using the `csharp` program in the shebang and adding `const` values as top-level expressions led to their values being `0` instead of what was written which is a pretty silly mono bug.
I suppose I should have used Microsoft's implementation instead.
This problem wasn't that hard, without writing a utility class for dealing with lists of ranges then the solution to part 2 isn't going to run in an acceptable amount of time.

# Future

## familiar languages under consideration

- kotlin
- d

## unknown languages that may be used

- purescript
- nim
- groovy
- elixir
- clojure

## some interesting languages not ready for use

- carbon
- val

## some interesting languages that are abandoned

- nemerle
- boo

## familiar languages not interested to use

- javascript: already did typescript and it's basically a subset
- c: as above but for c++
- basic: haven't used it for over 20 years and don't want to
- java: when it comes to the jvm I prefer scala/kotlin
- perl 5: one of the first languages i learned but not really into it anymore
