import os

struct Number {
mut:
	bbox [4]int
	nval  string
}

struct Symbol {
	row	int
	col int
}

fn parse(lines []string) !([]Number, []Symbol) {
	mut numbers := []Number{}
	mut symbols := []Symbol{}
	mut row := 0
	mut parsing_number := false
	mut n := Number{}
	for line in lines {
		for col, data in line.runes() {
			// print("${row} ${col}: ")
			match data {
				`.` { 
					if parsing_number {
						numbers << n
						parsing_number = false
					}
				}
				`0`...`9` {
					if !parsing_number {
						n.bbox[0] = row - 1
						n.bbox[1] = row + 1
						n.bbox[2] = col - 1
						n.bbox[3] = col + 1
						n.nval = "${data}"
						parsing_number = true
					} else {
						n.bbox[3] = col + 1
						n.nval += "${data}"
					}
				}
				else { 
					if parsing_number {
						parsing_number = false
						n.bbox[3] = col
						numbers << n
					}
					symbols << Symbol{row,col}
				}
			}
		}
		if parsing_number {
			numbers << n
			parsing_number = false
		}
		row ++
	}
	return numbers, symbols
}

fn main() {
	lines := os.read_lines('input') or {
		eprintln('we have no input')
		return
	}
	mut result := 0
 	numbers, symbols := parse(lines) or {
 		panic("failed to parse input")
 	}
 	for number in numbers {
 		for symbol in symbols {
 			if number.bbox[0] <= symbol.row && symbol.row <= number.bbox[1] &&
 			   number.bbox[2] <= symbol.col && symbol.col <= number.bbox[3] {
 			   	if number.nval.int() == 0 {
 			   		panic("parse error")
 			   	}
 			   	result += number.nval.int()
 			}
 		}
 	}
	println(result)
}
