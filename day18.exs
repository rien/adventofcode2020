defmodule DayEighteen do
  def solve do
    input = Common.file_lines("input/day18.in") |> Enum.map(&parse_line/1)
    [first: solve_first(input), second: solve_second(input)]
  end

  def parse_line(line) do
    line
    |> String.graphemes
    |> Enum.map(fn
      " " -> nil
      "+" -> {:operand, :sum}
      "*" -> {:operand, :mul}
      "(" -> {:paren, :open}
      ")" -> {:paren, :close}
      num -> {:value, String.to_integer(num)}
    end)
    |> Enum.filter(fn x -> not is_nil(x) end)
  end

  def solve_first(input) do
    input |> Enum.map(fn x -> eval(x, &run1/1) end) |> Enum.sum
  end

  def solve_second(input) do
    input |> Enum.map(fn x -> eval(x, &run2/1) end) |> Enum.sum
  end

  def eval(values       , run, stack \\ [])
  def eval([]           , run, stack), do: run.(stack)
  def eval([next | rest], run, stack) do
    case next do
      {:value, _}   -> eval(rest, run, [next | stack])
      {:operand, _} -> eval(rest, run, [next | stack])
      {:paren, :open} ->
        {result, rest} = eval(rest, run)
        eval(rest, run, [{:value, result} | stack])
      {:paren, :close} -> {run.(stack), rest}
    end
  end

  def run1(stack) do
    case stack do
      [{:value, v}] -> v
      [{:value, v}, {:operand, :mul} | rest] -> v * run1(rest)
      [{:value, v}, {:operand, :sum} | rest] -> v + run1(rest)
    end
  end

  def run2(stack) do
    case stack do
      [{:value, v}] -> v
      [{:value, v}, {:operand, :mul} | rest] -> v * run2(rest)
      [{:value, v1}, {:operand, :sum}, {:value, v2} | rest] ->
        run2([{:value, v1 + v2} | rest])
    end
  end
end

DayEighteen.solve |> IO.inspect
