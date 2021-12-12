defmodule Aoc2021.Day11Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 1656 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 1608 = First.run(input())
    end
  end

  describe "second star" do
    test "with test data" do
      assert 195 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 214 = Second.run(input())
    end
  end
end
