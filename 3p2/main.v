import os

struct Number {
	bbox [4]int
	nval  string
}

struct Symbol {
	row	int
	col int
  sym rune
}

fn parse(lines []string) !([]Number, []Symbol) {
	mut numbers := []Number{}
	mut symbols := []Symbol{}
	mut row := 0
	mut parsing_number := false
	mut n := Number{}
	for line in lines {
		for col, data in line.runes() {
			match data {
				`.` { 
					if parsing_number {
						numbers << n
						parsing_number = false
					}
				}
				`0`...`9` {
					if !parsing_number {
					  n = Number{[row-1,row+1,col-1,col+1]!,"${data}"}
						parsing_number = true
					} else {
						n = Number{[n.bbox[0],n.bbox[1],n.bbox[2],col+1]!, "${n.nval}${data}"}
					}
				}
				else { 
					if parsing_number {
						parsing_number = false
						numbers << n
					}
					symbols << Symbol{row,col,data}
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
 	for symbol in symbols {
 		if symbol.sym != `*` {
 			continue
 		}
 		// symbol is a gear
 		mut adj := []Number{}
		for number in numbers {
 			if number.bbox[0] <= symbol.row && symbol.row <= number.bbox[1] &&
 			   number.bbox[2] <= symbol.col && symbol.col <= number.bbox[3] {
 				adj << number
 			}
		}
		if adj.len == 2 {
			result += adj[0].nval.int() * adj[1].nval.int()
		}
 	}
	println(result)
}
