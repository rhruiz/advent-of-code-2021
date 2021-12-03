defmodule Aoc2021.Day2Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      {x, y} = First.run(test_input())
      assert 150 == x * y
    end

    test "with puzzle data" do
      {x, y} = First.run(input())
      assert 1_855_814 == x * y
    end
  end

  describe "second star" do
    test "with test data" do
      {x, y} = Second.run(test_input())
      assert 900 == x * y
    end

    test "with puzzle data" do
      {x, y} = Second.run(input())
      assert 1_845_455_714 == x * y
    end
  end
end
