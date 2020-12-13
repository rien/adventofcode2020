defmodule DayThirteen do
  def solve do
    [now, line] = Common.file_lines("input/day13.in")
    now = String.to_integer(now)
    busses = parse_busses(line)
    [first: solve_first(now, busses), second: solve_second(busses)]
  end

  def parse_busses(line) do
    line
    |> String.split(",")
    |> Enum.with_index
    |> Enum.filter(fn {l, _i} -> l != "x" end)
    |> Enum.map(fn {l, i} -> {-i, String.to_integer(l)} end)
  end

  def waiting_times(busses, now) do
    Map.new(busses, fn {_i, bus} -> {bus, bus - Integer.mod(now, bus)} end)
  end

  def solve_first(now, busses) do
    {bus, wait} =
      busses
      |> waiting_times(now)
      |> Enum.min_by(fn {_bus, wait} -> wait end)
    bus * wait
  end

  def solve_second(busses) do
    prod = busses |> Enum.reduce(1, fn {_, a}, b -> a * b end)
    result = busses
             |> Enum.map(
               fn {i, bus} ->
                 i * e(bus, prod)
               end)
             |> Enum.sum
    Integer.mod(result, prod)
  end

  def e(n, prodn) do
    ni = div(prodn, n)
    {g, r, _s} = gcd(ni, n)
    if g == 1 do
      r * ni
    else
      raise "Not coprime!"
    end
  end

  def gcd(rp, r, sp \\ 1, s \\ 0, tp \\ 0, t \\ 1) do
    if r == 0 do
      {rp, sp, tp}
    else
      quot = div(rp, r)
      gcd(r, rp - quot * r, s, sp - quot * s, t, tp - quot * t)
    end
  end
end

DayThirteen.solve |> IO.inspect
