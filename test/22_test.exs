defmodule Aoc2021.Day22Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 590_784 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 568_000 = First.run(input())
    end
  end
end
