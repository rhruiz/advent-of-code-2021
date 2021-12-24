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

  describe "second star" do
    test "with test data" do
      assert 2_758_514_936_282_235 = Second.run("test/support/22/big_test_input.txt")
    end

    test "with puzzle data" do
      assert 1_177_411_289_280_259 = Second.run(input())
    end
  end
end
