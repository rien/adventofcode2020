require Common

defmodule DayOne do
  @target 2020

  def solve(numbers) do
    sorted = Enum.sort(numbers)
    [ first: solveFirst(sorted), second: solveSecond(sorted) ]
  end

  def solveFirst(numbers) do
    case twoSum numbers, @target do
      { a, b } -> a * b
      nil      -> raise "No result found!"
    end
  end

  def solveSecond(numbers) do
    case threeSum numbers, @target do
      { a, b, c } -> a * b * c
      nil         -> raise "No result found!"
    end
  end

  def twoSum(numbers, target) do
    twoSum numbers, Enum.reverse(numbers), target
  end

  defp twoSum(ascending, descending, target) do
    [ small | ascending_ ] = ascending
    [ large | descending_ ] = descending
    sum = small + large
    cond do
      large < small -> nil
      sum == target -> { small, large }
      sum < target  -> twoSum ascending_, descending, target
      sum > target  -> twoSum ascending, descending_, target
    end
  end

  defp threeSum(numbers, target) do
    [ a | rest ] = numbers
    case twoSum(rest, target - a) do
      { b, c }  -> {a, b, c}
      nil       -> threeSum(rest, target)
    end
  end
end

Common.fileNumbers("data/day01-input1") |> DayOne.solve |> IO.inspect



