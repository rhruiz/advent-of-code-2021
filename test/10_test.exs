defmodule Aoc2021.Day10Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 26_397 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 323_691 = First.run(input())
    end
  end

  describe "second star" do
    test "with test data" do
      assert 288_957 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 2_858_785_164 = Second.run(input())
    end
  end
end
