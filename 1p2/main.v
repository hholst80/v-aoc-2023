import os
import math

fn helper(str string) !(int, int) {
  if str.len == 1 {
    return word2int(str)
  } else {
    return word2int(str) or { helper(str[0..str.len-1])! }
  }
}

fn word2int(word string) !(int, int) {
  match word {
    "1" { return 1, 1 }
    "2" { return 2, 1 }
    "3" { return 3, 1 }
    "4" { return 4, 1 }
    "5" { return 5, 1 }
    "6" { return 6, 1 }
    "7" { return 7, 1 }
    "8" { return 8, 1 }
    "9" { return 9, 1 }
    "one" { return 1, 3 }
    "two" { return 2, 3 }
    "three" { return 3, 5 }
    "four" { return 4, 4 }
    "five" { return 5, 4 }
    "six" { return 6, 3 }
    "seven" { return 7, 5 }
    "eight" { return 8, 5 }
    "nine" { return 9, 4 }
    else { return error("not a digit") }
  }
}

fn main() {
  lines := os.read_lines("input") or {
    eprintln("we have no input")
    return
  }
  mut result := 0
  for line in lines {
    mut c := 0
    mut first := 0
    mut last := 0
    // println("iterating over line: ${line}")
    for c < line.len {
      // println("testing ${line[c..math.min(c+5, line.len)]}")
      digit, len := helper(line[c..math.min(c+5, line.len)]) or {
        c ++
        continue
      }
      if first == 0 {
        first = digit
      }
      last = digit
      c ++
    }
    partial_result := 10*first + last
    // println(partial_result)
    result += partial_result
  }
  println(result)
}
