defmodule Aoc2021.Day21Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 739_785 = First.run(4, 8)
    end

    test "with puzzle data" do
      assert 897_798 = First.run(1, 3)
    end
  end

  describe "second star" do
    test "with test data" do
      assert 444_356_092_776_315 = Second.run(4, 8)
    end

    test "with puzzle data" do
      assert 48_868_319_769_358 = Second.run(1, 3)
    end
  end
end
