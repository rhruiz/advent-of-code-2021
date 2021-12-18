defmodule Aoc2021.Day17.First do
  # Sy = S0y + V0*t + a/2*t**2
  # a/2*t**2 + V0*t - Sy = 0
  # roots = vy +/- :math.sqrt(delta)
  def delta(vy, position) do
    :math.sqrt(vy ** 2 - 4 * -0.5 * -position)
  end

  def step_estimate(vy, position) do
    try do
      Enum.max([vy + delta(vy, position), vy - delta(vy, position)])
    rescue
      ArithmeticError -> nil
    end
  end

  def sy_estimate(v0y, steps) do
    trunc(steps * (2 * v0y + (steps - 1) * -1) / 2)
  end

  def run(tx, ty) do
    vy =
      1..100
      |> Enum.filter(fn vy ->
        Stream.iterate(vy, &(&1 + 1))
        |> Stream.map(fn vy ->
          {vy, trunc(step_estimate(vy, Enum.max(ty))),
           trunc(:math.ceil(step_estimate(vy, Enum.min(ty))))}
        end)
        |> Stream.filter(fn {_vy, step_min, step_max} ->
          step_min != nil || step_max != nil
        end)
        |> Enum.take_while(fn {vy, step_min, step_max} ->
          sy_estimate(vy, trunc(step_min)) in ty ||
            sy_estimate(vy, trunc(:math.ceil(step_max))) in ty
        end)
        |> length() > 0
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
      raise RuntimeError, "no vx is not possible for the given vy"
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
  def dx(dx), do: div(0 - dx, abs(dx))
end
