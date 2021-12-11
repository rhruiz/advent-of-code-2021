defmodule Aoc2021.Day11.Second do
  alias Aoc2021.Day11.Octopus

  @env Mix.env()

  def run(file) do
    map = Octopus.input(file)

    Stream.iterate(1, &(&1 + 1))
    |> Stream.transform(map, fn step, map ->
      map = Octopus.step(map)

      if @env == :dev do
        IO.puts("\nAfter step #{step}:")
        Octopus.render(map)
      end

      if(Octopus.flashes(map) == 100, do: {[step], map}, else: {[], map})
    end)
    |> Enum.take(1)
    |> hd()
  end
end
