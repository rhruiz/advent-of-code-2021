defmodule Aoc2021.Day17.Second do
  def run(tx, ty) do
    ys =
      ty
      |> Enum.min()
      |> Stream.iterate(&(&1+1))
      |> Stream.map(fn vy ->
        {vy, trunc(step_estimate(vy, Enum.max(ty))),
          trunc(:math.ceil(step_estimate(vy, Enum.min(ty))))}
      end)
      |> Stream.flat_map(fn {vy, step_min, step_max} ->
        for step <- trunc(step_min)..trunc(:math.ceil(step_max)) do
          {vy, step}
        end
      end)
      |> Enum.take_while(fn {vy, steps} ->
        vy <= 0 || steps < 50
      end)
      |> Enum.filter(fn {vy, steps} ->
        sy(vy, steps) in ty
      end)

    Enum.flat_map(ys, fn {vy, steps} ->
      steps
      |> possible_voxs(tx)
      |> Enum.map(fn vx -> {vx, vy} end)
    end)
  end

  def possible_voxs(steps, tx) do
    # sx_min = steps*(v0x + vx)/2
    # 2*sx_min = steps * v0x + steps*vx
    # v0x = (2*sx_min-steps*vx)/steps
    # vx = 0
    # v0x = 2*sx_min/steps

    # min_vx = trunc(2*Enum.min(tx)/steps)

    0
    |> Stream.iterate(&(&1+1))
    |> Stream.drop_while(fn vx ->
      sx(vx, steps) < Enum.min(tx)
    end)
    |> Enum.take_while(fn vx ->
      sx(vx, steps) in tx
    end)
  end

  # an = a1 + (steps - 1)*(-1)
  # an = a1 - steps + 1
  # steps = a1 + 1 - an
  def steps(v0y, sy) do
    v0y + 1 - sy
  end

  def sy(v0y, steps) do
    trunc(steps * (2 * v0y + (steps - 1) * -1) / 2)
  end

  def sx(v0x, steps) do
    # an = a1 + (steps - 1)*(-1)
    # an = a1 - steps + 1
    # a1 - steps + 1 = 0
    # steps = a1 + 1
    steps_to_zero = v0x + 1

    if steps > steps_to_zero do
      sx(v0x, steps_to_zero)
    else
      trunc(steps*(2*v0x - steps + 1)/2)
    end
  end

  def step_estimate(vy, position) do
    try do
      Enum.max([vy + delta(vy, position), vy - delta(vy, position)])
    rescue
      ArithmeticError -> nil
    end
  end

  # Sy = S0y + V0*t + a/2*t**2
  # a/2*t**2 + V0*t - Sy = 0
  # roots = vy +/- :math.sqrt(delta)
  def delta(vy, position) do
    :math.sqrt(vy ** 2 - 4 * -0.5 * -position)
  end
end
