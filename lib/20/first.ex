defmodule Aoc2021.Day20.First do
  use Bitwise, only_operators: true

  @deltas for y <- -1..1, x <- -1..1, do: {x, y}

  defmodule Image do
    defstruct map: %{}, xmax: 0, ymax: 0, xmin: 0, ymin: 0, default: 0
  end

  def run(file) do
    {algo, image} = input(file)

    image
    |> enhance_image(algo)
    |> enhance_image(algo)
    |> light_count()
  end

  def light_count(%Image{map: map}) do
    Enum.count(map, &match?({_, 1}, &1))
  end

  def render(image) do
    Enum.each(image.ymin..image.ymax, fn y ->
      Enum.each(image.xmin..image.ymax, fn x ->
        IO.write(if(at(image, {x, y}) == 1, do: '#', else: '.'))
      end)

      IO.puts("")
    end)
  end

  def enhance_image(image, algo) do
    enhanced_image = %Image{
      xmax: image.xmax + 1,
      xmin: image.xmin - 1,
      ymax: image.ymax + 1,
      ymin: image.ymin - 1,
      default: rem(image.default + (algo >>> 511), 2)
    }

    for x <- (image.xmin - 1)..(image.xmax + 1),
        y <- (image.ymin - 1)..(image.ymax + 1),
        pos <- [{x, y}],
        reduce: enhanced_image do
      enhanced_image -> put(enhanced_image, pos, enhance_pixel(image, algo, pos))
    end
  end

  def enhance_pixel(image, algo, position) do
    addr = algo_address(image, position)
    algo >>> (512 - addr - 1) &&& 1
  end

  def algo_address(image, {x, y}) do
    @deltas
    |> Enum.reduce(0, fn {dx, dy}, addr ->
      addr * 2 + at(image, {x + dx, y + dy})
    end)
  end

  def put(%Image{map: map} = image, pos, value) do
    %{image | map: Map.put(map, pos, value)}
  end

  def at(%Image{map: map, default: default}, pos), do: Map.get(map, pos, default)

  def input(file) do
    [algo, image] =
      file
      |> File.read!()
      |> String.split("\n\n")

    algo =
      algo
      |> String.to_charlist()
      |> Enum.reduce(0, fn
        ?#, number -> number * 2 + 1
        ?., number -> number * 2
        _, number -> number
      end)

    {image, x, y} =
      image
      |> String.split("\n", trim: true)
      |> Stream.map(&String.to_charlist/1)
      |> Stream.with_index()
      |> Enum.reduce({%{}, 0, 0}, fn {line, y}, {map, xmax, ymax} ->
        line
        |> Enum.with_index()
        |> Enum.reduce({map, xmax, ymax}, fn
          {?#, x}, {map, _, _} -> {Map.put(map, {x, y}, 1), x, y}
          {?., x}, {map, _, _} -> {Map.put(map, {x, y}, 0), x, y}
        end)
      end)

    {algo, %Image{map: image, xmax: x, ymax: y}}
  end
end
