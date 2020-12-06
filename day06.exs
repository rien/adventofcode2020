defmodule DaySix do
  def solve do
    groups = Common.file_lines("input/day06.in")
             |> Enum.reduce([[]], &to_groups/2)
    [first: solve_first(groups), second: solve_second(groups)]
  end

  def to_groups(line, acc) do
    if line == "" do
      [[] | acc]
    else
      [head | tail] = acc
      chars = String.graphemes(line) |> MapSet.new
      [[chars] ++ head | tail]
    end
  end

  def merge_and_sum_with(groups, merger) do
    groups
    |> Enum.map(fn group -> Enum.reduce(group, merger) |> Enum.count end)
    |> Enum.sum
  end

  def solve_first(groups) do
    merge_and_sum_with(groups, &MapSet.union/2)
  end

  def solve_second(groups) do
    merge_and_sum_with(groups, &MapSet.intersection/2)
  end
end

DaySix.solve |> IO.inspect
