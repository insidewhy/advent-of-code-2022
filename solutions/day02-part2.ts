#!/usr/bin/env -S npx ts-node

import { readFile } from "fs/promises"

const opponentCodes = new Map<string, number>([
  ["A", 0],
  ["B", 1],
  ["C", 2],
])

type Result = "lose" | "draw" | "win"
const resultCodes = new Map<string, Result>([
  ["X", "lose"],
  ["Y", "draw"],
  ["Z", "win"],
])

const drawScore = 3
const winScore = 6

const score = (opponentHand: number, result: Result) => {
  if (result === "draw") {
    return drawScore + opponentHand + 1
  } else if (result === "win") {
    return winScore + ((opponentHand + 1) % 3) + 1
  } else {
    // use +2 instead of -1 to play nice with modular arithmetic
    return ((opponentHand + 2) % 3) + 1
  }
}

;(async () => {
  const lines = (await readFile("input-2.txt")).toString().trim().split("\n")
  console.log(
    lines
      .map((line) => {
        const opponentHand = opponentCodes.get(line[0])
        const result = resultCodes.get(line[2])
        if (opponentHand === undefined) throw new Error(`Bad opponent code ${line[0]}`)
        if (result === undefined) throw new Error(`Bad result code ${line[1]}`)

        return score(opponentHand, result)
      })
      .reduce((a, b) => a + b)
  )
})()
