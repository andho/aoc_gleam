import aoc_2023/day_1.{find_digits}
import gleeunit/should

pub fn justdigits_test() {
  "31"
  |> find_digits([])
  |> should.be_ok
  |> should.equal([3, 1])
}

pub fn example1_test() {
  "two1nine"
  |> find_digits([])
  |> should.be_ok
  |> should.equal([2, 1, 9])
}

pub fn example2_test() {
  "eightwothree"
  |> find_digits([])
  |> should.be_ok
  |> should.equal([8, 2, 3])
}

pub fn example3_test() {
  "abcone2threexyz"
  |> find_digits([])
  |> should.be_ok
  |> should.equal([1, 2, 3])
}

pub fn example4_test() {
  "xtwone3four"
  |> find_digits([])
  |> should.be_ok
  |> should.equal([2, 1, 3, 4])
}

pub fn example5_test() {
  "4nineeightseven2"
  |> find_digits([])
  |> should.be_ok
  |> should.equal([4, 9, 8, 7, 2])
}

pub fn example6_test() {
  "zoneight234"
  |> find_digits([])
  |> should.be_ok
  |> should.equal([1, 8, 2, 3, 4])
}

pub fn example7_test() {
  "7pqrstsixteen"
  |> find_digits([])
  |> should.be_ok
  |> should.equal([7, 6])
}
