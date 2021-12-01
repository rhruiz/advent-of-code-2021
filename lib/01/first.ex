defmodule Aoc2021.Day1.First do
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
    |> elem(1)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end
