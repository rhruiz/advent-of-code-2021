defmodule Aoc2021.Day15.First do
  @deltas [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]

  def run(file) do
    {map, target} = input(file)

    risks = %{{0, 0} => 0}

    unvisited = map |> Map.keys() |> MapSet.new()

    navigate(map, {0, 0}, risks, unvisited, target)
  end

  def navigate(map, current, risks, unvisited, target) do
    current_risk = risks[current]

    risks =
      map
      |> neighbors(current)
      |> Enum.filter(fn {neighbor, _risk} -> neighbor in unvisited end)
      |> Enum.reduce(risks, fn {neighbor, risk}, risks ->
        Map.update(risks, neighbor, current_risk + risk, fn neighbor_risk ->
          if risk + current_risk < neighbor_risk do
            risk + current_risk
          else
            neighbor_risk
          end
        end)
      end)

    unvisited = MapSet.delete(unvisited, current)

    cond do
      target not in unvisited ->
        risks[target]

      true ->
        candidate =
          risks
          |> Enum.min_by(fn {pos, risk} ->
            if pos in unvisited do
              risk
            else
              nil
            end
          end)
          |> elem(0)

        navigate(map, candidate, risks, unvisited, target)
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
