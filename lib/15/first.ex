defmodule Aoc2021.Day15.First do
  @deltas for x <- -1..1, y <- -1..1, x != y, {x, y} != {0, 0}, do: {x, y}

  def run(file) do
    {map, target} = input(file)

    risks =
      map
      |> Map.map(fn _ -> nil end)
      |> Map.put({0, 0}, 0)

    navigate(map, :queue.from_list({0, 0}, risks, MapSet.new(), target)
  end

  def navigate(_map, @empty, _, _), do: :none

  def navigate(map, current, risks, visited, target) do

    cond do
      current == target ->
        {Enum.reverse(route), total_risk}

      MapSet.member?(visited, current) ->
        navigate(map, current, risks, visited, target)

      true ->
        current_risk = risks[current]

        risks =
          map
          |> neighbors(pos)
          |> Enum.reduce(risks, fn {neighbor, risk}, risks ->
            Map.update!(risks, neighbor, fn risk ->
              min(risk + current_risk, risks[neighbor])
            end
          end)

        visited = MapSet.put(visited, pos)
        navigate(map, queue, risks, visited, target)
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
