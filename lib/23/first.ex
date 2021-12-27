defmodule Aoc2021.Day23.First do
  @deltas [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]
  @ymax 4

  def run(file) do
    {map, amps} = input(file)

    navigate(amps, map)
  end

  def navigate(map, amps), do: navigate(map, amps, []), 0, %{})

  def navigate(_map, [], [], energy, _visited) do
    energy
  end

  def navigate(map, [pos | tail], queue, energy, visited) do
    type = grid[pos]

    cond do
      final_destination(map, pos) ->
        []

      in_hallway(pos) ->
        dest_x = room_x(type)

        if !strangers_in_the_room(map, {dest_x, y}) and hallway_clear(map, pos, {x_dest, 2}) do
          dest_y = Enum(@ymax..2, fn y ->
            grid[{dest_x, y}] == ?.
          end)

          energy_cost = distance(pos, {dest_x, dest_y}) * energy(type)

          map = Map.merge(map, %{
            {x, y} => ?.
            {dest_x, dest_y} => grid[{x, y}]
          })
        end

        case Map.has_key?(map, map) do
          e when e < energy ->
            navigate(map, tail, queue, energy, Map.put(visited, map, energy + energy_cost))

          _ ->
            navigate(map, tail, enqueue(queue, energy + energy_cost, {map, [{dest_x, dest_y} | tail]}), energy, Map.put(visited, map, energy + energy_cost))
        end

      true ->
        [1, 2, 4, 6, 8, 10, 11]
        |> Enum.filter(fn dest_x -> hallway_clear(map, pos, {dx, 1}) end)
        |> Enum.reduce({queue, visited}, fn dest_x, {queue, visited} ->
          map = Map.merge(map, %{
            pos => ?.,
            {dest_x, 1} => type
          })

          energy_cost = energy + distance(pos, {dest_x, 1}) * energy(type)

          case Map.get(visited, map) do
            e when e < energy ->
              navigate(map, tail, queue, energy, Map.put(visited, map, energy + energy_cost))

            _ ->
              navigate(map, tail, enqueue(queue, energy + energy_cost, {map, [{dest_x, 1} | tail]}), energy, Map.put(visited, map, energy + energy_cost))
          end
        end)
    end
  end

  def distance({xa, ya}, {xb, yb}) do
    trunc(abs(xb - xa) + abs(yb - ya))
  end

  def hallway_clear(map, {xo, _}, {xt, _}) do
    Enum.all?((xo+1..xt), fn x -> map[{x, 1}] == ?. end)
  end

  def final_destination(map, pos) do
    in_room_for_type(pos) && !strangers_in_the_room(map, pos)
  end

  def strangers_in_the_room(map, {x, _}) do
    type = map[pos]

    Enum.any?(0..3, fn y ->
      map[{x, y}] not in [".", type, "#"]
    end
  end

  def in_hallway({x, y}), do: x not in [0, 12] and y == 1

  def energy(?A), do: 1
  def energy(?B), do: 10
  def energy(?C), do: 100
  def energy(?D), do: 1000

  def room_x(?A), do: 3
  def room_x(?B), do: 5
  def room_x(?C), do: 7
  def room_x(?D), do: 9

  def in_room_for_type({x, y}, type), do: x == room_x(type) && y > 1

  defp enqueue([{current, _} | _] = queue, value, weight) when weight <= current do
    [{weight, value} | queue]
  end

  defp enqueue([head | tail], value, weight) do
    [head | enqueue(tail, value, weight)]
  end

  defp enqueue([], value, weight) do
    [{weight, value}]
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
    |> Stream.map(&String.to_charlist/1)
    |> Stream.with_index()
    |> Enum.reduce({%{}, []}, fn {xs, y}, {map, amps} ->
      xs
      |> Stream.with_index()
      |> Enum.reduce({map, amps}, fn
        {?#, x}, {map, amps} ->
          {Map.put(map, {x, y}, ?#), amps}

        {?., x}, {map, amps} ->
          {Map.put(map, {x, y}, ?.), amps}

        {?\s, _yx}, {map, amps} ->
          {map, amps}

        {amp, x}, {map, amps} ->
          {Map.put(map, {x, y}, amp), [{x, y} | amps]}
      end)
    end)
  end
end
