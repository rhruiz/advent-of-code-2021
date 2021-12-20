defmodule Aoc2021.Day20Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 35 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 5464 = First.run(input())
    end
  end
end
