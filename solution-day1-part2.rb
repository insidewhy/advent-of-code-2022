#!/usr/bin/env ruby

puts File.read('input-1.txt').split("\n\n").map { |cals| cals.split("\n").map(&:to_i).sum }
  .sort.reverse.slice(0, 3).sum
