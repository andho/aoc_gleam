import aoc_2023/day_2.{parse_input}
import gleam/list
import gleeunit/should

pub fn parse_input1_test() {
  ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"]
  |> list.each(fn(line) {
    line
    |> parse_input
    |> should.be_ok
    |> should.equal(
      #(1, [
        day_2.CubeSet(red: 4, blue: 3, green: 0),
        day_2.CubeSet(red: 1, blue: 6, green: 2),
        day_2.CubeSet(red: 0, blue: 0, green: 2),
      ]),
    )
  })
}

pub fn sample_test() {
  let input =
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

  input
  |> day_2.pt_1
  |> should.equal(8)
}

pub fn sample2_test() {
  let input =
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

  input
  |> day_2.pt_2
  |> should.equal(2286)
}
