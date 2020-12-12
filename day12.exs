defmodule DayTwelve do
  def solve do
    commands = Common.file_lines("input/day12.in")
               |> Enum.map(&parse_command/1)
    [first: solve_first(commands), second: solve_second(commands)]
  end

  def parse_command(line) do
    {cmd, distance} = line |> String.split_at(1)
    {String.to_atom(cmd), String.to_integer(distance)}
  end


  def solve_first(commands) do
    {{x, y}, _hdn} = Enum.reduce(commands, {{0, 0}, {1, 0}}, &navigate_ship/2)
    abs(x) + abs(y)
  end

  def solve_second(commands) do
    {{x, y}, _wp} = Enum.reduce(commands, {{0, 0}, {10, 1}}, &navigate_waypoint/2)
    abs(x) + abs(y)
  end

  def rotate(rotation, {wx, wy}) do
    case Integer.mod(rotation, 360) do
      0   -> {wx, wy}
      90  -> {wy, -wx}
      180 -> {-wx, -wy}
      270 -> {-wy, wx}
    end
  end

  def navigate_waypoint(next, {{sx, sy}, {wx, wy}}) do
    case next do
      {:L, deg}  -> {{sx, sy}, rotate(-deg, {wx, wy})}
      {:R, deg}  -> {{sx, sy}, rotate(deg, {wx, wy})}
      {:E, dist} -> {{sx, sy}, {wx + dist, wy       }}
      {:N, dist} -> {{sx, sy}, {wx       , wy + dist}}
      {:W, dist} -> {{sx, sy}, {wx - dist, wy       }}
      {:S, dist} -> {{sx, sy}, {wx       , wy - dist}}
      {:F, dist} -> {{sx + dist * wx, sy + dist * wy}, {wx, wy}}
    end
  end

  def navigate_ship(next, {{sx, sy}, {dx, dy}}) do
    case next do
      {:L, deg}  -> {{sx       , sy}       , rotate(-deg, {dx, dy})}
      {:R, deg}  -> {{sx       , sy}       , rotate(deg, {dx, dy})}
      {:E, dist} -> {{sx + dist, sy}       , {dx, dy}}
      {:N, dist} -> {{sx       , sy + dist}, {dx, dy}}
      {:W, dist} -> {{sx - dist, sy}       , {dx, dy}}
      {:S, dist} -> {{sx       , sy - dist}, {dx, dy}}
      {:F, dist} -> {{sx + dist * dx, sy + dist * dy}, {dx, dy}}
    end
  end
end

DayTwelve.solve |> IO.inspect
