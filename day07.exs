defmodule DaySeven do
  def solve do
    rules = Common.file_lines("input/day07.in")
            |> Enum.flat_map(&parse_rule/1)
    [first: solve_first(rules), second: solve_second(rules)]
  end

  def parse_rule(line) do
    [container_color, allowed] = String.split(line, " bags contain ", parts: 2)
    if allowed == "no other bags." do
      []
    else
      String.split(allowed, ", ")
      |> Enum.map(fn s ->
        [count, adjective, color | _rest ] = String.split(s)
        [
          parent: container_color,
          child: adjective <> " " <> color,
          count: String.to_integer(count)
        ]
      end)
    end
  end

  def solve_first(rules) do
    rules
    |> Enum.reduce(Map.new, &add_rule(&1, &2, :child, :parent))
    |> find_all_parents("shiny gold")
    |> Enum.count
  end

  def solve_second(rules) do
    rules
    |> Enum.reduce(Map.new, &add_rule(&1, &2, :parent, :child))
    |> children_count("shiny gold")
  end

  def add_rule(rule, map, outer_key, inner_key) do
    Map.get_and_update(
      map,
      rule[outer_key],
      fn value ->
        case value do
          nil -> {value, %{rule[inner_key] => rule[:count]}}
          map -> {value, Map.put(map, rule[inner_key], rule[:count])}
        end
      end)
      |> elem(1)
  end

  def find_all_parents(rules, target, acc \\ MapSet.new) do
    case rules[target] do
      nil     -> acc
      result ->
        parents = result |> Map.keys |> MapSet.new
        acc_    = MapSet.union(acc, parents)
        Enum.reduce(parents, acc_, &find_all_parents(rules, &1, &2))
      end
  end

  def children_count(rules, target) do
    case rules[target] do
      nil    -> 0
      result ->
        Enum.map(result, fn {child, count} ->
          count + count * children_count(rules, child)
        end)
        |> Enum.sum
    end
  end
end

DaySeven.solve |> IO.inspect
