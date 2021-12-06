defmodule Aoc2021.Day6Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 26 = Enum.count(First.run(test_input(), 18))
      assert 5934 = Enum.count(First.run(test_input(), 80))
    end

    test "with puzzle data" do
      assert 380612 = Enum.count(First.run(input(), 80))
    end
  end
end
