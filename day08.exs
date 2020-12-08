defmodule DayEight do

  def solve do
    instrs = Common.file_lines("input/day08.in")
             |> Enum.reduce({0, Map.new}, &parse_instructions/2)
             |> elem(1)
    [first: solve_first(instrs), second: solve_second(instrs)]
  end

  def parse_instructions(line, {i, code}) do
    [op, value] = String.split(line)
    {
      i + 1,
      Map.put(
        code,
        i,
        [op: String.to_atom(op), value: String.to_integer(value)]
      )
    }
  end

  def solve_first(instrs) do
    instrs |> exec_until_loop |> elem(0)
  end

  def solve_second(instrs) do
    instrs
    |> Stream.filter(fn {_, [op: op, value: _]} -> op == :jmp or op == :nop end)
    |> Stream.map(fn {ip, instr} ->
      case instr do
        [op: :jmp, value: val] ->
          Map.put(instrs, ip, [op: :nop, value: val]) |> exec_until_loop
        [op: :nop, value: val] ->
          Map.put(instrs, ip, [op: :jmp, value: val]) |> exec_until_loop
      end
    end)
    |> Enum.find(fn {_, ip} -> ip == nil end)
    |> elem(0)
  end


  def exec_until_loop(instrs, executed \\ MapSet.new, acc \\ 0, ip \\ 0) do
    {acc_, ip_} = instrs[ip] |> eval(acc, ip)
    cond do
      ip_ in executed               -> {acc_, ip_} # we've already executed this instr
      not Map.has_key?(instrs, ip_) -> {acc_, nil} # instruction does not exist: finished
      true -> exec_until_loop(instrs, MapSet.put(executed, ip_), acc_, ip_)
    end
  end

  def eval([op: op, value: value], acc, ip) do
    case op do
      :nop -> {acc        , ip + 1    }
      :jmp -> {acc        , ip + value}
      :acc -> {acc + value, ip + 1    }
    end
  end
end

DayEight.solve |> IO.inspect
