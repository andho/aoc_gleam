import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn pt_1(input: List(#(Int, Int))) {
  let #(left_list, right_list) =
    input
    |> list.unzip

  let left_list =
    left_list
    |> list.sort(fn(a, b) { int.compare(a, b) })

  let right_list =
    right_list
    |> list.sort(fn(a, b) { int.compare(a, b) })

  list.zip(left_list, right_list)
  |> list.map(fn(line) {
    let #(left, right) = line
    int.absolute_value(left - right)
  })
  |> int.sum
}

pub fn pt_2(input: List(#(Int, Int))) {
  let #(left_list, right_list) =
    input
    |> list.unzip

  left_list
  |> list.map(fn(left) {
    let matches = list.filter(right_list, fn(right) { left == right })

    left * list.length(matches)
  })
  |> int.sum
}

pub fn parse(input: String) -> List(#(Int, Int)) {
  input
  |> string.split("\n")
  |> list.filter_map(fn(line) {
    use #(left, right) <- result.try(
      line
      |> string.split_once(" "),
    )

    use left <- result.try(int.parse(left))
    use right <- result.try(int.parse(string.trim(right)))

    Ok(#(left, right))
  })
}
