defmodule Aoc2021.Day17Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 45 = First.run(19..30, -10..-5)
    end

    test "with puzzle data" do
      assert 4560 = First.run(288..330, -96..-50)
    end
  end
end
