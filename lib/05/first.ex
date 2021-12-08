defmodule Aoc2021.Day5.First do
  def run(file) do
    map =
      file
      |> input()

    Enum.reduce(map, %{}, fn
      {x, y1, x, y2}, map ->
        # horizontal
        Enum.reduce(y1..y2, map, fn y, map ->
          Map.update(map, {x, y}, 1, &(&1 + 1))
        end)

      {x1, y, x2, y}, map ->
        # vertical
        Enum.reduce(x1..x2, map, fn x, map ->
          Map.update(map, {x, y}, 1, &(&1 + 1))
        end)

      _, map ->
        map
    end)
    |> Enum.count(fn {_, count} -> count > 1 end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split([",", " -> ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x1, y1, x2, y2] ->
      {x1, y1, x2, y2}
    end)
  end
end
