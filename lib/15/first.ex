defmodule Aoc2021.Day15.First do
  import Aoc2021.Day15.Second, only: [input: 1, navigate: 2]

  def run(file) do
    {map, target} = input(file)
    navigate(map, target)
  end
end
