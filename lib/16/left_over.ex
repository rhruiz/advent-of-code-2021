defmodule Aoc2021.Day16.LeftOver do
  defmacro __using__(_opts \\ []) do
    for n <- 1..7 do
      quote do
        def parse(<<_trailing::bits-size(unquote(n))>>, packets) do
          Enum.reverse(packets)
        end
      end
    end
  end
end
