defmodule DaySeventeen do

  def solve do
    active = Common.file_lines("input/day17.in")
              |> parse_input
              |> Enum.filter(fn x -> not is_nil(x) end)
              |> MapSet.new
    [first: solve_first(active), second: solve_second(active)]
  end

  def solve_first(coords) do
    Stream.unfold(coords, fn state -> {state, step(state, &neighbors3d/1)} end)
    |> Enum.at(6)
    |> Enum.count
  end

  def solve_second(coords) do
    Stream.unfold(coords, fn state -> {state, step(state, &neighbors4d/1)} end)
    |> Enum.at(6)
    |> Enum.count
  end

  def parse_input(lines) do
    lines
    |> Enum.with_index
    |> Enum.flat_map(fn {line, x} ->
      line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.map(fn
        {"#", y} -> {x, y, 0, 0}
        {".", _} -> nil
      end)
    end)
  end

  def step(activated, convolute) do
    count_neighbors(activated, convolute)
    |> Enum.reduce(MapSet.new, fn {coord, active_neighbors}, next_activated ->
      cond do
        MapSet.member?(activated, coord) and active_neighbors in 2..3 ->
          MapSet.put(next_activated, coord)
        active_neighbors == 3 ->
          MapSet.put(next_activated, coord)
        true -> next_activated
      end
    end)
  end

  def neighbors3d({x, y, z, w}) do
    (for dx <- -1..1,
      dy <- -1..1,
      dz <- -1..1,
      {dx, dy, dz} != {0, 0, 0},
      do: {dx, dy, dz})
    |> Enum.map(fn {dx, dy, dz} -> {x + dx, y + dy, z + dz, w} end)
  end

  def neighbors4d({x, y, z, w}) do
    (for dx <- -1..1,
      dy <- -1..1,
      dz <- -1..1,
      dw <- -1..1,
      {dx, dy, dz, dw} != {0, 0, 0, 0},
      do: {dx, dy, dz, dw})
    |> Enum.map(fn {dx, dy, dz, dw} -> {x + dx, y + dy, z + dz, w + dw} end)
  end

  def count_neighbors(active, convolute) do
    active
    |> Enum.reduce(Map.new, fn coord, acc ->
      convolute.(coord)
      |> Enum.reduce(acc, fn neighbor, acc_ ->
        Map.update(acc_, neighbor, 1, fn x -> x + 1 end)
      end)
    end)
  end
end

DaySeventeen.solve |> IO.inspect
