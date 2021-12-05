defmodule Aoc2021.Day5.Second do
  def run(file) do
    map =
      file
      |> input()
      |> Enum.into([])

    Enum.reduce(map, %{}, fn
      %{x1: x, x2: x, y1: y1, y2: y2}, map ->
        # horizontal
        Enum.reduce(min(y1, y2)..max(y1, y2), map, fn y, map ->
          Map.update(map, {x, y}, 1, &(&1 + 1))
        end)

      %{y1: y, y2: y, x1: x1, x2: x2}, map ->
        # vertical
        Enum.reduce(min(x1, x2)..max(x1, x2), map, fn x, map ->
          Map.update(map, {x, y}, 1, &(&1 + 1))
        end)

      %{x1: x1, x2: x2, y1: y1, y2: y2}, map ->
        ystep = trunc((y2-y1)/abs(y2-y1))

        Enum.reduce(x1..x2, {y1, map}, fn x, {y, map} ->
          {y+ystep, Map.update(map, {x, y}, 1, &(&1 + 1))}
        end)
        |> then(fn {_ystep, map} -> map end)
    end)
    |> Enum.count(fn {_, count} -> count > 1 end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  def parse_line(line) do
    line_re = ~r[(?<x1>\d+),(?<y1>\d+) \-\> (?<x2>\d+),(?<y2>\d+)]

    line_re
    |> Regex.named_captures(line)
    |> Enum.into(%{}, fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
  end
end
