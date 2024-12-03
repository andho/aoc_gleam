import gleam/bool
import gleam/dict
import gleam/int
import gleam/iterator
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

pub fn pt_1(input: String) {
  let lines =
    input
    |> string.split("\n")
    |> list.index_map(fn(line, line_number) {
      line
      |> parse_line
      |> pair.new(line_number, _)
    })
    |> dict.from_list

  iterator.range(0, dict.size(lines))
  |> iterator.fold(0, fn(acc, line_number) {
    let prev =
      lines
      |> dict.get(line_number - 1)
      |> result.unwrap([])
    let curr =
      lines
      |> dict.get(line_number)
      |> result.unwrap([])
    let next =
      lines
      |> dict.get(line_number + 1)
      |> result.unwrap([])

    let line_total =
      list.filter_map(curr, fn(component) {
        case component {
          Number(value: num, bounds: #(start, end)) -> {
            let touches_prev =
              prev
              |> list.any(fn(c) {
                case c {
                  Symbol(value: _, bounds: #(s, _)) -> {
                    { s >= start - 1 && s <= end + 1 }
                  }
                  _ -> False
                }
              })
            let touches_curr =
              curr
              |> list.any(fn(c) {
                case c {
                  Symbol(value: _, bounds: #(s, _)) -> {
                    { s >= start - 1 && s <= end + 1 }
                  }
                  _ -> False
                }
              })
            let touches_next =
              next
              |> list.any(fn(c) {
                case c {
                  Symbol(value: _, bounds: #(s, _)) -> {
                    { s >= start - 1 && s <= end + 1 }
                  }
                  _ -> False
                }
              })
            case
              touches_prev |> bool.or(touches_curr) |> bool.or(touches_next)
            {
              True -> Ok(num)
              False -> Error(Nil)
            }
          }
          _ -> Error(Nil)
        }
      })
      |> int.sum

    acc + line_total
  })
}

pub fn pt_2(input: String) {
  let line_list =
    input
    |> string.split("\n")
    |> list.index_map(fn(line, line_number) {
      line
      |> parse_line
      |> pair.new(line_number, _)
    })
  let lines =
    line_list
    |> dict.from_list

  let stars =
    line_list
    |> list.map(fn(line) {
      line.1
      |> list.filter_map(fn(component) {
        case component {
          Symbol("*", bounds) -> Ok(#(line.0, bounds))
          _ -> Error(Nil)
        }
      })
    })
    |> list.flatten

  stars
  |> list.map(fn(linestars) {
    let #(line, #(s, _)) = linestars

    let prev =
      lines
      |> dict.get(line - 1)
      |> result.unwrap([])
      |> list.filter_map(fn(component) {
        case component {
          Number(num, bounds) -> Ok(#(num, bounds))
          _ -> Error(Nil)
        }
      })

    let curr =
      lines
      |> dict.get(line)
      |> result.unwrap([])
      |> list.filter_map(fn(component) {
        case component {
          Number(num, bounds) -> Ok(#(num, bounds))
          _ -> Error(Nil)
        }
      })

    let next =
      lines
      |> dict.get(line + 1)
      |> result.unwrap([])
      |> list.filter_map(fn(component) {
        case component {
          Number(num, bounds) -> Ok(#(num, bounds))
          _ -> Error(Nil)
        }
      })

    list.flatten([prev, curr, next])
    |> list.filter(fn(numberbounds) {
      let #(_, #(start, end)) = numberbounds
      s >= start - 1 && s <= end + 1
    })
    |> list.map(fn(numberbounds) { numberbounds.0 })
  })
  |> list.filter(fn(gear_number) { list.length(gear_number) > 1 })
  |> list.map(fn(gear_numbers) {
    gear_numbers
    |> int.product
  })
  |> int.sum
}

pub type Bounds =
  #(Int, Int)

pub type Component {
  Number(value: Int, bounds: Bounds)
  Symbol(value: String, bounds: Bounds)
}

pub fn parse_line(input: String) -> List(Component) {
  {
    input
    |> string.split(".")
    |> list.fold(#([], 0), fn(acc, part) {
      use <- bool.guard(string.is_empty(part), #(acc.0, acc.1 + 1))

      let splits = split_part(#(S(""), []), string.to_graphemes(part))

      let total_splits = list.length(splits)
      list.index_fold(splits, #(acc.0, acc.1), fn(acc2, split, index) {
        let offset = case index + 1 == total_splits {
          True -> 1
          False -> 0
        }
        case split {
          I(num) -> {
            let split_length = string.length(int.to_string(num))
            #(
              list.append(acc2.0, [
                Number(value: num, bounds: #(acc2.1, acc2.1 + split_length - 1)),
              ]),
              acc2.1 + split_length + offset,
            )
          }
          S(sym) -> {
            let split_length = string.length(sym)
            #(
              list.append(acc2.0, [
                Symbol(value: sym, bounds: #(acc2.1, acc2.1 + split_length - 1)),
              ]),
              acc2.1 + split_length + offset,
            )
          }
        }
      })
    })
  }.0
}

pub type IntOrString {
  S(String)
  I(Int)
}

pub fn split_part(
  acc: #(IntOrString, List(IntOrString)),
  graphemes: List(String),
) -> List(IntOrString) {
  case graphemes {
    [] -> {
      list.filter(list.append(acc.1, [acc.0]), fn(g) {
        case g {
          S(s) -> !string.is_empty(s)
          _ -> True
        }
      })
    }
    [g, ..rest] -> {
      case acc.0, int.parse(g) {
        I(prev), Ok(num) -> split_part(#(I(prev * 10 + num), acc.1), rest)
        S(prev), Ok(num) ->
          split_part(#(I(num), list.append(acc.1, [S(prev)])), rest)
        S(prev), Error(_) -> split_part(#(S(prev <> g), acc.1), rest)
        I(prev), Error(_) ->
          split_part(#(S(g), list.append(acc.1, [I(prev)])), rest)
      }
    }
  }
}

pub fn map_unwrap(res: Result(a, b), default: c, f: fn(a) -> c) -> c {
  res |> result.map(f) |> result.unwrap(default)
}
