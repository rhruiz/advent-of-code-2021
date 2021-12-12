defmodule Aoc2021.Day12.Second do
  def run(file) do
    file
    |> input()
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.into(%{}, fn {{id, _type}, conns} -> {id, conns} end)
    |> pathfinder()
    |> length()
  end

  def pathfinder(nodes) do
    pathfinder(nodes, [:start], %{}, nil, 0)
  end

  def pathfinder(nodes, [current | _] = path, visited, special, sp_visited) do
    conns =
      nodes
      |> Map.get(current, [])
      |> Enum.filter(fn
        {_, :big} -> true
        {^special, _} when special != nil -> sp_visited < 2
        {id, _} when special == nil and is_map_key(visited, id) -> true
        {id, _} -> !Map.has_key?(visited, id)
      end)

    visited = Map.put(visited, current, [])
    sp_visited = if(current == special, do: sp_visited + 1, else: sp_visited)

    Enum.flat_map(conns, fn
      {:end, _} ->
        [[:end | path]]

      {node_id, :small} when special == nil and is_map_key(visited, node_id) ->
        pathfinder(nodes, [node_id | path], visited, node_id, sp_visited + 1)

      {node_id, _} ->
        pathfinder(nodes, [node_id | path], visited, special, sp_visited)
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
