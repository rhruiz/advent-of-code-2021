defmodule Aoc2021.Day13.Second do
  def run(file) do
    {grid, xmax, ymax, instructions} = input(file)

    instructions
    |> Enum.reduce({grid, xmax, ymax}, fn fold, {grid, xmax, ymax} ->
      fold(grid, xmax, ymax, fold)
    end)
    |> then(fn args -> apply(__MODULE__, :render, Tuple.to_list(args)) end)
  end

  def render(grid, xmax, ymax) do
    Enum.each(0..ymax, fn y ->
      0..xmax
      |> Enum.map(fn x -> Map.get(grid, {x, y}, ?.) end)
      |> Enum.intersperse(?\s)
      |> IO.puts()
    end)
  end

  def fold(grid, xmax, ymax, {:x, xfold}) do
    grid = do_fold(grid, (xfold+1)..xmax, 0..ymax, fn x -> xfold - (x - xfold) end, &(&1))
    {grid, xfold - 1, ymax}
  end

  def fold(grid, xmax, ymax, {:y, yfold}) do
    grid = do_fold(grid, 0..xmax, (yfold+1)..ymax, &(&1), fn y -> yfold - (y - yfold) end)
    {grid, xmax, yfold - 1}
  end

  defp do_fold(grid, xrange, yrange, updatex, updatey) do
    Enum.reduce(xrange, grid, fn x, grid ->
      Enum.reduce(yrange, grid, fn y, grid ->
        case Map.fetch(grid, {x, y}) do
          :error ->
            grid

          {:ok, ?#} ->
            grid
            |> Map.delete({x, y})
            |> Map.put({updatex.(x), updatey.(y)}, ?#)
        end
      end)
    end)
  end

  def input(file) do
    [dots, instructions] =
      file
      |> File.read!()
      |> String.split("\n\n")

    {grid, xmax, ymax}  =
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

