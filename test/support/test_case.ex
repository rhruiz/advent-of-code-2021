defmodule TestCase do
  use ExUnit.CaseTemplate

  using do
    test_module = hd(__CALLER__.context_modules)

    code_module =
      test_module
      |> to_string()
      |> String.trim_trailing("Test")
      |> String.to_atom()

    day =
      test_module
      |> Module.split()
      |> List.last()
      |> String.trim_trailing("Test")
      |> String.trim_leading("Day")
      |> String.pad_leading(2, "0")

    quote do
      alias unquote(code_module).{First, Second}

      def input do
        "test/support/#{unquote(day)}/input.txt"
      end

      def test_input do
        "test/support/#{unquote(day)}/test_input.txt"
      end
    end
  end
end
