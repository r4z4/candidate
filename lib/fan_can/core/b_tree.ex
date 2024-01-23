defmodule FanCan.BTree do
  defstruct tree: nil

  alias FanCan.BTree
  
  def new(e), do: %BTree{tree: {e, nil, nil}}

  def insert(%BTree{tree: root}, element) do
    %BTree{tree: do_insert(root, element)}
  end

  defp do_insert(nil, element) do
    {element, nil, nil}
  end

  defp do_insert({e, l, r}, element) when e > element do
    {e, do_insert(l, element), r}
  end

  defp do_insert({e, l, r}, element) when e < element do
    {e, l, do_insert(r, element)}
  end

  defp do_insert({_, _, _} = tuple, _element) do
    tuple
  end

  def search(%BTree{tree: root}, element) do
    do_search(root, element)
  end

  defp do_search(nil, element) do
    false
  end

  defp do_search({e, l, _r}, element) when e > element do
    do_search(l, element)
  end

  defp do_search({e, _l, r}, element) when e < element do
    do_search(r, element)
  end

  defp do_search({_, _, _}, _element) do
    true
  end

end 