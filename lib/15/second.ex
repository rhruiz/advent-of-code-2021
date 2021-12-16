defmodule Aoc2021.Day15.Second do
  @deltas [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]

  def run(file) do
    {map, target} = input(file)
    {map, target} = expand(map, target)

    navigate(map, target)
  end

  def navigate(map, target) do
    navigate(map, target, :gb_sets.singleton({0, {0, 0}}), MapSet.new())
  end

  def navigate(map, target, queue, visited) do
    {{risk, current}, queue} = :gb_sets.take_smallest(queue)

    cond do
      current == target ->
        risk

      true ->
        visited = MapSet.put(visited, current)

        queue =
          map
          |> neighbors(current)
          |> Enum.reduce(queue, fn {neighbor, neighbor_risk}, queue ->
            if neighbor not in visited do
              priority = neighbor_risk + risk
              :gb_sets.add_element({priority, neighbor}, queue)
            else
              queue
            end
          end)

        navigate(map, target, queue, visited)
    end
  end

  def expand(map, {xmax, ymax}) do
    {xorgmax, yorgmax} = {xmax, ymax}
    {xmax, ymax} = {(xmax + 1) * 5 - 1, (ymax + 1) * 5 - 1}

    map =
      Enum.reduce(0..xmax, map, fn x, map ->
        Enum.reduce(0..ymax, map, fn y, map ->
          {xorg, yorg} = {rem(x, xorgmax + 1), rem(y, yorgmax + 1)}
          distance = div(x, xorgmax + 1) + div(y, yorgmax + 1)
          original_value = Map.get(map, {xorg, yorg})
          value = original_value |> Kernel.+(distance - 1) |> rem(9) |> Kernel.+(1)

          Map.put(map, {x, y}, value)
        end)
      end)

    {map, {xmax, ymax}}
  end

  def neighbors(map, {x, y}) do
    @deltas
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.flat_map(fn position ->
      case Map.fetch(map, position) do
        {:ok, risk} -> [{position, risk}]
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
    |> Enum.reduce({%{}, {0, 0}}, fn {xs, y}, {map, {xmax, ymax}} ->
      xs
      |> Enum.with_index()
      |> Enum.reduce({map, {xmax, ymax}}, fn {risk, x}, {map, {xmax, ymax}} ->
        {Map.put(map, {x, y}, risk), {max(x, xmax), max(y, ymax)}}
      end)
    end)
  end
end
