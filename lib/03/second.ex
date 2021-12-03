defmodule Aoc2021.Day3.Second do
  use Bitwise, only_operators: true

  def run(file) do
    readings =
      file
      |> input()
      |> Enum.map(fn bin ->
        bin
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    oxygen = find_reading(readings, &Kernel.==/2)
    co2 = find_reading(readings, &Kernel.!=/2)

    {from_binary(oxygen), from_binary(co2)}
  end

  def most_common(readings, position) do
    {count, sum} =
      Enum.reduce(readings, {0, 0}, fn line, {count, sum} ->
        {count + 1, sum + Enum.at(line, position)}
      end)

    if(sum >= count / 2, do: 1, else: 0)
  end

  def find_reading(readings, comparison), do: find_reading(readings, comparison, 0)

  def find_reading([reading | []], _, _), do: reading

  def find_reading(readings, comparison, position) do
    most_common = most_common(readings, position)

    readings
    |> Enum.filter(fn reading ->
      comparison.(Enum.at(reading, position) &&& 1, most_common)
    end)
    |> find_reading(comparison, position + 1)
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
