import aoc_2024/day_1
import birdie
import pprint

const sample_input = "3   4
4   3
2   5
1   3
3   9
3   3"

pub fn parse_sample_test() {
  sample_input
  |> day_1.parse
  |> day_1.pt_1
  |> pprint.format
  |> birdie.snap(title: "test 2024 day 1 pt 1")
}

pub fn pt2_test() {
  sample_input
  |> day_1.parse
  |> day_1.pt_2
  |> pprint.format
  |> birdie.snap(title: "2024 day 1 pt 2")
}
