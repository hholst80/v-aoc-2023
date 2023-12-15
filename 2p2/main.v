// TODO: How does string.int() capture errors?
import os
import strconv
import math.stats

// parse parses a line of the form
// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
// and returns game_number, #red, #green, #blue
fn parse(line string) !(int, []int, []int, []int) {
	if left, right := line.split_once(':') {
		game, game_number_str := left.split_once(' ')
		if game != 'Game' {
			return error('parse error: ${game}')
		}
		game_number := strconv.atoi(game_number_str) or {
			return error('invalid game number: ${game_number_str}')
		}
		mut red := []int{}
		mut green := []int{}
		mut blue := []int{}
		for set in right.split(';') {
			color_counts := set.split(',')
			mut nred, mut ngreen, mut nblue := 0, 0, 0
			for color_count in color_counts {
				cnt, color := color_count.trim(' ').split_once(' ')
				match color {
					'red' {
						nred = strconv.atoi(cnt) or { return error('invalid color count: ${cnt}') }
					}
					'green' {
						ngreen = strconv.atoi(cnt) or {
							return error('invalid color count: ${cnt}')
						}
					}
					'blue' {
						nblue = strconv.atoi(cnt) or { return error('invalid color count: ${cnt}') }
					}
					else {
						return error('invalid color name: ${color}')
					}
				}
			}
			red << nred
			green << ngreen
			blue << nblue
		}
		return game_number, red, green, blue
	}
	return error('parse error: ${line}')
}

const max_red = 12
const max_green = 13
const max_blue = 14

fn amax(arr []int) !int {
	if arr.len == 0 {
		return error("empty input")
	}
	return stats.max(arr)
}

fn main() {
	lines := os.read_lines('input') or {
		eprintln('we have no input')
		return
	}
	// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
	mut result := 0 // sum of valid game ID's
	for line in lines {
		_, red, green, blue := parse(line) or {
			panic('parse error on line: ${line}\n${err}')
		}
		min_red := amax(red) or { panic("empty set not allowed") }
		min_green := amax(green) or { panic("empty set not allowed") }
		min_blue := amax(blue) or { panic("empty set not allowed") }
		power := min_red * min_green * min_blue
		result += power
	}
	println(result)
}
