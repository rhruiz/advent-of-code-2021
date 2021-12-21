defmodule Aoc2021.Day21.First do
  def run(p1, p2) do
    die = Stream.iterate(1, &(&1 + 1))
    casts = Stream.chunk_every(die, 3, 3)
    players = Stream.cycle([0, 1])

    players
    |> Stream.zip(casts)
    |> Stream.transform({{0, p1}, {0, p2}, 0}, fn {player, cast}, game ->
      movement = Enum.reduce(cast, 0, &Kernel.+/2)

      game
      |> update_in([Access.elem(player)], fn {score, position} ->
        position = rem(position - 1 + movement, 10) + 1
        {score + position, position}
      end)
      |> update_in([Access.elem(2)], fn casts -> casts + 3 end)
      |> then(fn game -> {[game], game} end)
    end)
    |> Enum.find(fn {{s1, _}, {s2, _}, _} -> s1 >= 1000 || s2 >= 1000 end)
    |> then(fn {{score1, _}, {score2, _}, casts} ->
      casts * min(score1, score2)
    end)
  end
end
