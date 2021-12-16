defmodule Aoc2021.Day16.Parser do
  use Bitwise
  use Aoc2021.Day16.LeftOver

  @literal 4

  def parse(string) when is_binary(string) do
    for <<chr::binary-size(2) <- string>>, into: <<>> do
      :binary.decode_hex(chr)
    end
    |> parse([])
  end

  def parse(bits) when is_bitstring(bits) do
    parse(bits, [])
  end

  def parse(bits) do
    parse(bits, [])
  end

  def parse(<<>>, packets) do
    Enum.reverse(packets)
  end

  def parse(bits, packets) do
    {packet, tail} = parse_one(bits)

    parse(tail, [packet | packets])
  end

  def parse_one(<<version::size(3), id::size(3), tail::bits>>) do
    {packet, tail} = parse_packet(id, tail)

    {{version, id, packet}, tail}
  end

  def parse_packet(@literal, tail) do
    parse_literal(tail, 0)
  end

  def parse_packet(_operator, tail) do
    parse_operator(tail)
  end

  def parse_literal(<<1::1, number_part::1*4, tail::bits>>, number) do
    parse_literal(tail, (number <<< 4) ||| number_part)
  end

  def parse_literal(<<0::1, number_part::1*4, tail::bits>>, number) do
    {(number <<< 4) ||| number_part, tail}
  end

  def parse_operator(<<0::1, subpacket_length::15*1, tail::bits>>) do
    <<subpacket_input::bits-size(subpacket_length), tail::bits>> = tail
    subpackets = parse(subpacket_input, [])

    {subpackets, tail}
  end

  def parse_operator(<<1::1, subpackets::11*1, tail::bits>>) do
    {packets, tail} =
      Enum.reduce(1..subpackets, {[], tail}, fn _step, {packets, tail} ->
        {packet, tail} = parse_one(tail)

        {[packet | packets], tail}
      end)

    {Enum.reverse(packets), tail}
  end
end
