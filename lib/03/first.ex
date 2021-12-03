defmodule Aoc2021.Day3.First do
  def run(file) do
    {count, columns} =
      file
      |> input()
      |> Stream.map(fn bin ->
        bin
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.reduce({0, nil}, fn
        item, {0, nil} ->
          {1, item}

        item, {count, sum} ->
          {count + 1,
           sum
           |> Enum.zip(item)
           |> Enum.map(fn {a, b} -> a + b end)}
      end)

    {gamma, epsilon} =
      columns
      |> Enum.map(fn column ->
        if column >= count / 2 do
          {1, 0}
        else
          {0, 1}
        end
      end)
      |> Enum.unzip()

    {from_binary(gamma), from_binary(epsilon)}
  end

  def from_binary(digits) do
    digits
    |> Enum.map(&to_string/1)
    |> Enum.join("")
    |> String.to_integer(2)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end
