defmodule Aoc2021.Day13.Second do
  def run(file) do
    {grid, xmax, ymax, instructions} = input(file)

    instructions
    |> Enum.reduce({grid, xmax, ymax}, fn fold, {grid, xmax, ymax} ->
      fold(grid, xmax, ymax, fold)
    end)
    |> render()
  end

  def render({grid, xmax, ymax}), do: render(grid, xmax, ymax)

  def render(grid, xmax, ymax) do
    Enum.each(0..ymax, fn y ->
      0..xmax
      |> Enum.map(fn x -> Map.get(grid, {x, y}, ?.) end)
      |> Enum.intersperse(?\s)
      |> IO.puts()
    end)
  end

  def fold(grid, _xmax, ymax, {:x, xfold}) do
    grid = do_fold(grid, xfold, 0, fn {x, y} -> {xfold - (x - xfold), y} end)
    {grid, xfold - 1, ymax}
  end

  def fold(grid, xmax, _ymax, {:y, yfold}) do
    grid = do_fold(grid, 0, yfold, fn {x, y} -> {x, yfold - (y - yfold)} end)
    {grid, xmax, yfold - 1}
  end

  defp do_fold(grid, xfold, yfold, transform) do
    Enum.reduce(grid, grid, fn
      {{x, y}, value}, grid when x >= xfold and y >= yfold ->
        grid
        |> Map.delete({x, y})
        |> Map.put(transform.({x, y}), value)

      _, grid ->
        grid
    end)
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
