defmodule DayTwo do
  def solve do
    lines = Common.file_lines("input/day02.in")
    [
      first: solve_first(lines),
      second: solve_second(lines),
    ]
  end

  def solve_first(lines) do
    Enum.count(lines, &matches_first_policy(&1))
  end

  def solve_second(lines) do
    Enum.count(lines, &matches_second_policy(&1))
  end

  def parse_policy(line) do
    [range, condition, password ] = String.split(line, " ")
    [start, stop] = String.split(range, "-") |> Enum.map(&String.to_integer(&1))
    char = String.at(condition, 0)
    [start: start, stop: stop, char: char, password: String.graphemes(password)]
  end

  def matches_first_policy(line) do
    [start: start, stop: stop, char: char, password: pw] = parse_policy(line)
    count = Enum.count(pw, fn x -> x == char end)
    start <= count and count <= stop
  end

  def matches_second_policy(line) do
    [start: start, stop: stop, char: char, password: pw] = parse_policy(line)
    (Enum.at(pw, start - 1) == char) != (Enum.at(pw, stop - 1) == char)
  end
end

DayTwo.solve |> IO.inspect

