defmodule Aoc2021.Day2Test do
  use ExUnit.Case, async: true

  describe "first star" do
    test "with test data" do
      {x, y} = Aoc2021.Day2.First.run("test/support/02/test_input.txt")
      assert 150 == x * y
    end

    test "with puzzle data" do
      {x, y} = Aoc2021.Day2.First.run("test/support/02/input.txt")
      assert 1855814 == x * y
    end
  end

  describe "second star" do
    test "with test data" do
      {x, y} = Aoc2021.Day2.Second.run("test/support/02/test_input.txt")
      assert 900 == x * y
    end

    test "with puzzle data" do
      {x, y} = Aoc2021.Day2.Second.run("test/support/02/input.txt")
      assert 1845455714 == x * y
    end
  end
end
