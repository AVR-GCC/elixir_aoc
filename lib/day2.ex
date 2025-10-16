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

  def is_safe(_, []), do: true
  def is_safe(_, [_]), do: true
  def is_safe(direction, [head, neck | tail]) do
    if !(case direction do
      :reducing -> head > neck
      :increasing -> neck > head  
    end) do false
    else
      if (abs(head - neck) > 3) do false
      else
        is_safe(direction, [neck | tail])
      end
    end
  end
  def is_safe([]), do: true
  def is_safe([_]), do: true
  def is_safe([x, y]), do: abs(x - y) <= 3 and x != y
  def is_safe([head, neck | _] = lst) do
    if head == neck do false
    else
      direction = if head > neck do :reducing else :increasing end
      is_safe(direction, lst)
    end
  end

  def part1(path) do
    lines = input_to_lines(path)
    Enum.count(lines, &is_safe/1)
  end
end
