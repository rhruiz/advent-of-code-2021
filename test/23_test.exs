defmodule Aoc2021.Day23Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 12521 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 18170 = First.run(input())
    end
  end

  describe "second star" do
    test "with test data" do
      assert 44169 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 50208 = Second.run(input())
    end
  end
end
