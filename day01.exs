require Common

defmodule DayOne do
  @target 2020

  def solve(numbers) do
    sorted = Enum.sort(numbers)
    [ first: solve_first(sorted), second: solve_second(sorted) ]
  end

  def solve_first(numbers) do
    case two_sum numbers, @target do
      { a, b } -> a * b
      nil      -> raise "No result found!"
    end
  end

  def solve_second(numbers) do
    case three_sum numbers, @target do
      { a, b, c } -> a * b * c
      nil         -> raise "No result found!"
    end
  end

  def two_sum(numbers, target) do
    two_sum numbers, Enum.reverse(numbers), target
  end

  defp twoSum(ascending, descending, target) do
    [ small | ascending_ ] = ascending
    [ large | descending_ ] = descending
    sum = small + large
    cond do
      large < small -> nil
      sum == target -> { small, large }
      sum < target  -> two_sum ascending_, descending, target
      sum > target  -> two_sum ascending, descending_, target
    end
  end

  defp threeSum(numbers, target) do
    [ a | rest ] = numbers
    case two_sum(rest, target - a) do
      { b, c }  -> {a, b, c}
      nil       -> three_sum(rest, target)
    end
  end
end

Common.file_numbers("data/day01-input") |> DayOne.solve |> IO.inspect



