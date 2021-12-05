defmodule Aoc2021.Day5Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 5 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 3990 = First.run(input())
    end
  end
end
