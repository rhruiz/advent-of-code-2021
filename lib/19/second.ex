defmodule Aoc2021.Day19.Second do
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
    %{scanner | coords: Enum.map(coords, &rotate(&1, rotation))}
  end

  def add(%Scanner{coords: coords} = scanner, translation) do
    %{scanner | coords: Enum.map(coords, &add(&1, translation))}
  end

  def add({a, b, c}, {d, e, f}) do
    {d + a, e + b, f + c}
  end

  def distance({xa, ya, za}, {xb, yb, zb}) do
    trunc(abs(xb - xa) + abs(yb - ya) + abs(zb - za))
  end

  def diff({xa, ya, za}, {xb, yb, zb}) do
    {xb - xa, yb - ya, zb - za}
  end

  def run(file) do
    file
    |> input()
    |> build_graph()
    |> Enum.reduce(%{0 => []}, fn {{from, to}, tx}, txs ->
      Map.put(txs, to, [tx | txs[from]])
    end)
    |> Enum.map(fn {_id, txs} ->
      Enum.reduce(txs, {0, 0, 0}, fn {translation, rotation}, pos ->
        pos
        |> rotate(rotation)
        |> add(translation)
      end)
    end)
    |> then(fn origins ->
      for p1 <- origins, p2 <- origins, p1 != p2, reduce: 0 do
        distance -> max(distance, distance(p1, p2))
      end
    end)
  end

  def build_graph(scanners) do
    {[first], tail} = Enum.split_with(scanners, &match?(%{id: 0}, &1))
    build_graph([first], MapSet.new(tail), [])
  end

  def build_graph([], _, graph), do: Enum.reverse(graph)

  def build_graph([source | tail], left, graph) do
    left = Enum.reduce([source | tail], left, &MapSet.delete(&2, &1))

    edges =
      Enum.flat_map(left, fn scanner ->
        tx = find_transformation(source, scanner)
        if(tx, do: [{scanner, tx}], else: [])
      end)

    graph =
      Enum.reduce(edges, graph, fn {target, transformation}, graph ->
        [{{source.id, target.id}, transformation} | graph]
      end)

    queue = Enum.map(edges, &elem(&1, 0))

    build_graph(queue ++ tail, left, graph)
  end

  def find_transformation(source, scanner) do
    Enum.find_value(@rotations, fn rotation ->
      scanner
      |> rotate(rotation)
      |> Map.get(:coords)
      |> Enum.flat_map(&Enum.map(source.coords, fn p2 -> diff(&1, p2) end))
      |> Enum.frequencies()
      |> Enum.filter(fn {_, count} -> count >= 12 end)
      |> Enum.map(fn {translation, _} -> {translation, rotation} end)
      |> then(fn
        [head] -> head
        _ -> false
      end)
    end)
  end
end
