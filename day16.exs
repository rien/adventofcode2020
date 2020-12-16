defmodule DaySixteen do
  def solve do
    input = Common.file_lines("input/day16.in") |> parse_input
    [first: solve_first(input), second: solve_second(input)]
  end

  def parse_input(lines) do
    {fields, rest} = Enum.split_while(lines, fn x -> x != "your ticket:" end)
    {mine, others} = Enum.split_while(rest, fn x -> x != "nearby tickets:" end)

    fields = parse_fields(fields)
    mine = parse_tickets(mine) |> hd
    others = parse_tickets(others)
    valid = fields
            |> Enum.map(fn {_field, values} -> values end)
            |> Enum.reduce(&MapSet.union/2)

    [fields: fields, mine: mine, others: others, valid: valid]
  end

  def parse_fields(lines) do
    lines
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(fn line ->
      [field, ranges] = String.split(line, ":")
      ranges = ranges
               |> String.split("or")
               |> Enum.map(&String.trim/1)
               |> Enum.map(fn x ->
                 String.split(x, "-") |> Enum.map(&String.to_integer/1)
               end)
               |> Enum.map(fn [f, t] -> MapSet.new(f..t) end)
               |> Enum.reduce(&MapSet.union/2)
      {field, ranges}
    end)
    |> Map.new
  end

  def parse_tickets([_header | tickets]) do
    tickets
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(fn line ->
      String.split(line, ",") |> Enum.map(&String.to_integer/1)
    end)
  end

  def solve_first([fields: _fields, mine: _, others: others, valid: valid]) do
    others
    |> List.flatten
    |> Enum.filter(fn value -> value not in valid end)
    |> Enum.sum
  end

  def solve_second([fields: fields, mine: mine, others: others, valid: valid]) do
    possible = Map.keys(fields)
               |> Enum.map(fn _key -> Map.keys(fields) |> MapSet.new end)
    others
    |> Enum.filter(fn values ->
      Enum.all?(values, fn v -> MapSet.member?(valid, v) end)
    end)
    |> Enum.reduce(possible, fn ticket, possible ->
      exclude(ticket, possible, fields)
    end)
    |> Enum.zip(mine)
    |> eliminate()
    |> Enum.filter(fn {possible, _mine} ->
      String.starts_with?(possible, "departure")
    end)
    |> Enum.reduce(1, fn {_field, value}, acc -> value * acc end)
  end

  def exclude(ticket, possible, fields) do
    Enum.zip(ticket, possible)
    |> Enum.map(fn {value, candidates} ->
      Enum.filter(candidates, fn candidate ->
        Map.get(fields, candidate) |> MapSet.member?(value)
      end)
    end)
  end

  def eliminate(possible_fields, assigned \\ Map.new) do
    result =
      possible_fields
      |> Enum.reduce(
        {[], assigned},
        fn
          {[singleton], value}, {todo, assigned} ->
            {todo, Map.put(assigned, singleton, value)}
          {options, value}, {todo, assigned} ->
            options = options
                      |> Enum.filter(fn opt ->
                        not Map.has_key?(assigned, opt)
                      end)
            {[{options, value} | todo], assigned}
        end)
    case result do
      {[], assigned} -> assigned
      {todo, assigned} -> eliminate(todo, assigned)
    end
  end
end

DaySixteen.solve |> IO.inspect
