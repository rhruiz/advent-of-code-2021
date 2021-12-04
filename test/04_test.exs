defmodule Aoc2021.Day4Test do
  use TestCase, async: true

  alias Aoc2021.Day4.Bingo

  describe "first star" do
    test "with test data" do
      assert {winner, number_drawn} = First.run(test_input())
      assert 4512 = Bingo.score(winner, number_drawn)
    end

    test "with puzzle data" do
      {winner, number_drawn} = First.run(input())
      assert 11774 = Bingo.score(winner, number_drawn)
    end
  end

  describe "second star" do
    test "with test data" do
      assert {azarao, number_drawn} = Second.run(test_input())
      assert 1924 = Bingo.score(azarao, number_drawn)
    end

    test "with puzzle data" do
      assert {azarao, number_drawn} = Second.run(input())
      assert 4495 = Bingo.score(azarao, number_drawn)
    end
  end
end
