import os

fn main() {
  lines := os.read_lines("input") or {
    eprintln("we have no input")
    return
  }
  mut result := 0
  for line in lines {
    mut first := ?rune(none)
    mut last := rune(0)
    for _, c in line {
      if c.is_digit() {
        if first == none {
          first = c
        }
        last = c
      }
    }
    afirst := first or { panic("invalid line: ${line}")}
    nfirst := int(afirst - `0`)
    nlast := int(last - `0`)
    result += 10*nfirst + nlast
  }
  println(result)
}
