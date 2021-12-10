defmodule Aoc2021.Day10.Second do
  @opening String.to_charlist("<[{(")
  @closing String.to_charlist(">]})")
  @closing_for @opening |> Enum.zip(@closing) |> Enum.into(%{})
  @score %{
    ?( => 1,
    ?[ => 2,
    ?{ => 3,
    ?< => 4
  }

  def run(file) do
    file
    |> input()
    |> Enum.flat_map(fn line ->
      case parse(line) do
        {:error, :incomplete, stack} ->
          [complete(stack, 0)]

        _other ->
          []
      end
    end)
    |> then(fn scores ->
      scores
      |> Enum.sort()
      |> Enum.drop(div(length(scores), 2))
      |> hd()
    end)
  end

  def complete([], score), do: score

  def complete([chr | stack], score) do
    complete(stack, score * 5 + @score[chr])
  end

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
