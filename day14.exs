defmodule DayFourteen do
  use Bitwise, only_operators: true

  def solve do
    commands =
      Common.file_lines("input/day14.in")
      |> Enum.map(&parse_program/1)
    [first: solve_first(commands), second: solve_second(commands)]
  end

  def parse_program(line) do
    [instr, value] = String.split(line, " = ")
    if instr == "mask" do
      leave = value
              |> String.replace("1", "0")
              |> String.replace("X", "1")
              |> Integer.parse(2)
              |> elem(0)
      set = value
            |> String.replace("X", "0")
            |> Integer.parse(2)
            |> elem(0)
      {:mask, leave, set}
    else
      addr = String.slice(instr, 4..-2) |> String.to_integer
      value = String.to_integer(value)
      {:mem, addr, value}
    end
  end

  def solve_first(commands) do
    run_and_sum(commands, &eval_v1/2)
  end

  def solve_second(commands) do
    run_and_sum(commands, &eval_v2/2)
  end

  def run_and_sum(commands, eval) do
    {_mask, memory} = Enum.reduce(commands, {nil, Map.new}, eval)
    Map.values(memory) |> Enum.sum
  end

  def eval_v1(instr, {mask, memory}) do
    case instr do
      {:mask, leave, set} -> {{leave, set}, memory}
      {:mem, addr, value} ->
        {leave, set} = mask
        value_ = set ||| (value &&& leave)
        {mask, Map.put(memory, addr, value_)}
    end
  end

  def eval_v2(instr, {mask, memory}) do
    case instr do
      {:mask, float, set} -> {{float, set}, memory}
      {:mem, addr, value} ->
        {floatmask, set} = mask
        base = ~~~floatmask &&& (set ||| addr)
        memory__ =
          floating_values(floatmask)
          |> Enum.reduce(memory,
            fn float, memory_ ->
              addr_ = base ||| float
              Map.put(memory_, addr_, value)
            end)
        {mask, memory__}
    end
  end

  def floating_values(float) do
    Integer.digits(float, 2)
    |> bitcomb()
    |> Enum.map(fn mask -> Integer.undigits(mask, 2) end)
  end

  def bitcomb(float) do
    case float do
      [0] -> [[0]]
      [1] -> [[0], [1]]
      [0 | rest] -> bitcomb(rest)
                    |> Enum.flat_map(fn tail -> [[0 | tail]] end)
      [1 | rest] -> bitcomb(rest)
                    |> Enum.flat_map(fn tail -> [[0 | tail], [1 | tail]] end)
    end
  end
end

DayFourteen.solve |> IO.inspect
