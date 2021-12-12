defmodule Aoc2021.Day12Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 10 = First.run("test/support/12/simple_test_input.txt")
      assert 19 = First.run(test_input())
      assert 226 = First.run("test/support/12/other_test_input.txt")
    end

    test "with puzzle data" do
      assert 5874 = First.run(input())
    end
  end
end

