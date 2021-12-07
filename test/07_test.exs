defmodule Aoc2021.Day7Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 37 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 336_701 = First.run(input())
    end
  end

  describe "second star" do
    test "with test data" do
      assert 168.0 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 95_167_302.0 = Second.run(input())
    end
  end
end
