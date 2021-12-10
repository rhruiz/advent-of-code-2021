defmodule Aoc2021.Day10Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 26397 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 323691 = First.run(input())
    end
  end

#   describe "second star" do
#     test "with test data" do
#       assert 61229 = Enum.sum(Second.run(test_input()))
#     end

#     test "with puzzle data" do
#       assert 1_091_609 = Enum.sum(Second.run(input()))
#     end
#   end
end
