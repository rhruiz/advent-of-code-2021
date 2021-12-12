defmodule Aoc2021.Day12.First do
  def run(file) do
    nodes =
      file
      |> input()
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    nodes
    |> pathfinder([%{id: "start", type: "small"}], MapSet.new())
    |> length()
  end

  def pathfinder(_nodes, [%{id: "end"} | _] = path, _visited) do
    [path]
  end

  def pathfinder(nodes, [current | _] = path, visited) do
    conns =
      nodes
      |> Map.get(current, [])
      |> Enum.filter(fn %{type: type} = node ->
        type == "big" || node not in visited
      end)

    visited = MapSet.put(visited, current)

    Enum.flat_map(conns, fn node ->
      pathfinder(nodes, [node | path], visited)
    end)
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(fn line ->
      [source, destination] = String.split(line, "-")

      type = fn node ->
        if String.downcase(node) == node do
          "small"
        else
          "big"
        end
      end

      {
        %{id: source, type: type.(source)},
        %{id: destination, type: type.(destination)}
      }
    end)
    |> Stream.flat_map(fn {a, b} -> [{a, b}, {b, a}] end)
  end
end
