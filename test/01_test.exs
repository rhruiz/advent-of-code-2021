defmodule Aoc2021.Day1Test do
  use ExUnit.Case, async: true

  describe "first star" do
    test "with test data" do
      assert 7 = Aoc2021.Day1.First.run("test/support/01/test_input.txt")
    end

    test "with puzzle data" do
      assert 1715 = Aoc2021.Day1.First.run("test/support/01/input.txt")
    end
  end

  describe "second star" do
    test "with test data" do
      assert 5 = Aoc2021.Day1.Second.run("test/support/01/test_input.txt")
    end

    test "with puzzle data" do
      assert 1739 = Aoc2021.Day1.Second.run("test/support/01/input.txt")
    end
  end

  describe "second star (with streams)" do
    test "with test data" do
      assert 5 = Aoc2021.Day1.Second.as_streams("test/support/01/test_input.txt")
    end

    test "with puzzle data" do
      assert 1739 = Aoc2021.Day1.Second.as_streams("test/support/01/input.txt")
    end
  end
end
