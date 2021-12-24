defmodule Aoc2021.Day22.Second do
  def volume({_op, ranges}) do
    volume(ranges)
  end

  def volume([x, y, z]) do
    Range.size(x) * Range.size(y) * Range.size(z)
  end

  def run(file) do
    file
    |> input()
    |> Enum.reduce([], fn
      {:on, cube}, cubes ->
        cubes = Enum.flat_map(cubes, &subtract(&1, cube))
        [cube | cubes]

      {:off, cube}, cubes ->
        Enum.flat_map(cubes, &subtract(&1, cube))
    end)
    |> Enum.reduce(0, &(&2 + volume(&1)))
  end

  def subtract(a, b) do
    if !disjoint?(a, b) do
      do_subtract(a, b)
    else
      [a]
    end
  end

  def do_subtract([], []), do: []

  def do_subtract([afirst..alast | atail], [bfirst..blast | btail]) do
    leading = afirst..(bfirst - 1)//1
    trailing = (blast+1)..alast//1

    maybe_add = fn list, range ->
      if Enum.empty?(range) do
        list
      else
        list ++ [[range | atail]]
      end
    end

    do_subtract(atail, btail)
    |> Enum.map(fn cuboid -> [max(afirst, bfirst)..min(alast, blast) | cuboid] end)
    |> maybe_add.(leading)
    |> maybe_add.(trailing)
  end

  def disjoint?(a, b) do
    a
    |> Enum.zip(b)
    |> Enum.any?(fn {a, b} -> Range.disjoint?(a, b) end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(fn line ->
      [command, "x", x, "y", y, "z", z] = String.split(line, [" ", "=", ",", "\n"], trim: true)

      command = String.to_atom(command)

      ranges =
        [x, y, z]
        |> Enum.map(fn axis ->
          {range, []} = Code.eval_string(axis)
          range
        end)

      {command, ranges}
    end)
  end
end
