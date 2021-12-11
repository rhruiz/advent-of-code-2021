defmodule Aoc2021.Day11.First do
  alias Aoc2021.Day11.Octopus

  @env Mix.env()

  def run(file) do
    1..100
    |> Enum.reduce({Octopus.input(file), 0}, fn step, {map, flashes} ->
      map = Octopus.step(map)
      flashes = flashes + Octopus.flashes(map)

      {map, flashes}
      |> tap(fn {map, _} ->
        if @env == :dev do
          IO.puts("\nAfter step #{step}:")
          Octopus.render(map)
        end
      end)
    end)
    |> elem(1)
  end
end
