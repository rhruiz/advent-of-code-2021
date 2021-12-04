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
    boards = Enum.map(boards, &(update(&1, number_drawn)))

    case Enum.filter(boards, &won?(&1, [number_drawn | drawn])) do
      [] ->
        last_winner(boards, left, [number_drawn | drawn])

      winning_boards ->
        boards = MapSet.new(boards)
        boards_left = MapSet.difference(boards, MapSet.new(winning_boards))

        last_winner(MapSet.to_list(boards_left), left, [number_drawn | drawn])
    end
  end

  def draw(board, [number_drawn | left], drawn) do
    board = update(board, number_drawn)

    case won?(board, [number_drawn | drawn]) do
      true ->
        {board, number_drawn}
      false ->
        draw(board, left, [number_drawn | drawn])
    end
  end
end
