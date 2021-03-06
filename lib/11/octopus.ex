defmodule Aoc2021.Day11.Octopus do
  @deltas for x <- -1..1, y <- -1..1, {x, y} != {0, 0}, do: {x, y}

  def flashes(map) do
    Enum.count(map, &match?({_position, 0}, &1))
  end

  def step(map) do
    map = Map.map(map, fn {_, energy} -> energy + 1 end)

    map
    |> Enum.reduce(map, fn
      {position, 10}, map -> flash(map, position)
      _, map -> map
    end)
    |> Map.map(fn {_, energy} ->
      if(energy > 9, do: 0, else: energy)
    end)
  end

  defp flash(map, position) do
    {map, flashers} =
      map
      |> neighbors(position)
      |> Enum.reduce({map, []}, fn position, {map, flashers} ->
        case Map.get(map, position) do
          9 ->
            {Map.put(map, position, 10), [position | flashers]}

          energy ->
            {Map.put(map, position, energy + 1), flashers}
        end
      end)

    Enum.reduce(flashers, map, fn position, map ->
      flash(map, position)
    end)
  end

  def render(map) do
    Enum.each(0..9, fn y ->
      0..9
      |> Enum.map(fn x ->
        case Map.get(map, {x, y}) do
          0 -> [IO.ANSI.bright(), "0", IO.ANSI.reset()]
          energy -> "#{energy}"
        end
      end)
      |> IO.puts()
    end)

    nil
  end

  defp neighbors(map, {x, y}) do
    @deltas
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.flat_map(fn position ->
      case Map.fetch(map, position) do
        {:ok, _energy} -> [position]
        :error -> []
      end
    end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.map(fn line -> Enum.map(line, &String.to_integer/1) end)
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {xs, y}, map ->
      xs
      |> Enum.with_index()
      |> Enum.reduce(map, fn {energy, x}, map ->
        Map.put(map, {x, y}, energy)
      end)
    end)
  end
end
