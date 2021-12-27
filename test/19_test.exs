defmodule Aoc2021.Day19Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 79 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 394 = First.run(input())
    end
  end
end
