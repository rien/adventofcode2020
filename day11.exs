defmodule DayEleven do
  def solve do
    {rows, cols, seats} = Common.file_lines("input/day11.in")
                          |> parse_seats
    [
      first: solve_first(rows, cols, seats),
      second: solve_second(rows, cols, seats)
    ]
  end

  def parse_seats(lines) do
    rows = Enum.count(lines)
    cols = lines |> hd |> String.graphemes |> Enum.count
    seats = lines
            |> Enum.with_index
            |> Enum.flat_map(fn {line, row} ->
              String.graphemes(line)
              |> Enum.with_index
              |> Enum.map(fn
                {"L", col} -> {{row, col}, :empty}
                {".", col} -> {{row, col}, :floor}
                {"#", col} -> {{row, col}, :taken}
              end)
            end)
            |> Map.new
    {rows, cols, seats}
  end

  def solve_first(rows, cols, initial) do
    seats_when_settled(rows, cols, initial, 4, 0, &neighbors/3)
  end

  def solve_second(rows, cols, initial) do
    seats_when_settled(rows, cols, initial, 5, 0, &line_of_sight/3)
  end

  def seats_when_settled(rows, cols, initial, leave, take, view) do
    Stream.unfold(
      {true, initial},
      fn {_, seats} ->
        result = step(rows, cols, seats, leave, take, view)
        {result, result}
      end)
      |> Stream.drop_while(fn {changes, _} -> IO.inspect changes; changes > 0 end)
      |> Stream.take(1)
      |> Enum.to_list
      |> hd
      |> elem(1)
      |> IO.inspect
      |> Map.values
      |> Enum.count(fn seat -> seat == :taken end)
  end

  def step(rows, cols, seats, leave, take, view) do
    (for row <- 0..(rows - 1), col <- 0..(cols - 1), do: {row, col})
    |> Enum.reduce(
      {0, seats},
      fn {row, col}, {changes, next} ->
        seat = Map.get(seats, {row, col})
        surrounding = view.(row, col, seats)
                      |> Enum.count(fn
                        :taken -> true
                        _      -> false
                      end)
        case seat do
          :floor -> {changes, next}
          :taken when surrounding >= leave ->
            {changes + 1, Map.put(next, {row, col}, :empty)}
          :empty when surrounding == take ->
            {changes + 1, Map.put(next, {row, col}, :taken)}
          _ -> {changes, next}
        end
      end)
  end

  def directions do
    [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
  end

  def neighbors(row, col, seats) do
    directions()
    |> Enum.map(fn {dx, dy} -> Map.get(seats, {row + dx, col + dy}, :floor) end)
  end

  def line_of_sight(row, col, seats) do
    directions()
    |> Enum.map(fn {dx, dy} ->  in_direction(row, col, dx, dy, seats) end)
  end

  def in_direction(row, col, dx, dy, seats) do
    case Map.get(seats, {row + dx, col + dy}) do
      nil     -> :floor
      :floor  -> in_direction(row + dx, col + dy, dx, dy, seats)
      value   -> value
    end
  end
end

DayEleven.solve |> IO.inspect
