defmodule Aoc2021.Day10.First do
  import Aoc2021.Day10.Parser, only: [input: 1, parse: 1]

  @score %{
    ?) => 3,
    ?] => 57,
    ?} => 1197,
    ?> => 25137
  }

  def run(file) do
    file
    |> input()
    |> Enum.reduce(0, fn line, score ->
      case parse(line) do
        {:error, :corrupted, chr} ->
          score + @score[chr]

        _other ->
          score
      end
    end)
  end
end
