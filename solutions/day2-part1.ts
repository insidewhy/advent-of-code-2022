#!/usr/bin/env -S npx ts-node

import { readFile } from "fs/promises"

const opponentCodes = new Map<string, number>([
  ["A", 0],
  ["B", 1],
  ["C", 2],
])
const myCodes = new Map<string, number>([
  ["X", 0],
  ["Y", 1],
  ["Z", 2],
])

const drawScore = 3
const winScore = 6

const score = (opponentHand: number, myHand: number) => {
  const handScore = myHand + 1
  if (opponentHand === myHand) {
    return drawScore + handScore
  } else if (myHand === (opponentHand + 1) % 3) {
    return winScore + handScore
  } else {
    return handScore
  }
}

;(async () => {
  const lines = (await readFile("input-2.txt")).toString().trim().split("\n")
  console.log(
    lines
      .map((line) => {
        const opponentHand = opponentCodes.get(line[0])
        const myHand = myCodes.get(line[2])
        if (opponentHand === undefined) throw new Error(`Bad opponent code ${line[0]}`)
        if (myHand === undefined) throw new Error(`Bad code for me ${line[1]}`)

        return score(opponentHand, myHand)
      })
      .reduce((a, b) => a + b)
  )
})()
