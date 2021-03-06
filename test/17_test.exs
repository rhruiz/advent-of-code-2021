defmodule Aoc2021.Day17Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 45 = First.run(20..30, -10..-5)
    end

    test "with puzzle data" do
      assert 4560 = First.run(288..330, -96..-50)
    end
  end

  describe "second star" do
    test "with test data" do
      assert 112 = Second.run(20..30, -10..-5)
    end

    test "with puzzle data" do
      assert 3344 = Second.run(288..330, -96..-50)
    end
  end
end
