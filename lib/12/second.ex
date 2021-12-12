defmodule Aoc2021.Day12.Second do
  def run(file) do
    nodes =
      file
      |> input()
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    nodes
    |> Map.keys()
    |> Enum.filter(fn node ->
      node.type == "small" && node.id not in ~w[start end]
    end)
    |> Enum.flat_map(fn special ->
      pathfinder(nodes, [%{id: "start", type: "small"}], MapSet.new(), special.id, 0)
    end)
    |> Enum.uniq()
    |> length()
  end

  def pathfinder(_, [%{id: "end"} | _] = path, _, _, _) do
    [path]
  end

  def pathfinder(nodes, [%{id: id} = current | _] = path, visited, special, sp_visited) do
    conns =
      nodes
      |> Map.get(current, [])
      |> Enum.filter(fn %{type: type, id: id} = node ->
        type == "big" || node not in visited || (id == special && sp_visited < 2)
      end)

    visited = MapSet.put(visited, current)
    sp_visited = if(id == special, do: sp_visited + 1, else: sp_visited)

    Enum.flat_map(conns, fn node ->
      pathfinder(nodes, [node | path], visited, special, sp_visited)
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
