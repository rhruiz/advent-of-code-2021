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

  describe "second star" do
    test "with test data" do
      assert 3351 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 19228 = Second.run(input())
    end
  end
end
