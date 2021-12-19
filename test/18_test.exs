defmodule Aoc2021.Day18Test do
  use TestCase, async: true

  describe "reduce" do
    test "samples" do
      assert [[[[0, 9], 2], 3], 4] = First.reduce([[[[[9, 8], 1], 2], 3], 4])
      assert [7, [6, [5, [7, 0]]]] = First.reduce([7, [6, [5, [4, [3, 2]]]]])
      assert [[6, [5, [7, 0]]], 3] = First.reduce([[6, [5, [4, [3, 2]]]], 1])

      assert [[3, [2, [8, 0]]], [9, [5, [7, 0]]]] =
               First.reduce([[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]])

      assert [[3, [2, [8, 0]]], [9, [5, [7, 0]]]] =
               First.reduce([[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]])
    end
  end

  describe "split" do
    test "samples" do
      assert [5, 5] = First.split(10)
      assert [5, 6] = First.split(11)
      assert [6, 6] = First.split(12)
    end

    test "first homework sample" do
      pairs = [
        [1, 1],
        [2, 2],
        [3, 3],
        [4, 4]
      ]

      assert [[[[1, 1], [2, 2]], [3, 3]], [4, 4]] =
               Enum.reduce(pairs, fn number, sum -> First.sum(sum, number) end)
    end

    test "larger homework sample" do
      numbers = [
        [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]],
        [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]],
        [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]],
        [[[[2, 4], 7], [6, [0, 5]]], [[[6, 8], [2, 8]], [[2, 1], [4, 5]]]],
        [7, [5, [[3, 8], [1, 4]]]],
        [[2, [2, 2]], [8, [8, 1]]],
        [2, 9],
        [1, [[[9, 3], 9], [[9, 0], [0, 7]]]],
        [[[5, [7, 4]], 7], 1],
        [[[[4, 2], 2], 6], [8, 7]]
      ]

      assert [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]] =
               Enum.reduce(numbers, fn number, sum ->
                 First.sum(sum, number)
               end)
    end
  end

  describe "sum" do
    test "samples" do
      assert [[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]] =
               First.sum([[[[4, 3], 4], 4], [7, [[8, 4], 9]]], [1, 1])
    end
  end

  describe "magnitude" do
    test "samples" do
      assert 143 = First.magnitude([[1, 2], [[3, 4], 5]])
      assert 1384 = First.magnitude([[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]])
      assert 445 = First.magnitude([[[[1, 1], [2, 2]], [3, 3]], [4, 4]])
      assert 791 = First.magnitude([[[[3, 0], [5, 3]], [4, 4]], [5, 5]])
      assert 1137 = First.magnitude([[[[5, 0], [7, 4]], [5, 5]], [6, 6]])

      assert 3488 =
               First.magnitude([[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]])
    end
  end

  describe "first star" do
    test "with sample data" do
      assert 4140 = First.run(test_input())
    end

    test "with puzzle data" do
      assert 3793 = First.run(input())
    end
  end

  describe "second star" do
    test "with sample data" do
      assert 3993 = Second.run(test_input())
    end

    test "with puzzle data" do
      assert 4695 = Second.run(input())
    end
  end
end
