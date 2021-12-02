defmodule Aoc2021.Day2.First do
  def run(file) do
    file
    |> input()
    |> Enum.reduce({0, 0}, fn {dx, dy}, {x, y} ->
      {x + dx, y + dy}
    end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
  end

  def parse_line("forward " <> n), do: {String.to_integer(n), 0}
  def parse_line("down " <> n), do: {0, String.to_integer(n)}
  def parse_line("up " <> n), do: {0, -1 * String.to_integer(n)}
end
