defmodule Aoc2021.Day6Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 26 = Enum.count(First.run(test_input(), 18))
      assert 5934 = Enum.count(First.run(test_input(), 80))
    end

    test "with puzzle data" do
      assert 380_612 = Enum.count(First.run(input(), 80))
    end
  end

  describe "second star" do
    test "with test data" do
      assert 26 = Second.run(test_input(), 18)
      assert 5934 = Second.run(test_input(), 80)
      assert 26_984_457_539 = Second.run(test_input(), 256)
    end

    test "with puzzle data" do
      assert 1_710_166_656_900 = Second.run(input(), 256)
    end
  end
end
