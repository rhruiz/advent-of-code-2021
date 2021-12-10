defmodule Aoc2021.Day10.Parser do
  @opening '<[{('
  @closing '>]})'
  @closing_for @opening |> Enum.zip(@closing) |> Enum.into(%{})

  def parse(line) do
    parse([], line)
  end

  def parse(stack, []) when hd(stack) != nil do
    {:error, :incomplete, stack}
  end

  def parse(stack, [chr | tail]) when chr in @opening do
    parse([chr | stack], tail)
  end

  def parse([opening | stack], [chr | tail]) when chr in @closing do
    case @closing_for[opening] do
      ^chr -> parse(stack, tail)
      _other -> {:error, :corrupted, chr}
    end
  end

  def input(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_charlist/1)
  end
end
