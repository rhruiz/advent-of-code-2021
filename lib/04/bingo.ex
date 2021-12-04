defmodule Aoc2021.Day4.Bingo do
  @length 5

  def update(board, number_drawn) do
    if Map.has_key?(board, number_drawn) do
      Map.update!(board, number_drawn, fn {row, col, _} ->
        {row, col, true}
      end)
    else
      board
    end
  end

  def score(board, number_drawn) do
    board
    |> Enum.reduce(0, fn
      {number, {_, _, false}}, score -> score + number
      _, score -> score
    end)
    |> Kernel.*(number_drawn)
  end

  def won?(board, drawn) do
    marked =
      drawn
      |> Enum.flat_map(fn number ->
        if Map.has_key?(board, number) && elem(board[number], 2) do
          [board[number]]
        else
          []
        end
      end)

    any = fn index_fn ->
      marked
      |> Enum.group_by(index_fn, fn {_, _, drawn} -> drawn end)
      |> Enum.any?(fn {_, drawn} -> Enum.count(drawn, &(&1)) == @length end)
    end

    any.(fn {row, _, _} -> row end) || any.(fn {_, col, _} -> col end)
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
             {number, {row, column, false}}
           end)}
        end)
        |> elem(1)
      end)

    {draw, boards}
  end
end
