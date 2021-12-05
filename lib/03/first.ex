defmodule Aoc2021.Day3.First do
  use Bitwise, only_operators: true

  def run(file) do
    {count, readings} =
      file
      |> input()
      |> Stream.map(fn bin ->
        bin
        |> String.to_charlist()
        |> List.to_tuple()
      end)
      |> Enum.reduce({0, nil}, fn
        bin, {0, nil} ->
          {1, [bin]}

        bin, {count, list} ->
          {count + 1, [bin | list]}
      end)

    half = div(count, 2)

    bitsize =
      readings
      |> hd()
      |> tuple_size()

    gamma =
      0..(bitsize - 1)
      |> Enum.map(fn column ->
        if Enum.count_until(readings, &(elem(&1, column) == ?1), half + 1) > half do
          1
        else
          0
        end
      end)
      |> Integer.undigits(2)

    episilon = ~~~gamma &&& 2 ** bitsize - 1

    {gamma, episilon}
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end
