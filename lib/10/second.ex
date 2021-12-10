defmodule Aoc2021.Day10.Second do
  import Aoc2021.Day10.Parser, only: [input: 1, parse: 1]

  @score %{
    ?( => 1,
    ?[ => 2,
    ?{ => 3,
    ?< => 4
  }

  def run(file) do
    file
    |> input()
    |> Enum.flat_map(fn line ->
      case parse(line) do
        {:error, :incomplete, stack} ->
          [complete(stack, 0)]

        _other ->
          []
      end
    end)
    |> then(fn scores ->
      scores
      |> Enum.sort()
      |> Enum.drop(div(length(scores), 2))
      |> hd()
    end)
  end

  def complete([], score), do: score

  def complete([chr | stack], score) do
    complete(stack, score * 5 + @score[chr])
  end
end
