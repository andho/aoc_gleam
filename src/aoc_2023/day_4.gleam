import gleam/float
import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: List(Line)) {
  input
  |> list.map(winning_nums)
  |> list.map(list.length)
  |> list.filter(fn(x) { x >= 1 })
  |> list.map(int.to_float)
  |> list.map(fn(x) { x -. 1.0 })
  |> list.filter_map(int.power(2, _))
  |> list.map(float.round)
  |> int.sum
}

fn winning_nums(line: Line) -> List(Int) {
  let #(_, winning_nums, player_nums) = line

  player_nums
  |> list.filter(fn(x) { list.contains(winning_nums, x) })
}

//pub fn pt_2(input: List(Line)) {
//  todo as "part 2 not implemented"
//}

type Line =
  #(Int, List(Int), List(Int))

pub fn parse(lines: String) -> List(Line) {
  lines
  |> string.split(on: "\n")
  |> list.map(parse_line)
}

pub fn parse_line(line: String) -> Line {
  let assert Ok(#(game_str, rest)) =
    line
    |> string.split_once(on: ": ")

  let game_num = extract_num(string.to_graphemes(game_str), 0)

  let assert [winning_str, player_str] =
    rest
    |> string.split(on: " | ")

  let winning_nums =
    winning_str
    |> string.split(on: " ")
    |> list.filter_map(int.parse)

  let player_nums =
    player_str
    |> string.split(on: " ")
    |> list.filter_map(int.parse)

  #(game_num, winning_nums, player_nums)
}

fn extract_num(graphemes: List(String), acc: Int) -> Int {
  case graphemes {
    [] -> acc
    [a, ..rest] ->
      case int.parse(a) {
        Ok(x) -> extract_num(rest, acc * 10 + x)
        Error(_) -> extract_num(rest, acc)
      }
  }
}
