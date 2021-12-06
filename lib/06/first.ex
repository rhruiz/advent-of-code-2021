defmodule Aoc2021.Day6.First do
  def run(file, days) do
    state = input(file)

    1..days
    |> Enum.reduce(state, fn _day, state ->
      Enum.flat_map(state, fn age ->
        run_day(age)
      end)
    end)
  end

  def run_day(0) do
    [6, 8]
  end

  def run_day(number) do
    [number - 1]
  end

  def input(file) do
    file
    |> File.read!()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
