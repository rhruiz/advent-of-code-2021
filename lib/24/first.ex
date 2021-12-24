defmodule Aoc2021.Day24.First do
  alias Aoc2021.Day24.ALU

  def solve([], _, result) do
    result
  end

  def solve([{{26, b, _}, index} | tail], [{last_index, last_c} | queue], result) do
    diff = b + last_c

    result =
      if diff > 0 do
        Map.merge(result, %{
          last_index => {1, 9 - diff},
          index => {1 + diff, 9}
        })
      else
        Map.merge(result, %{
          last_index => {1 - diff, 9},
          index => {1, 9 + diff}
        })
      end

    solve(tail, queue, result)
  end

  def solve([{{_, _, c}, index} | tail], queue, result) do
    solve(tail, [{index, c} | queue], result)
  end

  def run(file) do
    alu =
      file
      |> File.read!()
      |> ALU.parse()

    params =
      alu.instructions
      |> Enum.chunk_every(18)
      |> Enum.map(fn block ->
        [4, 5, 15]
        |> Enum.map(&get_in(block, [Access.at(&1), Access.at(2)]))
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    digit_map =
      params
      |> Enum.with_index()
      |> solve([], %{})

    0..13
    |> Enum.map(&Map.get(digit_map, &1))
    |> Enum.unzip()
    |> then(fn {min, max} ->
      {Integer.undigits(min), Integer.undigits(max)}
    end)
  end
end
