import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.filter_map(fn(line) {
    let digits =
      line
      |> string.to_graphemes
      |> list.filter_map(fn(grapheme) { int.parse(grapheme) })

    use first <- result.try(list.first(digits))
    use last <- result.try(list.last(digits))

    Ok(first * 10 + last)
  })
  |> list.fold(0, fn(a, b) { a + b })
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.filter_map(fn(line) {
    use digits <- result.try(find_digits(line, list.new()))

    use first <- result.try(list.first(digits))
    use last <- result.try(list.last(digits))

    Ok(first * 10 + last)
  })
  |> list.fold(0, fn(a, b) { a + b })
}

pub fn find_digits(input: String, the_list: List(Int)) -> Result(List(Int), Nil) {
  use <- bool.guard(string.is_empty(input), Ok(the_list))

  use #(first, rest) <- result.try(
    bool.lazy_guard(string.length(input) == 1, fn() { Ok(#(input, "")) }, fn() {
      string.pop_grapheme(input)
    }),
  )

  use <- result.lazy_or(
    first
    |> int.parse
    |> result.try(fn(the_digit) {
      the_list
      |> list.append([the_digit])
      |> find_digits(rest, _)
    }),
  )

  let five_letters = first <> string.slice(rest, 0, 5)

  let new_digit = case five_letters {
    "one" <> _ -> [1]
    "two" <> _ -> [2]
    "three" <> _ -> [3]
    "four" <> _ -> [4]
    "five" <> _ -> [5]
    "six" <> _ -> [6]
    "seven" <> _ -> [7]
    "eight" <> _ -> [8]
    "nine" <> _ -> [9]
    _ -> []
  }

  find_digits(rest, list.append(the_list, new_digit))
}
