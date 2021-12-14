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
      assert 2_188_189_693_529 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 1_976_896_901_756 = Second.run(input())
    end
  end
end
