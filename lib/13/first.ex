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
      Enum.reduce((xfold + 1)..xmax, grid, fn x, grid ->
        Enum.reduce(0..ymax, grid, fn y, grid ->
          case Map.fetch(grid, {x, y}) do
            :error ->
              grid

            {:ok, ?#} ->
              grid
              |> Map.delete({x, y})
              |> Map.put({xfold - (x - xfold), y}, ?#)
          end
        end)
      end)

    {grid, xfold - 1, ymax}
  end

  def fold(grid, xmax, ymax, {:y, yfold}) do
    grid =
      Enum.reduce((yfold + 1)..ymax, grid, fn y, grid ->
        Enum.reduce(0..xmax, grid, fn x, grid ->
          case Map.fetch(grid, {x, y}) do
            :error ->
              grid

            {:ok, ?#} ->
              grid
              |> Map.delete({x, y})
              |> Map.put({x, yfold - (y - yfold)}, ?#)
          end
        end)
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
