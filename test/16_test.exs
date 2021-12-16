defmodule Aoc2021.Day16Test do
  use TestCase, async: true
  alias Aoc2021.Day16.Parser
  alias Aoc2021.Day16.Executor

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

  describe "second star" do
    test "packet calculations" do
      assert 3 = Parser.parse("C200B40A82") |> hd() |> Executor.execute()
      assert 54 = Parser.parse("04005AC33890") |> hd() |> Executor.execute()
      assert 7 = Parser.parse("880086C3E88112") |> hd() |> Executor.execute()
      assert 9 = Parser.parse("CE00C43D881120") |> hd() |> Executor.execute()
      assert 1 = Parser.parse("D8005AC2A8F0") |> hd() |> Executor.execute()
      assert 0 = Parser.parse("F600BC2D8F") |> hd() |> Executor.execute()
      assert 0 = Parser.parse("9C005AC2F8F0") |> hd() |> Executor.execute()
      assert 1 = Parser.parse("9C0141080250320F1802104A08") |> hd() |> Executor.execute()
    end

    test "with puzzle data" do
      assert 12_301_926_782_560 = Second.run("./test/support/16/input.txt")
    end
  end
end
