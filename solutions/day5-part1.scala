#!/usr/bin/env -S scala -deprecation

import scala.io.Source
import scala.collection.mutable.Stack

val LINE_PREFIX_LENGTH = 1
val FIELD_LENGTH = 4
val STACK_TERMINATOR_PREFIX = " "
val MOVE_REGEX = raw"move (\d+) from (\d+) to (\d+)".r

val stacks = Stack[Stack[Char]]()
val lines = Source.fromFile("input-5.txt").getLines()

lines.takeWhile(! _.startsWith(STACK_TERMINATOR_PREFIX)).foreach(line => {
  for (i <- LINE_PREFIX_LENGTH to line.length by FIELD_LENGTH) {
    val container = line(i)
    if (container != ' ') {
      val idx = (i - LINE_PREFIX_LENGTH) / FIELD_LENGTH
      if (idx >= stacks.length) {
        for (j <- stacks.length to idx) {
          stacks += Stack[Char]()
        }
      }
      // appending to a stack is expensive but there are far more moves than builds
      stacks(idx).append(container)
    }
  }
})

// skip empty line
lines.next()

object Int {
  def unapply(s: String): Option[Int] = util.Try(s.toInt).toOption
}

lines.foreach(line => {
  line match {
    case MOVE_REGEX(Int(amount), Int(srcStackIdx), Int(destStackIdx)) => {
      val srcStack = stacks(srcStackIdx - 1)
      val destStack = stacks(destStackIdx - 1)
      for (i <- 0 until amount) {
        destStack.push(srcStack.pop())
      }
    }
    case _ => throw new RuntimeException(s"line $line does not match move pattern")
  }
})

println(stacks.map(stack => stack.top).mkString(""))
