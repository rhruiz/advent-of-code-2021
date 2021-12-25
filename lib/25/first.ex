defmodule Aoc2021.Day25.First do
  def run(file) do
    grid = input(file)

    Stream.iterate(1, &(&1 + 1))
    |> Stream.transform(grid, fn step, last_grid ->
      grid = step(last_grid)

      if grid == last_grid do
        {:halt, grid}
      else
        {[step + 1], grid}
      end
    end)
    |> Enum.take(-1)
    |> hd()
  end

  def render(grid) do
    grid
    |> Map.keys()
    |> Enum.sort_by(fn {x, y} -> {y, x} end)
    |> Enum.reduce(0, fn {x, y}, last_y ->
      if y != last_y do
        IO.puts("")
      end

      IO.write([Map.get(grid, {x, y})])

      y
    end)

    IO.puts("\n")
  end

  def step(grid) do
    grid
    |> Enum.reduce(%{}, fn
      {{x, y}, ?>}, new_grid ->
        cond do
          grid[{x + 1, y}] == nil and grid[{0, y}] == ?. ->
            Map.merge(new_grid, %{
              {x, y} => ?.,
              {0, y} => ?>
            })

          grid[{x + 1, y}] == ?. ->
            Map.merge(new_grid, %{
              {x, y} => ?.,
              {x + 1, y} => ?>
            })

          true ->
            Map.put_new(new_grid, {x, y}, ?>)
        end

      {{x, y}, chr}, new_grid ->
        Map.put_new(new_grid, {x, y}, chr)
    end)
    |> then(fn grid ->
      Enum.reduce(grid, %{}, fn
        {{x, y}, ?v}, new_grid ->
          cond do
            grid[{x, y + 1}] == nil and grid[{x, 0}] == ?. ->
              new_grid
              |> Map.put({x, y}, ?.)
              |> Map.put({x, 0}, ?v)

            grid[{x, y + 1}] == ?. ->
              new_grid
              |> Map.put({x, y}, ?.)
              |> Map.put({x, y + 1}, ?v)

            true ->
              Map.put_new(new_grid, {x, y}, ?v)
          end

        {{x, y}, chr}, new_grid ->
          Map.put_new(new_grid, {x, y}, chr)
      end)
    end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.with_index()
    |> Stream.map(fn {line, y} ->
      line
      |> String.trim_trailing()
      |> String.to_charlist()
      |> Stream.with_index()
      |> then(&{&1, y})
    end)
    |> Enum.reduce(%{}, fn {xs, y}, grid ->
      Enum.reduce(xs, grid, fn {chr, x}, grid ->
        Map.put(grid, {x, y}, chr)
      end)
    end)
  end
end
