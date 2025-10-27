defmodule Day5 do
  def input_to_rules_and_updates(path) do
    File.read!(path)
    |> String.split("\n\n")
  end

  def parse_updates(updates_str) do
    updates_str
    |> String.split("\n")
    |> Enum.slice(0..-2//1)
    |> Enum.map(&(
      String.split(&1, ",")
      |> Enum.map(fn num_str -> 
        {num, _} = Integer.parse(num_str)
        num
      end)
    ))
  end

  def rules_to_tuples(rules_str) do
    rules_str
    |> String.split("\n")
    |> Enum.reduce([], fn pair, acc -> 
      case String.split(pair, "|") do
        [left_string, right_string] -> 
          {left, _} = Integer.parse(left_string)
          {right, _} = Integer.parse(right_string)
          [{left, right} | acc]
        _ -> acc
      end
    end)
  end

  def tuples_to_map(tuples) do
    tuples
    |> Enum.reduce(%{}, fn {left, right}, acc -> 
      Map.update(acc, right, [left], &([left | &1]))
    end)
  end

  def parse_rules(rules_str) do
    rules_str
    |> rules_to_tuples()
    |> tuples_to_map()
  end

  def parse_input(path) do
    pair = input_to_rules_and_updates(path)
    case pair do
      [rules_str, updates_str] -> {parse_rules(rules_str), parse_updates(updates_str)}
      _ -> {"didnt", "work"}
    end
  end

  def update_follows_rules([], _rules, _forbidden), do: true

  def update_follows_rules([page | rest], rules, forbidden) do
    if Enum.member?(forbidden, page) do
      false
    else
      update_follows_rules(rest, rules, Map.get(rules, page, []) ++ forbidden)
    end
  end

  def part1(path) do
    {rules, updates} = parse_input(path)
    updates
    |> Enum.reduce(0, fn update, acc -> 
      if update_follows_rules(update, rules, []) do
        middle_index = round((length(update) - 1) / 2)
        middle_value = Enum.at(update, middle_index)
        acc + middle_value
      else
        acc
      end
    end)
  end
end

