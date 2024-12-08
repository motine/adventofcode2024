package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

func readNumbers(path string) (left []string, right []string) {
	f, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := scanner.Text()
		l, r, found := strings.Cut(line, "   ")
		if !found {
			log.Fatal("bad input line")
		}
		left = append(left, l)
		right = append(right, r)
	}
	return
}

func convertStrings(arr []string) []int {
	converted := make([]int, len(arr))
	for i, s := range arr {
		toi, err := strconv.Atoi(s)
		if err != nil {
			log.Fatal("err")
		}
		converted[i] = toi
	}
	return converted
}

func abs(i int) int {
	if i < 0 {
		return -i
	} else {
		return i
	}
}

func main() {
	leftStrs, rightStrs := readNumbers("01.txt")
	leftInts := convertStrings(leftStrs)
	rightInts := convertStrings(rightStrs)
	sort.Ints(leftInts)
	sort.Ints(rightInts)

	sum := 0
	for i := range leftInts {
		sum += abs(leftInts[i] - rightInts[i])
	}
	fmt.Println(sum)
}
