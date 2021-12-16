defmodule Aoc2021.Day16.Second do
  alias Aoc2021.Day16.Parser
  alias Aoc2021.Day16.Executor

  def run(file) do
    file
    |> File.read!()
    |> Parser.parse()
    |> then(fn [code] -> Executor.execute(code) end)
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
