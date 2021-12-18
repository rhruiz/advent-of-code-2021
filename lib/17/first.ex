defmodule Aoc2021.Day17.First do
  def run(tx, ty) do
    vy =
      1..100
      |> Enum.filter(fn vy ->
        Stream.iterate({{0, 0}, {0, vy}}, fn {pos, delta} ->
          step(pos, delta)
        end)
        |> Stream.chunk_every(2, 1)
        |> Stream.take_while(fn [_, {{_x2, y2}, _}] ->
          y2 >= Enum.min(ty)
        end)
        |> Enum.any?(fn
          [{{_x1, y1}, _}, {{_x2, y2}, _}] when y1 >= 0 and y2 < 0 ->
            (y2 in ty)

          _other -> false
        end)
      end)
      |> Enum.max_by(&max/1)

    steps = steps(vy, ty)

    vx =
      0..100
      |> Enum.find(fn vx ->
        Stream.iterate({{0, 0}, {vx, vy}}, fn {pos, delta} ->
          step(pos, delta)
        end)
        |> Stream.drop(steps - 1)
        |> Enum.take(1)
        |> hd()
        |> then(fn {{x, _}, _} -> x in tx end)
      end)

    if vx == nil do
      raise "boom"
    end

    max(vy)
  end

  def steps(vy, ty) do
    Stream.iterate({{0, 0}, {0, vy}}, fn {pos, delta} ->
      step(pos, delta)
    end)
    |> Stream.with_index()
    |> Enum.find(fn
      {{{_, y}, _}, _step} -> y in ty
      _other -> false
    end)
    |> elem(1)
  end

  def max(vy) do
    Stream.iterate({{0, 0}, {0, vy}}, fn {pos, delta} ->
      step(pos, delta)
    end)
    |> Stream.chunk_every(2, 1)
    |> Enum.find(fn
      [{{_, y1}, _}, {{_, y2}, _}] -> y2 < y1
      _other -> false
    end)
    |> hd()
    |> elem(0)
    |> elem(1)
  end

  def step({x, y}, {dx, dy}) do
    {{x + dx, y + dy}, {dx + dx(dx), dy - 1}}
  end

  def dx(0), do: 0
  def dx(dx), do: div(0-dx, abs(dx))
end
