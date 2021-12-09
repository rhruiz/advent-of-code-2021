defmodule Aoc2021.Day9.Second do
  @deltas [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def run(file) do
    file
    |> input()
    |> find_basins()
    |> Enum.map(&MapSet.size/1)
  end

  def find_basins(map) do
    map
    |> Enum.reduce({MapSet.new(), []}, fn
      {_position, 9}, {visited, basins} ->
        {visited, basins}

      {position, _height}, {visited, basins} ->
        if MapSet.member?(visited, position) do
          {visited, basins}
        else
          basin = find_basin(map, MapSet.new([position]), MapSet.new())
          {MapSet.union(visited, basin), [basin | basins]}
        end
    end)
    |> elem(1)
  end

  def find_basin(_map, %MapSet{map: map}, basin) when map_size(map) == 0 do
    basin
  end

  def find_basin(map, queue, basin) do
    position = hd(MapSet.to_list(queue))
    queue = MapSet.delete(queue, position)

    queue =
      map
      |> neighbors(position)
      |> Enum.filter(fn {_position, height} -> height != 9 end)
      |> Enum.reduce(queue, fn
        {_position, 9}, queue ->
          queue

        {position, _height}, queue ->
          if !MapSet.member?(basin, position) do
            MapSet.put(queue, position)
          else
            queue
          end
      end)

    find_basin(map, queue, MapSet.put(basin, position))
  end

  def neighbors(map, {x, y}) do
    @deltas
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.flat_map(fn position -> Map.take(map, [position]) end)
    |> Enum.into(%{})
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.map(fn line -> Enum.map(line, &String.to_integer/1) end)
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {xs, y}, map ->
      xs
      |> Enum.with_index()
      |> Enum.reduce(map, fn {height, x}, map ->
        Map.put(map, {x, y}, height)
      end)
    end)
  end
end
