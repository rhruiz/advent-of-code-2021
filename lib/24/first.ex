defmodule Aoc2021.Day24.First do
  alias Aoc2021.Day24.ALU

  def run(file) do
    alu =
      file
      |> File.read!()
      |> ALU.parse()

    params =
      alu.instructions
      |> Enum.chunk_every(18, 18)
      |> Enum.map(fn b -> {Enum.at(b, 4), Enum.at(b, 5), Enum.at(b, 15)} end)
      |> Enum.map(fn {[_, _, a], [_, _, b], [_, _, c]} ->
        [a, b, c]
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    f = fn {a, b, c}, z, w ->
      if (rem(z, 26) + b) != w do
        div(z, a) * 26 + w + c
      else
        div(z, a)
      end
    end

    Enum.reduce(params, %{0 => {0, 0}}, fn {a, _, _} = param, zs ->
      Enum.reduce(zs, %{}, fn {z, {i1, i2}}, new_zs ->
        Enum.reduce(1..9, new_zs, fn w, new_zs ->
          newz = f.(param, z, w)

          if a == 1 || (a == 26 && newz < z) do
            Map.update(new_zs, newz, {i1 * 10 + w, i2 * 10 + w}, fn {a, b} ->
              {min(a, i1 * 10 + w), max(b, i2 * 10 + w)}
            end)
          else
            new_zs
          end
        end)
      end)
    end)
    |> Map.get(0)
  end
end
