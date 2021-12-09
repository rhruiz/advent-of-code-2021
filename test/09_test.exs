defmodule Aoc2021.Day9Test do
  use TestCase, async: true

  describe "first star" do
    test "with test data" do
      assert 15 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 577 = First.run(input())
    end
  end

  describe "second star" do
    test "with test data" do
      assert 1134 =
               test_input()
               |> Second.run()
               |> Enum.sort()
               |> Enum.reverse()
               |> Enum.take(3)
               |> Enum.reduce(&Kernel.*/2)
    end

    test "with puzzle data" do
      assert 1_069_200 =
               input()
               |> Second.run()
               |> Enum.sort()
               |> Enum.reverse()
               |> Enum.take(3)
               |> Enum.reduce(&Kernel.*/2)
    end
  end
end
