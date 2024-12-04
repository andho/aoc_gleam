import aoc_2024/day_3
import birdie
import pprint

//const sample_input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

const sample2_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

pub fn parser_test() {
  sample2_input
  |> day_3.parse
  |> pprint.format
  |> birdie.snap(title: "2024 day 3 parser 1")
}
