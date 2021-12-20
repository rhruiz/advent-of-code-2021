defmodule Aoc2021.Day20.Second do
  import Aoc2021.Day20.First, only: [enhance_image: 2, light_count: 1, input: 1]

  def run(file) do
    {algo, image} = input(file)

    1..50
    |> Enum.reduce(image, fn _step, image ->
      enhance_image(image, algo)
    end)
    |> light_count()
  end
end
