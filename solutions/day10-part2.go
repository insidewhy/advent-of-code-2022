//usr/bin/env go run $0 $@; exit
package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

const interval = 40

func abs(val int) int {
	if val < 0 {
		return -val
	} else {
		return val
	}
}

func main() {
	file, err := os.Open("input-10.txt")
	if err != nil {
		log.Fatalf("failed to open")
		os.Exit(1)
	}
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	yPos := 0
	spritePos := 1

	printPixel := func() {
		if abs(yPos-spritePos) < 2 {
			fmt.Printf("#")
		} else {
			fmt.Printf(".")
		}
		yPos = (yPos + 1) % interval
		if yPos == 0 {
			fmt.Println()
		}
	}

	for scanner.Scan() {
		line := scanner.Text()
		printPixel()
		if line != "noop" {
			parts := strings.Split(line, " ")
			if len(parts) != 2 {
				log.Fatalf("bad line: %s", line)
				os.Exit(1)
			}
			signalDelta, err := strconv.ParseInt(parts[1], 10, 32)
			if err != nil {
				log.Fatalf("bad signal delta")
				os.Exit(1)
			}
			printPixel()
			spritePos += int(signalDelta)
		}
	}
	file.Close()
}
