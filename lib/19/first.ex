defmodule Aoc2021.Day19.First do
  defmodule Scanner do
    @derive {Inspect, only: [:id]}
    defstruct [:coords, :id]
  end

  @rotations [
    [[-1, 0, 0], [0, 0, -1], [0, -1, 0]],
    [[0, -1, 0], [-1, 0, 0], [0, 0, -1]],
    [[0, 0, -1], [0, -1, 0], [-1, 0, 0]],
    [[-1, 0, 0], [0, -1, 0], [0, 0, 1]],
    [[0, -1, 0], [0, 0, 1], [-1, 0, 0]],
    [[0, 0, 1], [-1, 0, 0], [0, -1, 0]],
    [[-1, 0, 0], [0, 1, 0], [0, 0, -1]],
    [[0, 1, 0], [0, 0, -1], [-1, 0, 0]],
    [[0, 0, -1], [-1, 0, 0], [0, 1, 0]],
    [[-1, 0, 0], [0, 0, 1], [0, 1, 0]],
    [[0, 1, 0], [-1, 0, 0], [0, 0, 1]],
    [[0, 0, 1], [0, 1, 0], [-1, 0, 0]],
    [[1, 0, 0], [0, -1, 0], [0, 0, -1]],
    [[0, -1, 0], [0, 0, -1], [1, 0, 0]],
    [[0, 0, -1], [1, 0, 0], [0, -1, 0]],
    [[1, 0, 0], [0, 0, 1], [0, -1, 0]],
    [[0, -1, 0], [1, 0, 0], [0, 0, 1]],
    [[0, 0, 1], [0, -1, 0], [1, 0, 0]],
    [[1, 0, 0], [0, 0, -1], [0, 1, 0]],
    [[0, 1, 0], [1, 0, 0], [0, 0, -1]],
    [[0, 0, -1], [0, 1, 0], [1, 0, 0]],
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
    [[0, 1, 0], [0, 0, 1], [1, 0, 0]],
    [[0, 0, 1], [1, 0, 0], [0, 1, 0]]
  ]

  def input(file) do
    file
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn report ->
      [scanner | coords] = String.split(report, "\n", trim: true)
      ["---", "scanner", scanner, "---"] = String.split(scanner, " ")
      scanner = %Scanner{id: String.to_integer(scanner)}

      coords =
        Enum.map(coords, fn coord ->
          coord
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end)

      %{scanner | coords: coords}
    end)
  end

  def rotations({x, y, z}) do
    @rotations
    |> Enum.map(fn [[a, b, c], [d, e, f], [g, h, i]] ->
      {x * a + y * b + z * c, d * x + e * y + f * z, g * x + h * y + i * z}
    end)
  end

  def rebase(%Scanner{coords: coords} = scanner, base) do
    %{scanner | coords: Enum.map(coords, fn coord -> rebase(base, coord) end)}
  end

  def rebase({xs, ys, zs}, {xt, yt, zt}) do
    {xt - xs, yt - ys, zt - zs}
  end

  def rotate({x, y, z}, [[a, b, c], [d, e, f], [g, h, i]]) do
    {x * a + y * b + z * c, d * x + e * y + f * z, g * x + h * y + i * z}
  end

  def rotate(%Scanner{coords: coords} = scanner, rotation) do
    %{scanner | coords: Enum.map(coords, fn coord -> rotate(coord, rotation) end)}
  end

  def matching(scanner, target) do
    Enum.find_value(scanner.coords, fn coord ->
      scanner = rebase(scanner, coord)
      coords = MapSet.new(scanner.coords)
      {xs, ys, zs} = coord

      Enum.find_value(target.coords, fn tcoord ->
        target = rebase(target, tcoord)
        {xt, yt, zt} = tcoord

        coords
        |> MapSet.intersection(MapSet.new(target.coords))
        |> MapSet.size()
        |> Kernel.>=(12)
        |> if(do: {xt - xs, yt - ys, zt - zs}, else: false)
      end)
    end)
  end

  def find_rotations(source, scanners) do
    scanners
    |> Enum.reduce(%{}, fn target, pairs ->
      cond do
        translation = matching(target, source) ->
          Map.put(pairs, target, {nil, translation})

        true ->
          @rotations
          |> Enum.reduce(nil, fn
            rotation, nil ->
              translation = matching(rotate(target, rotation), source)

              if translation != nil do
                {translation, rotation}
              else
                nil
              end

            _rotation, result ->
              result
          end)
          |> then(fn
            nil -> pairs
            {translation, rotation} -> Map.put(pairs, target, {rotation, translation})
          end)
      end
    end)
  end

  def run(file) do
    scanners = file |> input()


    {[first], tail} = Enum.split_with(scanners, &match?(%{id: 0}, &1))

    build_graph([first | tail], %{})
  end


  def build_graph([], graph), do: graph

  def build_graph([source | tail], graph) do
    rotations = find_rotations(source, tail)

    graph = Enum.reduce(rotations, graph, fn {target, rotations}, graph ->
      Map.put(graph, {source.id, target.id}, rotations)
    end)

    build_graph(tail, graph)
  end


#     {scanners,
#     scanners
#     |> find_rotations()
#     |> Enum.sort_by(fn {key, _} ->
#       key
#       |> Tuple.to_list()
#       |> Enum.map(&(&1.id))
#       |> Enum.min()
#     end)}
  # end

  def run1(scanners, rotations) do
    scanner_by_id = Enum.into(scanners, %{}, &{&1.id, &1})

    rotations
    |> find_transformations([], %{0 => []})
    |> IO.inspect()
    |> tap(fn transformations ->
      Map.map(transformations, fn {k, v} -> length(v) end) |> IO.inspect()
    end)
    |> Enum.reduce(MapSet.new, fn {id, transformations}, beacons ->
      scanner = Map.get(scanner_by_id, id)

      transformations
      |> Enum.reduce(scanner, fn {rotations, translate}, scanner ->
        rotations
        |> Enum.reduce(scanner, &rotate(&2, &1))
        |> then(&rebase(&1, translate))
      end)
      |> Map.get(:coords)
      |> MapSet.new()
      |> MapSet.union(beacons)
    end)
    |> MapSet.size()
  end

  def find_transformations([], [], transformations) do
    transformations
  end

  def find_transformations([], [item | queue], transformations) do
    find_transformations([item], queue, transformations)
  end

  def find_transformations([{{a, b}, rotations} | tail], queue, transformations) do
    b = Enum.reduce(rotations, b, &rotate(&2, &1))

    cond do
      Map.has_key?(transformations, a.id) ->
        translate = matching(a, b) || matching(b, a)
        existing = Map.get(transformations, a.id)
        transformations = Map.put(transformations, b.id, [{rotations, translate} | existing])

        find_transformations(tail, queue, transformations)

      Map.has_key?(transformations, b.id) ->
        translate = matching(b, a) || matching(a, b)
        existing = Map.get(transformations, b.id)
        transformations = Map.put(transformations, a.id, [{rotations, translate} | existing])

        find_transformations(tail, queue, transformations)

      true ->
        find_transformations(tail, queue ++ [{{a, b}, rotations}], transformations)
    end
  end
end
