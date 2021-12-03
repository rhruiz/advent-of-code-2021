defmodule Aoc2021.Day1Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 7 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 1715 = First.run(input())
    end
  end

  describe "first star (without reduce)" do
    test "with test data" do
      assert 7 = First.no_reduce(test_input())
    end

    test "with puzzle data" do
      assert 1715 = First.no_reduce(input())
    end
  end

  describe "second star" do
    test "with test data" do
      assert 5 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 1739 = Second.run(input())
    end
  end

  describe "second star (with streams)" do
    test "with test data" do
      assert 5 = Second.as_streams(test_input())
    end

    test "with puzzle data" do
      assert 1739 = Second.as_streams(input())
    end
  end
end
