import aoc_2023/day_3.{parse_line, pt_1, pt_2}
import birdie
import gleam/list
import gleam/string
import pprint

const test_lines = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."

const test_line2 = ".792+..............828................-807.6...........326....324...722...334..*...........*................................................"

pub fn parse_input_line1_test() {
  test_lines
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> parse_line
  })
  |> pprint.format
  |> birdie.snap(title: "day3 parse input 1")
}

pub fn parse_input_line2_test() {
  test_line2
  |> parse_line
  |> pprint.format
  |> birdie.snap(title: "day3 parse input 2")
}

pub fn day3_pt1_test() {
  test_lines
  |> pt_1
  |> pprint.format
  |> birdie.snap(title: "day3 part 1")
}

pub fn day3_pt2_test() {
  test_lines
  |> pt_2
  |> pprint.format
  |> birdie.snap(title: "day3 part 2")
}
