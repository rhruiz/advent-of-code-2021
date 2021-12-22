defmodule Aoc2021.Day22.First do
  def run(file) do
    file
    |> input()
    |> Enum.reduce(MapSet.new(), fn {command, [x, y, z]}, cubes ->
      fun = if(command == :on, do: :put, else: :delete)

      for x <- x, y <- y, z <- z, reduce: cubes do
        cubes -> apply(MapSet, fun, [cubes, {x, y, z}])
      end
    end)
    |> MapSet.size()
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.flat_map(fn line ->
      [command, "x", x, "y", y, "z", z] = String.split(line, [" ", "=", ",", "\n"], trim: true)

      min = -50
      max = 50
      accepted = min..max
      command = String.to_atom(command)

      ranges =
        [x, y, z]
        |> Enum.map(fn axis ->
          {range, []} = Code.eval_string(axis)
          range
        end)

      if Enum.any?(ranges, &Range.disjoint?(&1, accepted)) do
        []
      else
        [
          {command,
           Enum.map(ranges, fn range ->
             max(min, range.first)..min(max, range.last)
           end)}
        ]
      end
    end)
  end
end
