defmodule ElixirAoc do
  defp pivot_one_item(_, acc, _, []), do: acc
  defp pivot_one_item(fun, {less, more}, item, [head | tail]) do
    if fun.(item, head) do
      pivot_one_item(fun, {less, [head | more]}, item, tail)
    else
      pivot_one_item(fun, {[head | less], more}, item, tail)
    end
  end

  def pivot_sort(_, []), do: []
  def pivot_sort(fun, [head | tail]) do
    {less, more} = pivot_one_item(fun, {[], []}, head, tail)
    Enum.concat(pivot_sort(fun, less), [head | pivot_sort(fun, more)])
  end

  def pivot_sort([]), do: []
  def pivot_sort([head | tail]) do
    {less, more} = pivot_one_item(&</2, {[], []}, head, tail)
    Enum.concat(pivot_sort(less), [head | pivot_sort(more)])
  end

  def histogramify([head | tail]) do
    map = histogramify(tail)
    Map.update(map, head, 1, fn cur -> cur + 1 end)
  end
  def histogramify([]), do: %{}

  defp rotate_mat_rec(row, _cols, [[] | _rest]), do: row
  defp rotate_mat_rec(row, cols, []) do
      [row | rotate_mat_rec([], [], Enum.reverse(cols))]
  end
  defp rotate_mat_rec(row, cols, [[head | tail] | rest]) do
      rotate_mat_rec([head | row], [tail | cols], rest)
  end
  def rotate_mat(mat), do: rotate_mat_rec([], [], mat)
end
