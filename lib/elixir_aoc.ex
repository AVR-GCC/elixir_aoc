defmodule ElixirAoc do
  defp pivot_one_item(acc, _, []), do: acc
  defp pivot_one_item({less, more}, item, [head | tail]) do
    if item < head do
      pivot_one_item({less, [head | more]}, item, tail)
    else
      pivot_one_item({[head | less], more}, item, tail)
    end
  end

  def pivot_sort([]), do: []
  def pivot_sort([head | tail]) do
    {less, more} = pivot_one_item({[], []}, head, tail)
    Enum.concat(pivot_sort(less), [head | pivot_sort(more)])
  end

  def histogramify([head | tail]) do
    map = histogramify(tail)
    Map.update(map, head, 1, fn cur -> cur + 1 end)
  end
  def histogramify([]), do: %{}
end
