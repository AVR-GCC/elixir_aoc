defmodule Day1 do
  import ElixirAoc

  def input_to_columns(path) do
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
  end

  def part1(path) do
    {left_column, right_column} = input_to_columns(path)
    left_sorted = pivot_sort(left_column)
    right_sorted = pivot_sort(right_column)
    Enum.zip_reduce(left_sorted, right_sorted, 0, fn x, y, acc -> abs(x - y) + acc end)
  end

  def part2(path) do
    {left_column, right_column} = input_to_columns(path)
    left_hist = histogramify(left_column)
    right_hist = histogramify(right_column)
    Enum.reduce(left_hist, 0, fn {number, count}, acc -> acc + number * count * Map.get(right_hist, number, 0) end)
  end
end
