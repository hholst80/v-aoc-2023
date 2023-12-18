import os
import arrays
import strconv

struct Function {
	dst   []u64
	src   []u64
	len   []u64	
}

struct Problem {
mut:
	seeds []u64
	funcs []Function
}

fn parse(lines []string) !Problem {
	mut p := Problem{}
	mut l := 0
	
	for s in lines[l].split(" ") {
		if s == "seeds:" { continue }
		p.seeds << strconv.parse_uint(s, 10, 64) or { return error("parse error: seeds") }
	}
	l++

	assert lines[l++] == ""

	for l < lines.len {
		a, b := lines[l++].split_once(" ")
		assert b == "map:"
		from, to := a.split_once("-to-")
		// println("parsing function: ${from} -> ${to}")
		mut d := []u64{}
		mut s := []u64{}
		mut r := []u64{}
		for l < lines.len && lines[l] != "" {
			split_line := lines[l++].split(" ")
			d << strconv.parse_uint(split_line[0], 10, 64) or { return error("parse error: function: ${err}") }
			s << strconv.parse_uint(split_line[1], 10, 64) or { return error("parse error: function: ${err}") }
			r << strconv.parse_uint(split_line[2], 10, 64) or { return error("parse error: function: ${err}") }
		}
		p.funcs << Function{d,s,r}
		l++
	}
	
	return p
}

fn eval(f Function, x u64) u64 {
	for i := 0; i < f.src.len; i++ {
		if f.src[i] <= x && x < f.src[i] + f.len[i] {
			return x - f.src[i] + f.dst[i]
		}
	}
	return x
}

fn solve(p Problem) (u64, u64) {
	mut min_val := u64(0)
	mut min_arg := u64(0)
	for seed in p.seeds {
		mut y := seed
		for i := 0; i < p.funcs.len; i++ {
			y = eval(p.funcs[i], y)
		}
		if min_val == 0 || y < min_val {
			min_arg = seed
			min_val = y
		}
	}
	return min_val, min_arg
}

fn main() {
	lines := os.read_lines('input') or {
		eprintln('we have no input')
		return
	}
	problem := parse(lines) or {
		panic(err)
	}
	location, seed := solve(problem)
	println("location: ${location}")
	println("seed: ${seed}")
}
