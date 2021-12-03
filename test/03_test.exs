defmodule Aoc2021.Day3Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      {gamma, epsilon} = First.run(test_input())

      assert {22, 9} = {gamma, epsilon}
    end

    test "with puzzle data" do
      {x, y} = First.run(input())
      assert 2_967_914 == x * y
    end
  end

  describe "second star" do
    test "with test data" do
      assert {23, 10} == Second.run(test_input())
    end

    test "with puzzle data" do
      {oxygen, co2} = Second.run(input())

      assert 7_041_258 = oxygen * co2
    end
  end
end
