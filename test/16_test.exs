defmodule Aoc2021.Day16Test do
  use TestCase, async: true
  alias Aoc2021.Day16.Parser

  describe "parser" do
    test "sample packets" do
      assert [{6, 4, 2021}] = Parser.parse("D2FE28")
      assert [{1, 6, [{_, 4, 10}, {_, 4, 20}]}] = Parser.parse("38006F45291200")
      assert [{7, 3, [{_, 4, 1}, {_, 4, 2}, {_, 4, 3}]}] = Parser.parse("EE00D40C823060")
      assert [{4, _, [{1, _, [{5, _, [{6, 4, _}]}]}]}] = Parser.parse("8A004A801A8002F478")
    end
  end

  describe "first star" do
    test "version sums" do
      assert 16 = Parser.parse("8A004A801A8002F478") |> hd() |> First.version_sum()
      assert 12 = Parser.parse("620080001611562C8802118E34") |> hd() |> First.version_sum()
      assert 23 = Parser.parse("C0015000016115A2E0802F182340") |> hd() |> First.version_sum()
      assert 31 = Parser.parse("A0016C880162017C3686B18A3D4780") |> hd() |> First.version_sum()
    end

    test "with puzzle data" do
      assert 960 = First.run(input())
    end
  end
end
