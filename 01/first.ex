defmodule Aoc2021.Day1 do
  def run(file) do
    file
    |> input()
    |> Stream.map(&String.to_integer/1)
    |> Enum.reduce({nil, 0}, fn
      depth, {nil, increases} ->
        {depth, increases}

      depth, {last, increases} when depth > last ->
        {depth, increases + 1}

      depth, {_last, increases} ->
        {depth, increases}
    end)
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
