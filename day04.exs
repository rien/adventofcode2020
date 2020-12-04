defmodule DayFour do

  def solve do
    groups = Common.file_lines("data/day04-input")
             |> Enum.reduce([[]], &fix_groups/2)
    [first: solve_first(groups), second: solve_second(groups)]
  end

  def solve_first(groups) do
     Enum.count(groups, &has_all_fields?/1)
  end

  def solve_second(groups) do
    Enum.filter(groups, &has_all_fields?/1) |> Enum.count(&all_fields_correct?/1)
  end

  def fix_groups(line, acc) do
    if line == "" do
      [ [] | acc ]
    else
      [ head | tail ] = acc
      [ Keyword.merge(head, line_to_kwlist(line)) | tail ]
    end
  end

  def line_to_kwlist(line) do
    String.split(line)
    |> Enum.map(fn token ->
        [k, v] = String.split(token, ":")
        { String.to_atom(k), v }
        end)
    |> Keyword.new
  end

  def has_all_fields?(passport) do
    Enum.all?(
      [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid],
      fn key -> Keyword.has_key?(passport, key) end
    )
  end

  def year_between(start, stop) do
    fn input ->
      year = String.to_integer input
      start <= year and year <= stop
    end
  end

  def height(input) do
    if String.length(input) <= 2 do
      false
    else
      {measure, unit} = String.split_at(input, -2)
      measure = String.to_integer measure
      case unit do
        "cm" when 150 <= measure and measure <= 193 -> true
        "in" when 59 <= measure and measure <= 79 -> true
        _ -> false
      end
    end
  end

  def regex(regex) do
    fn input -> String.match?(input, regex) end
  end

  def all_fields_correct?(passport) do
    Enum.all?(
      passport,
      fn {key, val} ->
          case key do
          :byr -> year_between(1920, 2002).(val)
          :iyr -> year_between(2010, 2020).(val)
          :eyr -> year_between(2020, 2030).(val)
          :hgt -> height(val)
          :hcl -> String.match?(val, ~r/^#[0-9a-f]{6}$/)
          :ecl -> String.match?(val, ~r/^(amb|blu|brn|gry|grn|hzl|oth)$/)
          :pid -> String.match?(val, ~r/^[0-9]{9}$/)
          :cid -> true
          end
     end)
  end
end

DayFour.solve |> IO.inspect