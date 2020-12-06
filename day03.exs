defmodule DayThree do
  def solve do
    lines = Common.file_lines "input/day03.in"
    [first: solve_first(lines), second: solve_second(lines)]
  end

  def solve_first(lines) do
    Enum.reduce(lines, {0, 0}, tree_counter(3)) |> elem(0)
  end

  def solve_second(lines) do
    single = Enum.map([1, 3, 5, 7], fn jump ->
              Enum.reduce(lines, {0, 0}, tree_counter(jump)) |> elem(0)
             end)
             |> Enum.reduce(&*/2)
    double = Enum.drop(lines, 1)
             |> Enum.drop_every(2)
             |> Enum.reduce({0, 1}, tree_counter(1))
             |> elem(0)
    single * double
  end


  def tree_counter(jump) do
    fn line, {count, column} ->
      pos = Integer.mod column, String.length(line)
      case String.at(line, pos) do
        "." -> {count,     column + jump}
        "#" -> {count + 1, column + jump}
      end
    end
  end
end

DayThree.solve |> IO.inspect
