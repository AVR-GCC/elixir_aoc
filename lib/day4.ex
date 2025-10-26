defmodule Day4 do
  def input_to_matrix(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, "") |> Enum.slice(1..-2//1)))
    |> Enum.slice(0..-2//1)
  end

  def match_str(mat, {x, y}, str) do
    height = length(mat)
    width = length(Enum.at(mat, 0, []))
    str_len = length(str)
    down_clear = height >= str_len + y
    right_clear = width >= str_len + x
    up_clear = y + 1 >= str_len
    left_clear = x + 1 >= str_len

    down =
      if down_clear do
        match_str_rec(mat, {x, y}, str, &(&1), &(&1 + 1))
      else
        0
      end

    right =
      if right_clear do
        match_str_rec(mat, {x, y}, str, &(&1 + 1), &(&1))
      else
        0
      end

    up =
      if up_clear do
        match_str_rec(mat, {x, y}, str, &(&1), &(&1 - 1))
      else
        0
      end

    left =
      if left_clear do
        match_str_rec(mat, {x, y}, str, &(&1 - 1), &(&1))
      else
        0
      end

    down_right =
      if down_clear and right_clear do
        match_str_rec(mat, {x, y}, str, &(&1 + 1), &(&1 + 1))
      else
        0
      end

    up_right =
      if up_clear and right_clear do
        match_str_rec(mat, {x, y}, str, &(&1 + 1), &(&1 - 1))
      else
        0
      end

    up_left =
      if up_clear and left_clear do
        match_str_rec(mat, {x, y}, str, &(&1 - 1), &(&1 - 1))
      else
        0
      end

    down_left =
      if down_clear and left_clear do
        match_str_rec(mat, {x, y}, str, &(&1 - 1), &(&1 + 1))
      else
        0
      end
    res = down + right + up + left + down_right + up_right + up_left + down_left
    res
  end

  def match_str_rec(_, _, [], _, _), do: 1

  def match_str_rec(mat, {x, y}, [letter | rest], increment_x, increment_y) do
    cur_letter = Enum.at(Enum.at(mat, y, []), x, "")
    if cur_letter === letter do
      match_str_rec(mat, {increment_x.(x), increment_y.(y)}, rest, increment_x, increment_y)
    else
      0
    end
  end

  def part1(path) do
    mat = input_to_matrix(path)
    mat
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, y}, acc1 ->
      row_sum = row
      |> Enum.with_index()
      |> Enum.reduce(0, fn {_, x}, acc2 -> match_str(mat, {x, y}, ["X", "M", "A", "S"]) + acc2 end)
      row_sum + acc1
    end)
  end
end
