defmodule Aoc2021.Day24Test do
  use TestCase, async: true
  alias Aoc2021.Day24.ALU

  describe "ALU" do
    test "first sample" do
      alu =
        ALU.parse("""
        inp x
        mul x -1
        """)

      assert 5 = alu |> ALU.run(["-5"]) |> ALU.read(:x)
    end

    test "second sample" do
      alu =
        ALU.parse("""
        inp z
        inp x
        mul z 3
        eql z x
        """)

      assert 1 = alu |> ALU.run(["10", "30"]) |> ALU.read(:z)
      assert 0 = alu |> ALU.run(["0", "5"]) |> ALU.read(:z)
    end

    test "third sample" do
      alu =
        ALU.parse("""
        inp w
        add z w
        mod z 2
        div w 2
        add y w
        mod y 2
        div w 2
        add x w
        mod x 2
        div w 2
        mod w 2
        """)

      for w <- 0..1, x <- 0..1, y <- 0..1, z <- 0..1 do
        assert [^w, ^x, ^y, ^z] =
                 alu
                 |> ALU.run([Integer.undigits([w, x, y, z], 2)])
                 |> Map.take([:w, :x, :y, :z])
                 |> Map.values()
      end
    end
  end

  test "first and second star" do
    {min, max} = First.run(input())

    alu =
      input()
      |> File.read!()
      |> ALU.parse()

    assert 0 = alu |> ALU.run(Integer.digits(min)) |> ALU.read(:z)
    assert 0 = alu |> ALU.run(Integer.digits(max)) |> ALU.read(:z)
    assert {92_171_126_131_911, 99_394_899_891_971} = {min, max}
  end
end
