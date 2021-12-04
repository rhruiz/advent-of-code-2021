defmodule Aoc2021.Day4.Second do
  import Aoc2021.Day4.Bingo

  def run(file) do
    {drawn, boards} = input(file)

    last_winner(boards, drawn, [])
  end

  def last_winner([board], left, drawn) do
    draw(board, left, drawn)
  end

  def last_winner(boards, [number_drawn | left], drawn) do
    drawn = [number_drawn | drawn]

    case Enum.filter(boards, &won?(&1, drawn)) do
      [] ->
        last_winner(boards, left, drawn)

      winning_boards ->
        boards = MapSet.new(boards)
        boards_left = MapSet.difference(boards, MapSet.new(winning_boards))

        last_winner(MapSet.to_list(boards_left), left, drawn)
    end
  end

  def draw(board, [number_drawn | left], drawn) do
    drawn = [number_drawn | drawn]

    case won?(board, drawn) do
      true ->
        {board, drawn}

      false ->
        draw(board, left, drawn)
    end
  end
end
