defmodule Aoc2021.Day21.Second do
  def run(p1, p2) do
    prime_universe = {{p1, 0}, {p2, 0}, 0}
    leaderboard = {0, 0}
    queue = %{prime_universe => 1}

    {queue, leaderboard}
    |> Stream.iterate(fn {queue, leaderboard} ->
      for {universe, replicas} <- queue,
          c1 <- 1..3,
          c2 <- 1..3,
          c3 <- 1..3,
          reduce: {%{}, leaderboard} do
        {queue, {v1, v2}} ->
          case play(universe, c1 + c2 + c3) do
            {{_, s1}, _, _} when s1 >= 21 -> {queue, {v1 + replicas, v2}}
            {_, {_, s2}, _} when s2 >= 21 -> {queue, {v1, v2 + replicas}}
            universe -> {Map.update(queue, universe, replicas, &(&1 + replicas)), {v1, v2}}
          end
      end
    end)
    |> Enum.find(&match?({queue, _} when map_size(queue) == 0, &1))
    |> then(fn {_, {v1, v2}} -> max(v1, v2) end)
  end

  def play({_, _, player} = universe, movement) do
    universe
    |> update_in([Access.elem(player)], fn {position, score} ->
      position = rem(position - 1 + movement, 10) + 1
      {position, score + position}
    end)
    |> update_in([Access.elem(2)], fn player -> rem(player + 1, 2) end)
  end
end
