defmodule Aoc2021.Day18.First do
  def run(file) do
    file
    |> parse()
    |> Enum.reduce(fn number, sum ->
      sum(sum, number)
    end)
    |> magnitude()
  end

  def parse(file) do
    file
    |> File.stream!()
    |> Enum.map(fn line ->
      {:ok, term} = Code.string_to_quoted(line)
      term
    end)
  end

  def magnitude([a, b]) do
    3 * magnitude(a) + 2 * magnitude(b)
  end

  def magnitude(n), do: n

  def sum(a, b) do
    reduce([a, b])
  end

  def reduce(list) do
    cond do
      list = explode(list, 0) ->
        {_, list, _} = list
        reduce(list)

      list = split(list) ->
        reduce(list)

      true ->
        list
    end
  end

  def split([a, b]) do
    if aa = split(a) do
      [aa, b]
    else
      if bb = split(b) do
        [a, bb]
      else
        false
      end
    end
  end

  def split(n) when n >= 10 do
    [div(n, 2), trunc(:math.ceil(n / 2))]
  end

  def split(_) do
    false
  end

  def explode([a, b], 4) do
    {a, 0, b}
  end

  def explode([a, b], depth) do
    with {aa, n, ab} <- explode(a, depth + 1) do
      {aa, [n, merge(ab, b)], 0}
    else
      _ ->
        with {ba, n, bb} <- explode(b, depth + 1) do
          {0, [merge(a, ba), n], bb}
        end
    end
  end

  def explode(_, _) do
    false
  end

  def merge([a, b], n) do
    [a, merge(b, n)]
  end

  def merge(n, [a, b]) do
    [merge(n, a), b]
  end

  def merge(a, b) do
    a + b
  end
end
