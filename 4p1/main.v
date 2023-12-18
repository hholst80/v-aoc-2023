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

fn main() {
	lines := os.read_lines('input') or {
		eprintln('we have no input')
		return
	}
	mut result := 0
	ncards, winning, card := parse(lines) or {
		panic("parse error: ${err}")
	}
	for i := 0; i < ncards; i++ {
		mut nmatch := 0
		for w in winning[i] {
			arrays.binary_search(card[i], w) or { continue }
			nmatch ++
		}
		if nmatch > 0 {
			result += 1 << (nmatch-1)
		} 
	}
	println(result)
}
