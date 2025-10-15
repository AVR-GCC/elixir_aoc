defmodule Day1 do
  import ElixirAoc

  def part1(path) do
    {left_column, right_column} =
      File.read!(path)
      |> String.split("\n")
      |> Enum.reduce({[], []}, fn line, {left_col, right_col} = acc -> 
        cols = line |> String.split(" ", trim: true)
        case cols do
          [left_string, right_string] -> 
            {left, _} = Integer.parse(left_string)
            {right, _} = Integer.parse(right_string)
            {[left | left_col], [right | right_col]}
          _ -> acc
        end
      end)
    left_sorted = pivot_sort(left_column)
    right_sorted = pivot_sort(right_column)
    Enum.zip_reduce(left_sorted, right_sorted, 0, fn x, y, acc -> abs(x - y) + acc end)
  end
end
