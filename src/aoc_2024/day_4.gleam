import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder

type Line =
  List(String)

type LineDict =
  dict.Dict(Int, Line)

type Vec2 =
  #(Int, Int)

type Seeker {
  Seeker(
    line: Line,
    position: Vec2,
    line_dict: LineDict,
    dir: Vec2,
    seek: String,
  )
}

pub fn pt_1(input: LineDict) {
  yielder.range(0, dict.size(input) - 1)
  |> yielder.fold(0, fn(acc, line_number) {
    use line <- map_unwrap(input |> dict.get(line_number), 0)

    acc + find_xmas(line, line_number, input)
  })
}

fn find_xmas(line: Line, line_num: Int, line_dict: LineDict) {
  line
  |> list.index_map(fn(char, col) {
    case char {
      "X" -> find_mas(line, line_num, col, line_dict)
      _ -> 0
    }
  })
  |> int.sum
}

fn find_mas(line: Line, line_num: Int, col: Int, line_dict: LineDict) {
  let seeker =
    Seeker(
      line:,
      position: #(col, line_num),
      line_dict:,
      dir: #(0, 0),
      seek: "MAS",
    )
  let right = find_mas_direction(Seeker(..seeker, dir: #(1, 0)))
  let left = find_mas_direction(Seeker(..seeker, dir: #(-1, 0)))
  let up = find_mas_direction(Seeker(..seeker, dir: #(0, -1)))
  let down = find_mas_direction(Seeker(..seeker, dir: #(0, 1)))

  let upright = find_mas_direction(Seeker(..seeker, dir: #(1, -1)))
  let upleft = find_mas_direction(Seeker(..seeker, dir: #(-1, -1)))
  let downright = find_mas_direction(Seeker(..seeker, dir: #(1, 1)))
  let downleft = find_mas_direction(Seeker(..seeker, dir: #(-1, 1)))

  right + left + up + down + upright + upleft + downright + downleft
}

fn find_mas_direction(seeker: Seeker) -> Int {
  let default = 0

  use #(grapheme, rest) <- map_unwrap(string.pop_grapheme(seeker.seek), 1)

  let next_pos = vec2_add(seeker.position, seeker.dir)

  use current_grapheme <- map_unwrap(get_index(seeker, next_pos), default)

  case grapheme == current_grapheme {
    True -> find_mas_direction(Seeker(..seeker, seek: rest, position: next_pos))
    False -> 0
  }
}

fn map_unwrap(res: Result(a, b), default: c, f: fn(a) -> c) -> c {
  res |> result.map(f) |> result.unwrap(default)
}

fn vec2_add(a: Vec2, b: Vec2) {
  #(a.0 + b.0, a.1 + b.1)
}

fn get_index(seeker: Seeker, pos: Vec2) {
  use line <- result.try(seeker.line_dict |> dict.get(pos.1))

  line
  |> list.drop(pos.0)
  |> list.first
}

pub fn pt_2(input: LineDict) {
  todo as "part 2 not implemented"
}

pub fn parse(input: String) {
  input
  |> string.split("\n")
  |> list.index_map(fn(line, line_number) {
    let letters = string.to_graphemes(line)
    #(line_number, letters)
  })
  |> dict.from_list
}
