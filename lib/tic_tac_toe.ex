defmodule TicTacToe.Game do
  @moduledoc """
  Documentation for `TicTacToe`.
  """

  @symbols [:x, :o]

  defstruct board: [
              nil, nil, nil,
              nil, nil, nil,
              nil, nil, nil
            ],
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
               |> winner
               |> next_turn
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

  def next_turn(%__MODULE__{next: :x} = game), do: %__MODULE__{game | next: :o}
  def next_turn(%__MODULE__{next: :o} = game), do: %__MODULE__{game | next: :x}

  def winner(%__MODULE__{} = game), do: %__MODULE__{game | winner: do_winner(game.board)}

  defp do_winner([
    s, s, s,
    _, _, _,
    _, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, _,
    s, s, s,
    _, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, _,
    _, _, _,
    s, s, s
  ]) when s in @symbols, do: s

  defp do_winner([
    s, _, _,
    s, _, _,
    s, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, s, _,
    _, s, _,
    _, s, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, s,
    _, _, s,
    _, _, s
  ]) when s in @symbols, do: s

  defp do_winner([
    s, _, _,
    _, s, _,
    _, _, s
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, s,
    _, s, _,
    s, _, _
  ]) when s in @symbols, do: s

  defp do_winner(_), do: nil
end
