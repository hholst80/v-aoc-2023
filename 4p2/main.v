import os
import arrays
import strconv

fn parse(lines []string) !(int, [][]int, [][]int) {
	mut ncards := 0
	mut winning := [][]int{}
	mut card := [][]int{}
	
	for line in lines {
		mut awinning := []int{}
		mut acard := []int{}
		_, b := line.split_once(":") or {
			return error("parse error: missing : symbol on line: ${line}")
		}
		w, c := b.split_once("|") or {
			return error("parse error: missing | symbol on line: ${line}")
		}
		for ws in w.split(" ") {
			if ws == "" { continue }
			awinning << strconv.atoi(ws.trim(" "))!
		}
		for cs in c.split(" ") {
			if cs == "" { continue }
			acard << strconv.atoi(cs.trim(" "))!
		}
		ncards ++
		winning << awinning.sorted()
		card << acard.sorted()
	}

	return ncards, winning, card
}

fn solve(ncards int, winning [][]int, card [][]int) !int {
	mut copies := []int{}
	for i := 0; i < ncards; i++ {
		copies << 0
	}
	for i := 0; i < ncards; i++ {
		ntotal := 1 + copies[i]
		mut nmatch := 0
		for w in winning[i] {
			arrays.binary_search(card[i], w) or { continue }
			nmatch ++
		}
		for j := i+1; j < i + 1 + nmatch; j++ {
			assert j < ncards
			copies[j] += ntotal
		}
	}
	return ncards + arrays.sum(copies)!
}

fn main() {
	lines := os.read_lines('input') or {
		eprintln('we have no input')
		return
	}
	ncards, winning, card := parse(lines) or {
		panic("parse error: ${err}")
	}
	ntotal := solve(ncards, winning, card) or {
		panic("Solve failed")
	}
	println(ntotal)
}
