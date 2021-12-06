defmodule Aoc2021.Day6.Second do
  def run(file, days) do
    initial = Enum.into(0..8, %{}, fn day -> {day, 0} end)

    input =
      file
      |> input()
      |> Enum.frequencies()

    initial
    |> Map.merge(input)
    |> simulate(days)
  end

  def simulate(population, days) do
    simulate(population, days, 0)
  end

  def simulate(population, days, days) do
    population |> Map.values() |> Enum.sum()
  end

  def simulate(population, days, day) do
    1..8
    |> Enum.reduce(%{}, fn age, new_population ->
      Map.put(new_population, age - 1, population[age])
    end)
    |> Map.update!(6, fn count -> count + population[0] end)
    |> Map.put(8, population[0])
    |> simulate(days, day + 1)
  end

  def input(file) do
    file
    |> File.read!()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
