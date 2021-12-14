defmodule Aoc2021.Day13.First do
  def run(file) do
    {grid, xmax, ymax, [fold | _instructions]} = input(file)

    grid
    |> fold(xmax, ymax, fold)
    |> elem(0)
    |> map_size()
  end

  def fold(grid, xmax, ymax, {:x, xfold}) do
    grid =
      Enum.reduce(grid, grid, fn
        {{x, y}, ?#}, grid when x > xfold ->
          grid
          |> Map.delete({x, y})
          |> Map.put({xfold - (x - xfold), y}, ?#)

        _, grid ->
          grid
      end)

    {grid, xfold - 1, ymax}
  end

  def fold(grid, xmax, ymax, {:y, yfold}) do
    grid =
      Enum.reduce(grid, grid, fn
        {{x, y}, ?#}, grid when y > yfold ->
          grid
          |> Map.delete({x, y})
          |> Map.put({x, yfold - (y - yfold)}, ?#)

        _, grid ->
          grid
      end)

    {grid, xmax, yfold - 1}
  end

  def input(file) do
    [dots, instructions] =
      file
      |> File.read!()
      |> String.split("\n\n")

    {grid, xmax, ymax} =
      dots
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.trim_trailing()
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> Enum.reduce({%{}, 0, 0}, fn {x, y}, {grid, xmax, ymax} ->
        {Map.put(grid, {x, y}, ?#), max(x, xmax), max(y, ymax)}
      end)

    instructions =
      instructions
      |> String.split("\n")
      |> Enum.map(fn
        <<"fold along x=", x::binary>> -> {:x, x |> String.trim_trailing() |> String.to_integer()}
        <<"fold along y=", y::binary>> -> {:y, y |> String.trim_trailing() |> String.to_integer()}
      end)

    {grid, xmax, ymax, instructions}
  end
end
