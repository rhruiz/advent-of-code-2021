defmodule Aoc2021.Day14.First do
  def run(file) do
    {base, insertions} = input(file)

    0..9
    |> Enum.reduce(base, fn _step, polymer ->
      step(polymer, insertions)
    end)
    |> Enum.frequencies()
    |> Enum.reduce({nil, 0}, fn {_, count}, {min, max} ->
      {min(min, count), max(max, count)}
    end)
    |> then(fn {a, b} -> b - a end)
  end

  def step(base, insertions) do
    base
    |> Enum.chunk_every(2, 1, :discard)
    |> maybe_insert(insertions, [])
  end

  def maybe_insert([[a, b] = base_pair], insertions, polymer) do
    case Enum.find(insertions, &match?({^base_pair, _c}, &1)) do
      nil -> [b, a | polymer]
      {_base_pair, c} -> [b, c, a | polymer]
    end
    |> Enum.reverse()
  end

  def maybe_insert([[a, _b] = base_pair | tail], insertions, polymer) do
    new_polymer = case Enum.find(insertions, &match?({^base_pair, _c}, &1)) do
      nil -> [a | polymer]
      {_base_pair, c} -> [c, a | polymer]
    end

    maybe_insert(tail, insertions, new_polymer)
  end

  def input(file) do
    [polymer, insertions] =
      file
      |> File.read!()
      |> String.split("\n\n")

    polymer = String.to_charlist(polymer)

    insertions =
      insertions
      |> String.split("\n")
      |> Enum.map(fn line ->
        [a, b, _, ?-, ?>, _, c] = String.to_charlist(line)

        {[a, b], c}
      end)

    {polymer, insertions}
  end
end
