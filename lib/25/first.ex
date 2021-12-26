defmodule Aoc2021.Day25.First do
  def run(file) do
    {grid, easters, southers, bounds} = input(file)

    Stream.iterate(1, &(&1 + 1))
    |> Stream.transform({grid, easters, southers}, fn step, {last_grid, easters, southers} ->
      {grid, easters, southers, changed} = step(last_grid, easters, southers, bounds)

      if changed do
        {[step + 1], {grid, easters, southers}}
      else
        {:halt, grid}
      end
    end)
    |> Enum.take(-1)
    |> hd()
  end

  def render(grid, {xmax, ymax}) do
    Enum.each(0..ymax, fn y ->
      Enum.each(0..xmax, fn x ->
        IO.write([grid[{x, y}]])
      end)

      IO.puts("")
    end)

    IO.puts("\n")
  end

  def step(grid, easters, southers, {xmax, ymax}) do
    {grid, easters, changed} = move(grid, easters, &{rem(&1 + 1, xmax + 1), &2})
    {grid, southers, changed2} = move(grid, southers, &{&1, rem(&2 + 1, ymax + 1)})

    {grid, easters, southers, changed || changed2}
  end

  def move(grid, cukes, delta) do
    Enum.reduce(cukes, {grid, [], false}, fn {x, y}, {new_grid, cukes, changed} ->
      next = delta.(x, y)

      if grid[next] == ?. do
        {Map.merge(new_grid, %{{x, y} => ?., next => grid[{x, y}]}), [next | cukes], true}
      else
        {new_grid, [{x, y} | cukes], changed}
      end
    end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_charlist/1)
    |> Stream.with_index()
    |> Enum.reduce({%{}, [], [], {0, 0}}, fn {xs, y}, {grid, easters, southers, bounds} ->
      xs
      |> Stream.with_index()
      |> Enum.reduce({grid, easters, southers, bounds}, fn
        {?., x}, {grid, easters, southers, _bounds} ->
          {Map.put(grid, {x, y}, ?.), easters, southers, {x, y}}

        {?>, x}, {grid, easters, southers, _bounds} ->
          {Map.put(grid, {x, y}, ?>), [{x, y} | easters], southers, {x, y}}

        {?v, x}, {grid, easters, southers, _bounds} ->
          {Map.put(grid, {x, y}, ?v), easters, [{x, y} | southers], {x, y}}
      end)
    end)
  end
end
