defmodule Aoc2021.Day9Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 15 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 577 = First.run(input())
    end
  end
end
