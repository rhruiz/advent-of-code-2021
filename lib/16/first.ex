defmodule Aoc2021.Day16.First do
  alias Aoc2021.Day16.Parser

  def run(file) do
    file
    |> File.read!()
    |> Parser.parse()
    |> Enum.reduce(0, fn packet, sum ->
      sum + version_sum(packet)
    end)
  end

  def version_sum({version, 4, _}) do
    version
  end

  def version_sum({version, _, subpackets}) do
    Enum.reduce(subpackets, version, fn subpacket, sum ->
      sum + version_sum(subpacket)
    end)
  end
end
