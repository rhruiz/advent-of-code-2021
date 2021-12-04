defmodule Aoc2021.Day4.Bingo do
  @length 5

  def score(board, [number_drawn | _] = drawn) do
    drawn = MapSet.new(drawn)

    board
    |> Enum.reduce(0, fn {number, _}, score ->
      if number in drawn do
        score
      else
        score + number
      end
    end)
    |> Kernel.*(number_drawn)
  end

  def won?(board, drawn) do
    marked = Map.take(board, drawn)

    any = fn selector ->
      marked
      |> Enum.group_by(selector)
      |> Enum.any?(fn {_, marked} -> length(marked) == @length end)
    end

    any.(fn {_, {row, _}} -> row end) || any.(fn {_, {_, col}} -> col end)
  end

  def input(file) do
    [draw | boards] =
      file
      |> File.read!()
      |> String.split("\n\n")

    draw =
      draw
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.flat_map(fn line -> String.split(line, ~r/\D+/, trim: true) end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(@length)
      |> Enum.chunk_every(@length)
      |> Enum.map(fn board ->
        Enum.reduce(board, {0, %{}}, fn line, {row, game} ->
          {row + 1,
           line
           |> Enum.with_index()
           |> Enum.into(game, fn {number, column} ->
             {number, {row, column}}
           end)}
        end)
        |> elem(1)
      end)

    {draw, boards}
  end
end
