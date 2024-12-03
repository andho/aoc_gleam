import aoc_2024/day_2
import birdie
import pprint

const sample_input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
10 5 4 2 13"

//const sample_input = "7 6 4 2 1"

//const sample_input = "1 2 7 8 9"

//const sample_input = "9 7 6 2 1"

//const sample_input = "1 3 2 4 5"

//const sample_input = "8 6 4 4 1"

//const sample_input = "1 3 6 7 9"

const edge_sample_input = "10 5 4 2 1"

const edge2_sample_input = "1 2 3 5 4 5 6"

pub fn parse_sample_test() {
  sample_input
  |> day_2.parse
  |> day_2.pt_1
  |> pprint.format
  |> birdie.snap(title: "test 2024 day 2 pt 1")
}

pub fn pt2_test() {
  sample_input
  |> day_2.parse
  |> day_2.pt_2
  |> pprint.format
  |> birdie.snap(title: "2024 day 2 pt 2")
}

pub fn edge_case_test() {
  edge_sample_input
  |> day_2.parse
  |> day_2.pt_2
  |> pprint.format
  |> birdie.snap(title: "2024 day 2 edge case")
}

pub fn edge2_case_test() {
  edge2_sample_input
  |> day_2.parse
  |> day_2.pt_2
  |> pprint.format
  |> birdie.snap(title: "2024 day 2 edge case 2")
}
