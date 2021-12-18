defmodule Aoc2021.Day18.First do
  def add(a, b) do
    reduce([a, b], List.flatten([a, b], 0, 0)
  end

  def reduce([[a | tail], b], flattened, depth, index) do
    reduce(tail, b, flattened, depth + 1, index + 1)
  end

  def reduce([a, b], flattened, depth, index) do
  end

  def reduce([[[[[[a,b],c],d],e],f] | tail]) do
    [[[0,c+b],d],4]
  end

  def reduce([[a,[b,[c,[d,[e,2]]]]] | tail]) do
    [a,[b,[c,[d+e,0]]]]
  end

  def reduce(number) do
    Enum.map(number, fn
      a when is_integer(a) and a > 10 ->
        [div(a, 2), trunc(:math.ceil(a/2))]
      other ->
        other
    end)
  end
end
