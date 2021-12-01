defmodule Aoc2021.Day1.Second do
  def run(file) do
    file
    |> input()
    |> Enum.into([])
    |> sliding_sum(nil, 0)
  end

  def as_streams(file) do
    0..2
    |> Stream.map(fn offset ->
      file
      |> input()
      |> Stream.drop(offset)
    end)
    |> Stream.zip()
    |> Stream.map(fn {a, b, c} -> a + b + c end)
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

  def sliding_sum([first, second, third | tail], nil, increases) do
    sliding_sum([second, third | tail], first + second + third, increases)
  end

  def sliding_sum([first, second, third | tail], last, increases)
      when first + second + third > last do
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
    |> Stream.map(&String.to_integer/1)
  end
end
