defmodule Aoc2021.Day4.First do
  import Aoc2021.Day4.Bingo

  def run(file) do
    {drawn, boards} = input(file)

    draw(boards, drawn)
  end

  def draw(boards, drawn) do
    draw(boards, drawn, [])
  end

  def draw(boards, [number_drawn | left], drawn) do
    case Enum.filter(boards, &won?(&1, [number_drawn | drawn])) do
      [winner] ->
        {winner, [number_drawn | drawn]}

      _ ->
        draw(boards, left, [number_drawn | drawn])
    end
  end
end
