defmodule Aoc2021.Day8.First do
  def run(file) do
    file
    |> input()
    |> Stream.flat_map(fn [_, output] -> output end)
    |> Enum.count(fn digit -> match?({:ok, _}, unique(digit)) end)
  end

  def unique(scrambled) do
    unique_lenght = %{
      2 => 1,
      4 => 4,
      3 => 7,
      7 => 8
    }

    Map.fetch(unique_lenght, String.length(scrambled))
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "|", trim: true))
    |> Stream.map(fn line ->
      Enum.map(line, &String.split(&1, " ", trim: true))
    end)
  end
end
