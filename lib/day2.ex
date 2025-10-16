defmodule Day2 do
  def input_to_lines(path) do
    Enum.slice(File.read!(path)
      |> String.split("\n")
      |> Enum.map(fn line -> 
        line
          |> String.split(" ")
          |> Enum.reduce([], fn num_str, acc -> 
            case Integer.parse(num_str) do
              {num, _} -> [num | acc]
              _ -> acc
            end
        end)
      end),
    0..-2//1)
  end

  def is_safe_duo(x, y), do: abs(x - y) <= 3 and x != y
  def is_safe_trio(x, y, z) do
    is_safe_duo(x, y) and is_safe_duo(y, z) and ((x > y and y > z) or (x < y and y < z))
  end

  def is_safe([]), do: true
  def is_safe([_]), do: true
  def is_safe([x, y]), do: is_safe_duo(x, y)
  def is_safe([x, y, z]), do: is_safe_trio(x, y, z)
  def is_safe([head, neck, torso | tail]) do
    is_safe_trio(head, neck, torso) and is_safe([neck, torso | tail])
  end

  def part1(path) do
    lines = input_to_lines(path)
    Enum.count(lines, &is_safe/1)
  end
end
