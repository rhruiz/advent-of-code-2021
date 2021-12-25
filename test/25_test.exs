defmodule Aoc2021.Day25Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 58 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 334 = First.run(input())
    end
  end
end
