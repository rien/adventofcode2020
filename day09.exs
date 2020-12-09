defmodule DayNine do

  @window_size 25

  def solve do
    numbers = Common.file_numbers("input/day09.in")
    first = solve_first(numbers)
    [first: first, second: solve_second(numbers, first)]
  end

  def solve_first(numbers) do
    window = Enum.take(numbers, @window_size)
             |> Enum.reduce(:queue.new, &:queue.in/2)
    rest = Enum.drop(numbers, @window_size)
    first_invalid(rest, window)
  end

  def solve_second(numbers, target) do
    find_sum(numbers, :queue.new, 0, target)
  end

  def first_invalid([next | rest], window) do
    history = :queue.to_list(window) |> MapSet.new
    if Enum.any?(history, fn x -> (next - x) in history end) do
      {{:value, _v}, window_} = :queue.out(window)
      window__ = :queue.in(next, window_)
      first_invalid(rest, window__)
    else
      next
    end
  end

  def find_sum(numbers, queue, sum, target) do
    cond do
      sum == target ->
        list = :queue.to_list(queue)
        Enum.max(list) + Enum.min(list)
      sum < target ->
        [next | rest] = numbers
        queue_ = :queue.in(next, queue)
        sum_ = sum + next
        find_sum(rest, queue_, sum_, target)
      sum > target ->
        {{:value, out}, queue_} = :queue.out(queue)
        sum_ = sum - out
        find_sum(numbers, queue_, sum_, target)
    end
  end
end

DayNine.solve |> IO.inspect
