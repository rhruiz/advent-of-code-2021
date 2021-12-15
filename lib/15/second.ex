defmodule Aoc2021.Day15.Second do
  @deltas [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]

  def run(file) do
    {map, target} = input(file)
    {map, target} = expand(map, target)

    risks = %{{0, 0} => 0}
    unvisited = map |> Map.keys() |> MapSet.new()

    Aoc2021.Day15.First.navigate(map, {0, 0}, risks, unvisited, target)
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

  def navigate(map, queue, visited, risks, target) do
    {{:value, current}, queue} = :queue.out(queue)

    cond do
      current in visited ->
        navigate(map, queue, visited, risks, target)

      current == target ->
        risks[target]

      true ->
        {queue, risks} =
          map
          |> neighbors(current)
          |> Enum.filter(fn {pos, _} -> pos not in visited end)
          |> Enum.reduce({queue, risks}, fn {pos, risk}, {queue, risks} ->
            if risks[current] + risk < risks[pos] do
              {:queue.in(pos, queue), Map.put(risks, pos, risks[current] + risk)}
            else
              {queue, risks}
            end
          end)

        visited = MapSet.put(visited, current)

        navigate(map, queue, visited, risks, target)
    end
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
