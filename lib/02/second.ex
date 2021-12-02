defmodule Aoc2021.Day2.Second do
  def run(file) do
    file
    |> input()
    |> Enum.reduce({0, 0, 0}, fn
      {:aim, da}, {x, y, aim} ->
        {x, y, aim + da}

      {:forward, dx}, {x, y, aim} ->
        {x + dx, y + aim * dx, aim}
    end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
  end

  def parse_line("forward " <> n), do: {:forward, String.to_integer(n)}
  def parse_line("down " <> n), do: {:aim, String.to_integer(n)}
  def parse_line("up " <> n), do: {:aim, -1 * String.to_integer(n)}
end
