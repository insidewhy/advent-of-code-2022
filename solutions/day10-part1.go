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

const offset = 20
const interval = 40

func main() {
	file, err := os.Open("input-10.txt")
	if err != nil {
		log.Fatalf("failed to open")
		os.Exit(1)
	}
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	cycle := 1
	signal, result := 1, 0
	for scanner.Scan() {
		line := scanner.Text()
		cycleDelta := 1
		if line != "noop" {
			cycleDelta = 2
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
			signal += int(signalDelta)
		}

		cycle += cycleDelta
		cycleOffset := (cycle + offset) % interval
		if cycleOffset == (interval-1) || (cycleOffset == 0 && cycleDelta != 1) {
			result += (cycle + ((interval - cycleOffset) % interval)) * signal
		}
	}
	file.Close()
	fmt.Println(result)
}
