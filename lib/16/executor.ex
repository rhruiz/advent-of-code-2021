defmodule Aoc2021.Day16.Executor do
  def execute({_, 4, number}), do: number

  def execute({_, 0, subpackets}) do
    exec_op(subpackets, 0, &Kernel.+/2)
  end

  def execute({_, 1, subpackets}) do
    exec_op(subpackets, 1, &Kernel.*/2)
  end

  def execute({_, 2, subpackets}) do
    exec_op(subpackets, nil, &min/2)
  end

  def execute({_, 3, subpackets}) do
    exec_op(subpackets, nil, fn
      a, nil -> a
      nil, b -> b
      a, b -> max(a, b)
    end)
  end

  def execute({_, 5, [a, b]}) do
    if(execute(a) > execute(b), do: 1, else: 0)
  end

  def execute({_, 6, [a, b]}) do
    if(execute(a) < execute(b), do: 1, else: 0)
  end

  def execute({_, 7, [a, b]}) do
    if(execute(a) == execute(b), do: 1, else: 0)
  end

  defp exec_op(subpackets, initial, fun) do
    Enum.reduce(subpackets, initial, fn packet, acc ->
      fun.(acc, execute(packet))
    end)
  end
end
