import gleam/bool
import gleam/int
import gleam/list
import gleam/string

pub type Acc {
  Empty(ascending: Bool)
  Acc(prev: Int, ascending: Bool)
  Acc2(prev2: Int, prev: Int, ascending: Bool)
}

pub fn pt_1(input: List(List(Int))) {
  input
  |> list.filter(safe(_, 1))
  |> list.length
}

pub fn pt_2(input: List(List(Int))) {
  input
  |> list.filter(safe(_, 2))
  |> list.length
}

fn safe(line: List(Int), threshold: Int) -> Bool {
  valid_line(Empty(True), threshold, line)
  || valid_line(Empty(False), threshold, line)
}

fn valid_pair(a: Int, b: Int, ascending: Bool) -> Bool {
  case ascending {
    True -> a > b && a <= b + 3
    False -> a < b && a >= b - 3
  }
}

fn valid_line(acc: Acc, threshold: Int, line: List(Int)) -> Bool {
  use <- bool.guard(threshold == 0, False)
  use <- bool.guard(list.is_empty(line), True)

  let assert [num, ..rest] = line
  case acc {
    Empty(ascending) -> {
      valid_line(Acc(num, ascending), threshold, rest)
    }
    Acc(prev, ascending) -> {
      case valid_pair(num, prev, ascending) {
        True -> valid_line(Acc2(prev, num, ascending), threshold, rest)
        False ->
          valid_line(Acc(prev, ascending), threshold - 1, rest)
          || valid_line(Acc(num, ascending), threshold - 1, rest)
      }
    }
    Acc2(prev2, prev, ascending) -> {
      case valid_pair(num, prev, ascending) {
        True -> valid_line(Acc2(prev, num, ascending), threshold, rest)
        False ->
          valid_line(Acc2(prev2, prev, ascending), threshold - 1, rest)
          || valid_line(Acc(prev2, ascending), threshold - 1, line)
      }
    }
  }
}

pub fn parse(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.filter_map(int.parse)
  })
}
