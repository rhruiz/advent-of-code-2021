defmodule Aoc2021.Day17.Second do
  def sol do
    File.read!("./test/support/17/sol.txt")
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def run(tx, ty) do
    ys =
      ty
      |> Enum.min()
      |> Stream.iterate(&(&1 + 1))
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
        vy <= 0 || steps < 1000
      end)
      |> Enum.filter(fn {vy, steps} ->
        sy(vy, steps) in ty
      end)

    Enum.flat_map(ys, fn {vy, steps} ->
      steps
      |> possible_voxs(tx)
      |> Enum.map(fn vx -> {vx, vy} end)
    end)
    |> Enum.uniq()
    |> length()
  end

  def possible_voxs(steps, tx) do
    # sx_min = steps*(v0x + vx)/2
    # 2*sx_min = steps * v0x + steps*vx
    # v0x = (2*sx_min-steps*vx)/steps
    # vx = 0
    # v0x = 2*sx_min/steps

    # min_vx = trunc(2*Enum.min(tx)/steps)

    0
    |> Stream.iterate(&(&1 + 1))
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
      trunc(steps * (2 * v0x - steps + 1) / 2)
    end
  end

  def step_estimate(vy, position) do
    # Sy = (an + a1)*steps/2
    # position = (vy + (steps-1)*(-1) + vy)*steps/2
    # 2*position = vy*steps - steps**2 + steps + vy*steps
    # steps**2 - (2vy + 1)*steps + 2*position
    #
    # ((2vy+1) +/- (2*vy+1)**2 - 4*1*2*position)/2
    delta = (2 * vy + 1) ** 2 - 4 * -1 * (-2 * position)

    case delta do
      delta when delta < 0 ->
        nil

      delta ->
        Enum.max([
          (-1 - 2 * vy + :math.sqrt(delta)) / -2,
          (-1 - 2 * vy - :math.sqrt(delta)) / -2
        ])
    end
  end
end
