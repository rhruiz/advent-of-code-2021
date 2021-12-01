defmodule Aoc2021.Day1 do
  def run(file) do
    file
    |> input()
    |> Enum.map(&String.to_integer/1)
    |> sliding_sum(nil, 0)
  end

  def sliding_sum([first, second, third | tail], nil, increases) do
    sliding_sum([second, third | tail], first + second + third, increases)
  end

  def sliding_sum([first, second, third | tail], last, increases) when first + second + third > last do
    sliding_sum([second, third | tail], first + second + third, increases + 1)
  end

  def sliding_sum([first, second, third | tail], _last, increases) do
    sliding_sum([second, third | tail], first + second + third, increases)
  end

  def sliding_sum(_, _last, increases) do
    increases
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end

"test_input.txt"
|> Aoc2021.Day1.run()
|> IO.inspect()

"input.txt"
|> Aoc2021.Day1.run()
|> IO.inspect()
