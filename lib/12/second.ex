defmodule Aoc2021.Day12.Second do
  def run(file) do
    nodes =
      file
      |> input()
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    specials =
      nodes
      |> Map.keys()
      |> Enum.filter(fn {_id, type} -> type == :small end)

    nodes =
      Enum.into(nodes, %{}, fn {{id, _type}, conns} -> {id, conns} end)
      |> IO.inspect()

    specials
    |> Enum.flat_map(fn {special, _} ->
      pathfinder(nodes, [:start], MapSet.new(), special, 0)
    end)
    |> Enum.uniq()
    |> length()
  end

  def pathfinder(_, [:end | _] = path, _, _, _) do
    [path]
  end

  def pathfinder(nodes, [current | _] = path, visited, special, sp_visited) do
    conns =
      nodes
      |> Map.get(current, [])
      |> Enum.filter(fn
        {_, :big} -> true
        {^special, _} when special != nil -> sp_visited < 2
        {id, _} -> id not in visited
      end)

    visited = MapSet.put(visited, current)
    sp_visited = if(current == special, do: sp_visited + 1, else: sp_visited)

    Enum.flat_map(conns, fn {id, _type} ->
      pathfinder(nodes, [id | path], visited, special, sp_visited)
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
          if node in ~w[start end] do
            :unique
          else
            :small
          end
        else
          :big
        end
      end

      {
        {String.to_atom(source), type.(source)},
        {String.to_atom(destination), type.(destination)}
      }
    end)
    |> Stream.flat_map(fn
      {a, b} -> [{a, b}, {b, a}]
    end)
    |> Stream.reject(fn
      {{:end, _}, _} -> true
      {_, {:start, _}} -> true
      _ -> false
    end)
  end
end
