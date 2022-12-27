#!/usr/bin/env rakudo

class Monkey {
  has UInt @!items;
  has &!operation;
  has UInt $!divisible-by;
  has UInt $!if-true;
  has UInt $!if-false;
  has UInt $!max-num;
  has &!throw-to;
  has $.inspection-count = 0;

  submethod BUILD(
    :@!items,
    :$!if-true,
    :$!if-false,
    :$!max-num,
    :$!divisible-by,
    :&!throw-to,
    :$operator,
    :$argument,
  ) {
    if $argument === 'old' {
      &!operation = { $_ ** 2 };
    } else {
      my $int-argument = +$argument;
      if $operator === '*' {
        &!operation = { $_ * $int-argument }
      } else {
        &!operation = { $_ + $int-argument }
      }
    }
  }

  submethod push-item(UInt $item) {
    push @!items, $item;
  }

  submethod take-turn {
    $!inspection-count += @!items.elems;

    for @!items.splice {
      my $new-item = &!operation($_) % $!max-num;
      if ($new-item % $!divisible-by) == 0 {
        &!throw-to($!if-true, $new-item);
      } else {
        &!throw-to($!if-false, $new-item);
      }
    }
  }
}

class MonkeyGroup {
  has Monkey @.monkeys;

  method BUILD(:@monkey-info) {
    my &throw-to = sub ($idx, $item) {
      @.monkeys[$idx].push-item($item);
    };

    # make a number that all the "divisible-by" tests are divisors of, this can be used
    # to constrain the worry levels otherwise the performance of dealing with hundreds of
    # thousands of big integers leads to a solution that takes days to complete
    my $max-num = [*] @monkey-info.map({ $_<divisible-by> });

    @.monkeys = @monkey-info.map({
      Monkey.new(
        items => $_<starting-items>,
        operator => $_<operator>,
        argument => $_<argument>,
        if-true => $_<if-true>,
        if-false => $_<if-false>,
        divisible-by => $_<divisible-by>,
        throw-to => &throw-to,
        max-num => $max-num,
      )
    })
  }

  method play-round {
    for @.monkeys { $_.take-turn }
  }
}

grammar MonkeyGroupGrammar {
  token TOP { <monkey>+ { make MonkeyGroup.new(monkey-info => $<monkey>.map: *.made) } }
  rule monkey {
    <.monkey-heading> <starting-items> <operation> <test> <if-true> <if-false> {
      make {
        starting-items => List($<starting-items><number>.map(*.made)),
        operator => $<operation>.made<operator>,
        argument => $<operation>.made<argument>,
        divisible-by => $<test>.made,
        if-true => $<if-true>.made,
        if-false => $<if-false>.made,
      }
    }
  }
  rule monkey-heading { 'Monkey' \d+ ':' }

  rule starting-items { 'Starting' 'items:' <number> [ ',' <number> ]* }
  token number { \d+ { make +$/ } }

  rule operation { 'Operation:' 'new' '=' 'old' <operator> <argument>
    { make { operator => $<operator>.Str, argument => $<argument>.Str } }
  }
  token operator { '*' | '+' }
  token argument { \d+ | 'old' }

  rule test { 'Test:' 'divisible' 'by' <number> { make $<number>.made } }

  rule if-true { <if> 'true:' <throw> { make $<throw>.made } }
  rule if-false { <if> 'false:' <throw> { make $<throw>.made } }
  token if { 'If' }
  rule throw { 'throw' 'to' 'monkey' <number> { make $<number>.made } }
}

my $monkey-group = MonkeyGroupGrammar.parsefile('input-11.txt').made;
for 1..10_000 { $monkey-group.play-round };
say [*] $monkey-group.monkeys.map({ $_.inspection-count }).sort.reverse[0..1];
