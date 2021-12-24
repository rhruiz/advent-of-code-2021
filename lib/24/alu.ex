defmodule Aoc2021.Day24.ALU do
  @derive {Inspect, except: [:instructions]}
  defstruct [:instructions, w: 0, x: 0, y: 0, z: 0]

  def parse(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn [op | args] ->
      [String.to_atom(op) | args]
    end)
    |> new()
  end

  def new(instructions) do
    %__MODULE__{instructions: instructions}
  end

  def run(alu, input) do
    alu.instructions
    |> Enum.reduce({alu, input}, fn
      instruction, {alu, input} ->
        apply(__MODULE__, :exec, [alu, input | instruction])

      _instruction, :boom ->
        :boom
    end)
    |> then(fn
      {alu, []} -> alu
      {_alu, _input} -> :boom
      :boom -> :boom
    end)
  end

  def exec(_alu, [], :inp, _var) do
    :boom
  end

  def exec(alu, [input | tail], :inp, var) do
    {write(alu, var, input), tail}
  end

  def exec(alu, input, :add, a, b) do
    b = value_or_register(alu, b)
    va = read(alu, a)

    {write(alu, a, va + b), input}
  end

  def exec(alu, input, :mul, a, b) do
    b = value_or_register(alu, b)
    va = read(alu, a)

    {write(alu, a, va * b), input}
  end

  def exec(alu, input, :div, a, b) do
    b = value_or_register(alu, b)
    va = read(alu, a)

    if b == 0 do
      :boom
    else
      {write(alu, a, div(va, b)), input}
    end
  end

  def exec(alu, input, :mod, a, b) do
    b = value_or_register(alu, b)
    va = read(alu, a)

    if a < 0 or b <= 0 do
      :boom
    else
      {write(alu, a, rem(va, b)), input}
    end
  end

  def exec(alu, input, :eql, a, b) do
    b = value_or_register(alu, b)
    va = read(alu, a)

    eql = if(va == b, do: 1, else: 0)

    {write(alu, a, eql), input}
  end

  # "private"
  def read(alu, register) when is_atom(register) do
    Map.get(alu, register)
  end

  def read(alu, register) do
    read(alu, String.to_atom(register))
  end

  def write(alu, register, value) when is_binary(value) do
    Map.put(alu, String.to_atom(register), String.to_integer(value))
  end

  def write(alu, register, value) do
    Map.put(alu, String.to_atom(register), value)
  end

  def value_or_register(alu, register) when register in ~w[w x y z] do
    read(alu, register)
  end

  def value_or_register(_alu, value) do
    String.to_integer(value)
  end
end
