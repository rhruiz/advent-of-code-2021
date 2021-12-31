defmodule Aoc2021.Day23.Second do
  @ymax 5
  @solved for x <- 3..9//2,
              y <- 2..@ymax,
              reduce: %{},
              do: (map -> Map.put(map, {x, y}, ?A + div(x, 2) - 1))

  def run(file) do
    file
    |> input()
    |> expand()
    |> navigate()
  end

  def expand(map) do
    Map.merge(map, %{
      {3, 3} => ?D,
      {3, 4} => ?D,
      {3, 5} => map[{3, 3}],
      {5, 3} => ?C,
      {5, 4} => ?B,
      {5, 5} => map[{5, 3}],
      {7, 3} => ?B,
      {7, 4} => ?A,
      {7, 5} => map[{7, 3}],
      {9, 3} => ?A,
      {9, 4} => ?C,
      {9, 5} => map[{9, 3}]
    })
  end

  def navigate(map) do
    navigate(enqueue(:gb_sets.new(), map, 0), MapSet.new())
  end

  def navigate(queue, visited) do
    {{current_energy, current}, queue} = :gb_sets.take_smallest(queue)

    cond do
      final_destination(current) ->
        current_energy

      MapSet.member?(visited, current) ->
        navigate(queue, visited)

      true ->
        current
        |> neighbors()
        |> Enum.reject(&MapSet.member?(visited, &1))
        |> Enum.reduce(queue, fn {neighbor, energy}, queue ->
          enqueue(queue, neighbor, current_energy + energy)
        end)
        |> navigate(MapSet.put(visited, current))
    end
  end

  def distance({xa, ya}, {xb, yb}) do
    abs(xb - xa) + abs(yb - ya)
  end

  def hallway_clear(map, xo, xt) do
    Enum.all?(xo..xt, fn x -> x == xo or map[{x, 1}] == nil end)
  end

  def final_destination(map), do: map == @solved

  def final_destination(map, pos, type) do
    in_room_for_type(pos, type) && !strangers_in_the_room(map, type)
  end

  def strangers_in_the_room(map, type) do
    x = room_x(type)

    Enum.any?(2..@ymax, fn y -> Map.get(map, {x, y}, type) != type end)
  end

  def in_hallway({_x, y}), do: y == 1

  def energy(type), do: 10 ** (type - ?A)

  def room_x(type), do: 3 + 2 * (type - ?A)

  def in_room_for_type({x, y}, type), do: y > 1 and x == room_x(type)

  def free_y(map, x) do
    Enum.find(@ymax..2, fn y ->
      Map.get(map, {x, y}) == nil
    end)
  end

  def render(map) do
    IO.puts("#############")
    IO.write("#")

    Enum.each(1..11, fn x -> map |> Map.get({x, 1}, ?.) |> List.wrap() |> IO.write() end)

    IO.puts("#")

    Enum.each(2..@ymax, fn y ->
      IO.write(if(y < 3, do: "##", else: "  "))

      Enum.each(2..10, fn
        x when rem(x, 2) == 0 -> IO.write("#")
        x -> map |> Map.get({x, y}, ?.) |> List.wrap() |> IO.write()
      end)

      IO.puts(if(y < 3, do: "##", else: "  "))
    end)

    IO.puts("  #########")
  end

  defp enqueue(queue, value, weight) do
    :gb_sets.add({weight, value}, queue)
  end

  def next_moves(type, {x, y} = from, map) do
    xt = room_x(type)

    cond do
      # already there
      final_destination(map, from, type) ->
        []

      # stuck in a room
      map[{x, y - 1}] != nil ->
        []

      in_hallway(from) ->
        if hallway_clear(map, x, xt) and !strangers_in_the_room(map, type) do
          yt = free_y(map, xt)

          [{xt, yt}]
        else
          []
        end

      # in room, move to hallway
      true ->
        hallways_for(map, x)
    end
  end

  def hallways_for(map, x) do
    left =
      x..1
      |> Enum.filter(&(&1 in [1, 11] || rem(&1, 2) == 0))
      |> Enum.take_while(fn xc -> map[{xc, 1}] == nil end)

    right =
      x..11
      |> Enum.filter(&(&1 in [1, 11] || rem(&1, 2) == 0))
      |> Enum.take_while(fn xc -> map[{xc, 1}] == nil end)

    left
    |> Enum.concat(right)
    |> Enum.map(&{&1, 1})
  end

  def neighbors(current) do
    for {from, type} <- current,
        map = Map.delete(current, from),
        dest <- next_moves(type, from, map) do
      {Map.put(map, dest, type), distance(from, dest) * energy(type)}
    end
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_charlist/1)
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {xs, y}, map ->
      xs
      |> Stream.with_index()
      |> Enum.reduce(map, fn
        {amp, x}, map when amp in ?A..?D ->
          Map.put(map, {x, y}, amp)

        _other, map ->
          map
      end)
    end)
  end
end
