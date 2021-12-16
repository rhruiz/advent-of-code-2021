defmodule Aoc2021.Day15Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 40 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 748 = First.run(input())
    end
  end

  describe "second star" do
    test "expand with test data" do
      {map, {xmax, ymax}} = Second.input(test_input())
      {map, {xmax, ymax}} = Second.expand(map, {xmax, ymax})

      assert {map, {xmax, ymax}} == Second.input("test/support/15/big_test_input.txt")
    end

    test "with test data" do
      assert 315 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 3045 = Second.run(input())
    end
  end
end
