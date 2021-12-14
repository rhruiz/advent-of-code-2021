defmodule Aoc2021.Day14.Polymer do
  def run(file, steps) do
    {base, insertions} = input(file)

    pair_count =
      base
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()

    1..steps
    |> Enum.reduce(pair_count, fn _step, pair_count ->
      step(pair_count, insertions)
    end)
    |> Enum.reduce(%{}, fn {[a, b], count}, frequencies ->
      frequencies
      |> Map.update(a, count, &(&1 + count))
      |> Map.update(b, count, &(&1 + count))
    end)
    |> Enum.reduce({nil, 0}, fn {_, count}, {min, max} ->
      {min(min, round(count / 2)), max(max, round(count / 2))}
    end)
    |> then(fn {min, max} -> max - min end)
  end

  def step(pair_count, insertions) do
    Enum.reduce(pair_count, %{}, fn {[a, b] = pair, existing}, pair_count ->
      case Map.fetch(insertions, pair) do
        {:ok, c} ->
          pair_count
          |> Map.update([a, c], existing, &(&1 + existing))
          |> Map.update([c, b], existing, &(&1 + existing))

        :error ->
          Map.put(pair_count, pair, existing)
      end
    end)
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
      |> Enum.into(%{}, fn line ->
        [a, b, _, ?-, ?>, _, c] = String.to_charlist(line)

        {[a, b], c}
      end)

    {polymer, insertions}
  end
end
