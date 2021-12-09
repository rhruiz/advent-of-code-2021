defmodule Aoc2021.Day8.Second do
  @unique_length %{
    2 => 1,
    4 => 4,
    3 => 7,
    7 => 8
  }

  # segment map
  #  0
  # 1 2
  #  3
  # 4 5
  #  6
  @segments_to_number %{
    MapSet.new([0, 1, 2, 4, 5, 6]) => 0,
    MapSet.new([2, 5]) => 1,
    MapSet.new([0, 2, 3, 4, 6]) => 2,
    MapSet.new([0, 2, 3, 5, 6]) => 3,
    MapSet.new([1, 2, 3, 5]) => 4,
    MapSet.new([0, 1, 3, 5, 6]) => 5,
    MapSet.new([0, 1, 3, 4, 5, 6]) => 6,
    MapSet.new([0, 2, 5]) => 7,
    MapSet.new([0, 1, 2, 3, 4, 5, 6]) => 8,
    MapSet.new([0, 1, 2, 3, 5, 6]) => 9
  }

  def run(file) do
    file
    |> input()
    |> Enum.map(&solve/1)
  end

  def solve([readings, output]) do
    known =
      readings
      |> decode()
      |> Enum.into(%{}, fn {k, v} -> {v, k} end)

    output
    |> Enum.map(fn digits ->
      digits
      |> Enum.map(&Map.get(known, &1))
      |> MapSet.new()
      |> then(&Map.get(@segments_to_number, &1))
    end)
    |> Integer.undigits()
  end

  def decode(readings) do
    known = %{}

    unique_numbers =
      Enum.into(@unique_length, %{}, fn {length, number} ->
        {number, Enum.find(readings, &(length(&1) == length))}
      end)

    known = Map.put(known, 0, hd(unique_numbers[7] -- unique_numbers[1]))

    number_6 =
      readings
      |> Enum.filter(&(length(&1) == 6))
      |> Enum.find(fn number -> length(number -- unique_numbers[7]) == 4 end)

    known = Map.put(known, 2, hd(unique_numbers[8] -- number_6))
    known = Map.put(known, 5, hd(unique_numbers[1] -- [known[2]]))

    number_3 =
      readings
      |> Enum.filter(&(length(&1) == 5))
      |> Enum.find(fn x -> Enum.member?(x, known[2]) && Enum.member?(x, known[5]) end)

    number_5 =
      readings
      |> Enum.filter(&(length(&1) == 5))
      |> Enum.find(fn x -> !Enum.member?(x, known[2]) && Enum.member?(x, known[5]) end)

    number_2 =
      readings
      |> Enum.filter(&(length(&1) == 5))
      |> Enum.find(fn x -> Enum.member?(x, known[2]) && !Enum.member?(x, known[5]) end)

    known = Map.put(known, 4, hd(number_2 -- number_3))
    known = Map.put(known, 1, hd(number_5 -- number_3))
    known = Map.put(known, 6, hd((number_5 -- unique_numbers[4]) -- [known[0]]))
    Map.put(known, 3, hd((unique_numbers[4] -- unique_numbers[1]) -- [known[1]]))
  end

  def input(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, " | ", trim: true))
    |> Enum.map(fn line ->
      Enum.map(line, fn digits ->
        digits
        |> String.split(" ", trim: true)
        |> Enum.map(&String.split(&1, "", trim: true))
      end)
    end)
  end
end
