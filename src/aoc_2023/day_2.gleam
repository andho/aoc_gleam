import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.filter_map(parse_input)
  |> list.filter(fn(game) {
    game.1
    |> list.all(fn(group) {
      case group {
        CubeSet(count, ..) if count > 12 -> False
        CubeSet(_, count, ..) if count > 12 -> False
        CubeSet(_, _, count) if count > 12 -> False
        _ -> True
      }
    })
  })
  |> list.fold(0, fn(acc, game) { acc + game.0 })
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.filter_map(parse_input)
  |> list.map(fn(game) {
    game.1
    |> list.fold(CubeSet(0, 0, 0), fn(min, curr) {
      CubeSet(
        red: case curr.red > min.red {
          True -> curr.red
          False -> min.red
        },
        green: case curr.green > min.green {
          True -> curr.green
          False -> min.green
        },
        blue: case curr.blue > min.blue {
          True -> curr.blue
          False -> min.blue
        },
      )
    })
  })
  |> list.map(fn(min) { min.red * min.green * min.blue })
  |> list.fold(0, fn(a, b) { a + b })
}

pub type Color {
  Red
  Green
  Blue
}

pub fn parse_input(input: String) -> Result(#(Int, List(CubeSet)), Nil) {
  use #(game, data) <- result.try(string.split_once(input, ": "))

  use game_num <- result.try(case game {
    "Game " <> num -> int.parse(num)
    _ -> Error(Nil)
  })

  let groups = string.split(data, "; ")

  use parsed_groups <- result.try(
    result.all(
      list.map(groups, fn(group) {
        let colors = string.split(group, ", ")

        use a <- result.try(
          result.all(
            list.map(colors, fn(color) {
              use #(count_str, color_str) <- result.try(string.split_once(
                color,
                " ",
              ))

              use count <- result.try(int.parse(count_str))

              use color <- result.try(case color_str {
                "red" -> Ok(Red)
                "blue" -> Ok(Blue)
                "green" -> Ok(Green)
                _ -> Error(Nil)
              })

              Ok(#(count, color))
            }),
          ),
        )

        let red = get_color_count(a, Red)
        let green = get_color_count(a, Green)
        let blue = get_color_count(a, Blue)

        Ok(CubeSet(red:, green:, blue:))
      }),
    ),
  )

  Ok(#(game_num, parsed_groups))
}

fn get_color_count(cube_set: List(#(Int, Color)), color: Color) -> Int {
  cube_set
  |> list.find(fn(color_pair) {
    case color_pair {
      #(_, c) if c == color -> True
      _ -> False
    }
  })
  |> result.map(fn(b) { b.0 })
  |> result.unwrap(0)
}

pub type CubeSet {
  CubeSet(red: Int, green: Int, blue: Int)
}
//pub fn minimum(game: #(Int, List(List(#(Int, Color))))) -> Minimum {
//  list.fold(game.1, Minimum(0, 0, 0), fn(m, group) {
//    Minimum(
//      red:
//  })
//}
