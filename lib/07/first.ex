defmodule Aoc2021.Day7.First do
  def run(file) do
    crabs =
      file
      |> input()

    cg = div(Enum.sum(crabs), length(crabs))

    position = minimal(crabs, cg)
    distance(crabs, position)
  end

  def minimal(crabs, candidate) do
    minimal(crabs, candidate, distance(crabs, candidate), %{})
  end

  def minimal(crabs, candidate, best, cache) do
    cache =
      cache
      |> Map.put_new_lazy(candidate - 1, fn -> distance(crabs, candidate - 1) end)
      |> Map.put_new_lazy(candidate + 1, fn -> distance(crabs, candidate + 1) end)

    to_left = Map.get(cache, candidate - 1)
    to_right = Map.get(cache, candidate + 1)

    cond do
      to_left < best ->
        minimal(crabs, candidate - 1, to_left, cache)

      to_right < best ->
        minimal(crabs, candidate + 1, to_right, cache)

      true ->
        candidate
    end
  end

  def distance(crabs, position) do
    Enum.reduce(crabs, 0, fn crab, distance ->
      distance + trunc(abs(position - crab))
    end)
  end

  def input(file) do
    file
    |> File.read!()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
