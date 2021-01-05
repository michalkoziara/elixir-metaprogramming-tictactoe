defmodule TicTacToe.BoardMatcher do
  defmacro __using__(_) do
    quote do
      import TicTacToe.BoardMatcher
    end
  end

  defmacro empty_board do
    quote do
      [
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ]
    end
  end

  defmacro match_row(var, 0) do
    quote do
        [
          unquote(var), unquote(var), unquote(var),
          _, _, _,
          _, _, _
        ]
    end
  end

  defmacro match_row(var, 1) do
    quote do
        [
          _, _, _,
          unquote(var), unquote(var), unquote(var),
          _, _, _
        ]
    end
  end

  defmacro match_row(var, 2) do
    quote do
        [
          _, _, _,
          _, _, _,
          unquote(var), unquote(var), unquote(var)
        ]
    end
  end

  defmacro match_col(var, 0) do
    quote do
      [
        unquote(var), unquote(var), unquote(var),
        _, _, _,
        _, _, _
      ]
    end
  end

  defmacro match_col(var, 1) do
    quote do
      [
        _, unquote(var), _,
        _, unquote(var), _,
        _, unquote(var), _
      ]
    end
  end

  defmacro match_col(var, 2) do
    quote do
      [
        _, _, unquote(var),
        _, _, unquote(var),
        _, _, unquote(var)
      ]
    end
  end

  defmacro match_diagonal(var, :left_to_right) do
    quote do
      [
        unquote(var), _, _,
        _, unquote(var), _,
        _, _, unquote(var)
      ]
    end
  end

  defmacro match_diagonal(var, :right_to_left) do
    quote do
      [
        _, _, unquote(var),
        _, unquote(var), _,
        unquote(var), _, _
      ]
    end
  end
end