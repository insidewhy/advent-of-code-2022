#!/usr/bin/env ruby

puts File.read('input-1.txt').split("\n\n").map { |cals| cals.split("\n").map(&:to_i).sum }.max
