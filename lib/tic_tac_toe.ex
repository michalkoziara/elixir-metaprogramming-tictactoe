defmodule TicTacToe.Game do
  use TicTacToe.BoardMatcher

  @moduledoc """
  Documentation for `TicTacToe`.
  """

  @symbols [:x, :o]

  defstruct board: empty_board,
            next: :x,
            winner: nil

  def place(%__MODULE__{} = game, pos_x, pos_y)
      when pos_x >= 0 and pos_x <= 2
           and pos_y >= 0 and pos_y <= 2
    do
    position = pos_x + pos_y * 3
    case Enum.at(game.board, position) do
      nil -> updated_game =
               %__MODULE__{game | board: List.replace_at(game.board, position, game.next)}
               |> get_winner
               |> get_next_turn
             {:ok, updated_game}

      existent_symbol ->
        {
          :failure,
          "The position: (#{pos_x}, #{pos_y}) already has the symbol: #{existent_symbol}"
        }
    end
  end

  def place(_game, _pos_x, _pos_y) do
    error_message =
      "You passed wrong position. Check if you are passing positions between 0 and 2."

    {:failure, error_message}
  end

  def get_next_turn(%__MODULE__{next: :x} = game), do: %__MODULE__{game | next: :o}
  def get_next_turn(%__MODULE__{next: :o} = game), do: %__MODULE__{game | next: :x}

  def get_winner(%__MODULE__{} = game), do: %__MODULE__{game | winner: check_winner(game.board)}

  defp check_winner(match_row s, 0) when s in @symbols, do: s
  defp check_winner(match_row s, 1) when s in @symbols, do: s
  defp check_winner(match_row s, 2) when s in @symbols, do: s

  defp check_winner(match_col s, 0) when s in @symbols, do: s
  defp check_winner(match_col s, 1) when s in @symbols, do: s
  defp check_winner(match_col s, 2) when s in @symbols, do: s

  defp check_winner(match_diagonal s, :left_to_right) when s in @symbols, do: s
  defp check_winner(match_diagonal s, :right_to_left) when s in @symbols, do: s

  defp check_winner(_), do: nil
end
