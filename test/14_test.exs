defmodule Aoc2021.Day14Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 1588 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 2375 = First.run(input())
    end
  end

  describe "second star" do
    test "with test data" do
      assert 2188189693529 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 2188189693529 = Second.run(input())
    end
  end
end
