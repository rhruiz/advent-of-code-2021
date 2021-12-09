defmodule Aoc2021.Day9.First do
  @deltas [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def run(file) do
    map = input(file)

    map
    |> Enum.filter(fn {position, height} ->
      map
      |> neighbor_heights(position)
      |> Enum.all?(&(height < &1))
    end)
    |> Enum.reduce(0, fn {_, height}, sum -> 1 + sum + height end)
  end

  def neighbor_heights(map, {x, y}) do
    @deltas
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.flat_map(fn position ->
      case Map.fetch(map, position) do
        {:ok, height} -> [height]
        :error -> []
      end
    end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.map(fn line -> Enum.map(line, &String.to_integer/1) end)
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {xs, y}, map ->
      xs
      |> Enum.with_index()
      |> Enum.reduce(map, fn {height, x}, map ->
        Map.put(map, {x, y}, height)
      end)
    end)
  end
end
