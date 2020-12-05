require Common

defmodule DayFive do
  def solve do
    sorted = Common.file_lines("data/day05-input")
            |> Enum.map(&as_binary/1)
            |> Enum.sort(:desc)

    [last | rest] = sorted
    highest = parse_seat(last)

    [
      first: highest,
      second: find_skip(rest, highest)
    ]
  end

  def find_skip([next | rest], previous) do
    id = parse_seat next
    if id == previous - 1 do
      find_skip rest, id
    else
      id + 1
    end
  end

  def as_binary(line) do
    line
    |> String.replace(["F", "L"], "0")
    |> String.replace(["B", "R"], "1")
  end

  def parse_seat(line) do
    String.to_integer(line, 2)
  end
end

DayFive.solve |> IO.inspect
