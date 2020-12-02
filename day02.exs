defmodule DayTwo do
  def solve(lines) do
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
    p1 = Enum.at(pw, start - 1) == char
    p2 = Enum.at(pw, stop - 1) == char
    (p1 and not p2) or (not p1 and p2)
  end
end

Common.file_lines("data/day02-input") |> DayTwo.solve |> IO.inspect
