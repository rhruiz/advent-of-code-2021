defmodule Aoc2021.Day18.Second do
  import Aoc2021.Day18.First, only: [parse: 1, magnitude: 1, sum: 2]

  def run(input) do
    numbers = parse(input)

    Enum.reduce(numbers, 0, fn a, max ->
      Enum.reduce(numbers, max, fn
        ^a, max ->
          max

        b, max ->
          Enum.max([max, magnitude(sum(a, b)), magnitude(sum(b, a))])
      end)
    end)
  end
end
