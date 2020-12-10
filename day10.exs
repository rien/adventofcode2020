defmodule DayTen do
  def solve do
    [last | rest] = Common.file_numbers("input/day10.in")
                    |> Enum.sort
                    |> Enum.reverse
    joltages = Enum.reverse([last + 3, last | rest])
    [first: solve_first(joltages), second: solve_second(joltages)]
  end

  def solve_first(joltages) do
    {one, three, _last} = Enum.reduce(joltages, {0, 0, 0}, &sum_differences/2)
    one * three
  end

  def solve_second(joltages) do
    Enum.reduce(joltages, [{0, 1}], &valid_chains/2) |> hd |> elem(1)
  end

  def sum_differences(next, {one, three, prev}) do
    case next - prev do
      1 -> {one + 1, three    , next}
      2 -> {one    , three    , next}
      3 -> {one    , three + 1, next}
      _ -> raise "whoops"
    end
  end

  def valid_chains(next, previouss) do
    reachable = Enum.take_while(previouss, fn {jolt, _} -> jolt >= next - 3 end)
    sum = Enum.reduce(reachable, 0, fn {_, s}, acc -> acc + s end)
    [{next, sum} | reachable]
  end
end

DayTen.solve |> IO.inspect
