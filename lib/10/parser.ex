defmodule Aoc2021.Day10.Parser do
  @closing_for %{
    ?( => ?),
    ?< => ?>,
    ?[ => ?],
    ?{ => ?}
  }

  def parse(line) do
    parse(line, [])
  end

  def parse([], [_head | _] = stack) do
    {:error, :incomplete, stack}
  end

  def parse([chr | tail], [chr | stack]) do
    parse(tail, stack)
  end

  def parse([chr | tail], stack) when is_map_key(@closing_for, chr) do
    parse(tail, [@closing_for[chr] | stack])
  end

  def parse([chr | _tail], _) do
    {:error, :corrupted, chr}
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(fn line ->
      line
      |> String.trim_trailing()
      |> String.to_charlist()
    end)
  end
end
