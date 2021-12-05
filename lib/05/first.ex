defmodule Aoc2021.Day5.First do
  def run(file) do
    map =
      file
      |> input()
      |> horizontal_or_vertical()
      |> Enum.into([])

    {maxx, maxy} = find_max(map)

    {map, {maxx, maxy}}

    points =
      for x <- 0..maxx,
          y <- 0..maxy do
        {x, y}
      end

    points
    |> Enum.map(fn point ->
      Enum.count(map, fn line -> covers?(line, point) end)
    end)
    |> Enum.count(&(&1 > 1))
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  def horizontal_or_vertical(stream) do
    Stream.filter(stream, fn
      %{x1: x, x2: x} -> true
      %{y1: y, y2: y} -> true
      _ -> false
    end)
  end

  def covers?(line, {x, y}) do
    x >= min(line.x1, line.x2) &&
    x <= max(line.x1, line.x2) &&
    y >= min(line.y1, line.y2) &&
    y <= max(line.y1, line.y2) &&
    (line.y1 - line.y2) * x + (line.x2 - line.x1) * y + line.x1 * line.y2 - line.x2 * line.y1 == 0
  end

  def find_max(lines) do
    maxx =
      lines
      |> Enum.max_by(fn %{x1: x1, x2: x2} -> max(x1, x2) end)
      |> then(fn line -> max(line.x1, line.x2) end)

    maxy =
      lines
      |> Enum.max_by(fn %{y1: y1, y2: y2} -> max(y1, y2) end)
      |> then(fn line -> max(line.y1, line.y2) end)

    {maxx, maxy}
  end

  def parse_line(line) do
    line_re = ~r[(?<x1>\d+),(?<y1>\d+) \-\> (?<x2>\d+),(?<y2>\d+)]

    line_re
    |> Regex.named_captures(line)
    |> Enum.into(%{}, fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
  end
end
