import os

fn main() {
  lines := os.read_lines("input") or {
    eprintln("we have no input")
    return
  }
  mut result := 0
  for line in lines {
    mut first := rune(0)
    mut last := rune(0)
    for _, c in line {
      if c.is_digit() {
        if first == rune(0) {
          first = c
        }
        last = c
      }
    }
    nfirst := int(first - `0`)
    nlast := int(last - `0`)
    result += 10*nfirst + nlast
  }
  println(result)
}
