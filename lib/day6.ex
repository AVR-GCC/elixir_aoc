defmodule Day6 do
  import ElixirAoc

  @directions %{
    :up => :right,
    :right => :down,
    :down => :left,
    :left => :up
  }

  defp input_to_matrix(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.slice(0..-2//1)
    |> Enum.map(&(Enum.slice(String.split(&1, ""), 1..-2//1)))
  end

  defp row_hashtag_indexes_rec([cur | rest], index, res) do
    new_res = if cur == "#" do [index | res] else res end
    row_hashtag_indexes_rec(rest, index + 1, new_res)
  end
  defp row_hashtag_indexes_rec([], _, res), do: res
  def row_hashtag_indexes(row), do: row_hashtag_indexes_rec(row, 0, [])

  def mat_to_index_lookup(mat) do
    mat
      |> Enum.map(&row_hashtag_indexes/1)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {lst, index} -> {index, Enum.reverse(lst)} end)
  end

  defp find_start_position(mat) do
    mat
    |> Enum.with_index()
    |> Enum.reduce(fn {row, y}, acc -> 
      this_row_pin = Enum.with_index(row) |> Enum.reduce(false, fn {value, x}, racc -> 
        if value == "^" do {x, y} else racc end
      end)
      case this_row_pin do
        false -> acc
        _ -> this_row_pin
      end
    end)
  end

  defp walk_to_end(total, indexes, {start_x, start_y}, direction) do
    is_horizontal = direction in [:right, :left]
    is_reversed = direction in [:left, :up]
    {indexes_first_key, indexes_second_key, moving_coordinate, tupelize} = if is_horizontal do 
      {:right, start_y, start_x, fn xs -> Enum.map(xs, &({&1, start_y})) end}
    else 
      {:down, start_x, start_y, fn ys -> Enum.map(ys, &({start_x, &1})) end}
    end
    index_list_raw = get_in(indexes, [indexes_first_key, indexes_second_key])
    {index_list, operator, every, increment, edge} = if is_reversed do 
      {Enum.reverse(index_list_raw), &</2, -1, 1, -1}
    else
      {index_list_raw, &>/2, 1, -1, total}
    end
    test_func = &(operator.(&1, moving_coordinate))
    case Enum.find(index_list, :none, test_func) do
      :none -> {Enum.to_list(moving_coordinate..(edge + increment)//every) |> tupelize.(), :finished}
      stop_idx -> {Enum.to_list(moving_coordinate..(stop_idx + increment)//every) |> tupelize.(), Map.get(@directions, direction, :finished)}
    end
  end

  defp update_map(visited_map, []), do: visited_map
  defp update_map(visited_map, [cur_location | rest]) do
    update_map(Map.put(visited_map, cur_location, true), rest)
  end

  defp walk_to_finish(total, indexes, pos, direction, visited_map) do
    {visited, next_direction} = walk_to_end(total, indexes, pos, direction)
    updated_map = update_map(visited_map, visited)
    next_pos = List.last(visited, pos)
    if next_direction == :finished do
      {updated_map, next_pos}
    else
      walk_to_finish(total, indexes, next_pos, next_direction, updated_map)
    end
  end

  def print_mat(mat, map) do
    mat
    |> Enum.with_index()
    |> Enum.each(fn {row, y} -> 
      row
      |> Enum.with_index()
      |> Enum.each(fn {val, x} -> 
        if Map.get(map, {x, y}, false) do IO.write("X") else IO.write(val) end
      end)
      IO.puts("")
    end)
  end

  def part1(path) do
    right_mat = input_to_matrix(path)
    up_mat = rotate_mat(right_mat)
    left_mat = rotate_mat(up_mat)
    down_mat = Enum.reverse(rotate_mat(left_mat))
    indexes = %{
      :right => mat_to_index_lookup(right_mat),
      :down => mat_to_index_lookup(down_mat)
    }
    start_pos = find_start_position(right_mat)
    {final_map, _} = walk_to_finish(length(right_mat), indexes, start_pos, :up, %{})
    # print_mat(right_mat, final_map)
    Enum.count(final_map)
  end
end
