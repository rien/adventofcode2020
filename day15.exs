defmodule DayFifteen do
  def solve do
    numbers = Common.file_number_list("input/day15.in")
    [
      first: solve_first(numbers),
      second: solve_second(numbers)
    ]
  end

  def solve_first(numbers) do
    find_number(numbers, 2020)
  end

  def solve_second(numbers) do
    find_number(numbers, 30_000_000)
  end

  def find_number(numbers, index) do
    number_stream(numbers)
    |> Enum.at(index - 1)
  end

  def number_stream(numbers) do
    i = Enum.count(numbers)
    last = List.last(numbers)
    memory = Enum.take(numbers, i - 1)
             |> Enum.with_index(1)
             |> Map.new
    generator =
      Stream.unfold({i, last, memory}, fn
        {i, last, memory} ->
          {next, memory} = Map.get_and_update(memory, last, fn
            nil -> {0    ,   i}
            t   -> {i - t,   i}
          end)
          {next, {i + 1, next, memory}}
      end)
    Stream.concat(numbers, generator)
  end
end

DayFifteen.solve |> IO.inspect
