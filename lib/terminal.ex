defmodule TicTacToe.Terminal do
  defmacro __using__(_) do
    quote do
      defmacro input(do: block) do
        quote do
          IO.gets("\n> ")
          |> String.trim()
          |> String.downcase()
          |> unquote(block)
        end
      end

      defmacro output(expr) do
        quote do
          IO.puts(unquote(expr))
        end
      end
    end
  end
end
