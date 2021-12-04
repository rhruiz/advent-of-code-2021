defmodule Aoc2021.Day4Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert {winner, number_drawn} = First.run(test_input())
      assert 4512 = First.score(winner, number_drawn)
    end

    test "with puzzle data" do
      {winner, number_drawn} = First.run(input())
      assert 11774 = First.score(winner, number_drawn)
    end
  end
end
