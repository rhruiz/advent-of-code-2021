defmodule Aoc2021.Day13Test do
  use TestCase, async: true
  import ExUnit.CaptureIO

  describe "first star" do
    test "with test data" do
      assert 17 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 802 = First.run(input())
    end
  end

  describe "second star" do
    test "with test data" do
      assert """
             # # # # #
             # . . . #
             # . . . #
             # . . . #
             # # # # #
             . . . . .
             . . . . .
             """ = capture_io(fn -> Second.run(test_input()) end)
    end

    test "with puzzle data" do
      assert """
             # # # . . # . . # . # . . # . # # # # . # # # # . . # # . . # . . # . # # # . .
             # . . # . # . # . . # . . # . # . . . . . . . # . # . . # . # . . # . # . . # .
             # . . # . # # . . . # # # # . # # # . . . . # . . # . . . . # . . # . # # # . .
             # # # . . # . # . . # . . # . # . . . . . # . . . # . # # . # . . # . # . . # .
             # . # . . # . # . . # . . # . # . . . . # . . . . # . . # . # . . # . # . . # .
             # . . # . # . . # . # . . # . # . . . . # # # # . . # # # . . # # . . # # # . .
             """ = capture_io(fn -> Second.run(input()) end)
    end
  end
end
