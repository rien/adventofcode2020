defmodule DayTwo do
  def solve(lines) do
    [
      first: solve_first(lines),
    ]
  end

  def solve_first(lines) do
    Enum.count(lines, &matches_policy(&1))
  end

  def matches_policy(line) do
    [range, condition, password ] = String.split(line, " ")
    [start, stop] = String.split(range, "-") |> Enum.map(&String.to_integer(&1))
    char = String.at(condition, 0)
    count = String.graphemes(password) |> Enum.count(fn x -> x == char end)
    start <= count and count <= stop
  end
end

Common.file_lines("data/day02-input") |> DayTwo.solve |> IO.inspect
