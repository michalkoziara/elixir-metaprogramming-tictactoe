defmodule TicTacToe.CLI do
  use TicTacToe.Terminal

  alias TicTacToe.Game

  def main(_args) do
    output "Welcome to the Tic-Tac-Toe game!"
    print_help_message()

    output "\nNew game started!"
    game = %Game{}
    print_player_turn(game)
    print_board(game)

    receive_command(game)
  end

  @commands %{
    "place" =>
      "format: \"place X, Y\". " <>
      "Places the mark into coordinates (X, Y).",
    "quit" => "Quits the simulator."
  }

  defp receive_command(game) do
    input do
      String.split(" ")
      |> execute_command(game)
    end
  end

  defp execute_command(["quit"], game) do
    output "\nAre you sure? Y/N"

    input do
      execute_exit_command(game)
    end
  end

  defp execute_command(["place" | params], game) when params != nil do
    {x, y} = process_place_params(params)

    case Game.place(game, x, y) do
      {:ok, game} ->
        print_board(game)

        case game.winner do
          x when x != nil -> print_winner(game)
          _ ->
            print_player_turn(game)
            receive_command(game)
        end

      {:failure, message} ->
        output message
        receive_command(game)
    end
  end

  defp execute_command(_unknown, game) do
    output "\nInvalid command. I don't know what to do."
    print_help_message()

    receive_command(game)
  end

  defp process_place_params(params) do
    [x, y] =
      params
      |> Enum.join("")
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    {String.to_integer(x), String.to_integer(y)}
  end

  defp print_player_turn(game) do
    output "Player #{game.next} turn."
  end

  defp print_board(%Game{} = game) do
    output "| - - - |"
    print_board(game.board)
  end

  defp print_board(board) when board != [] do
    {printed_board, remaining_board} = Enum.split(board, 3)
    printed_board = printed_board
                    |> Enum.map(
                         fn
                           nil -> "*"
                           other -> other
                         end
                       )
                    |> Enum.join(" ")
                    |> String.split(",")

    output "| #{printed_board} |"
    print_board(remaining_board)
  end

  defp print_board(_board) do
    output "| - - - |"
  end

  defp print_winner(game) do
    output "Player #{game.winner} won!!"
  end

  defp print_help_message do
    output "\nThe game supports following commands:\n"

    @commands
    |> Enum.map(fn {command, description} -> output "  #{command} - #{description}" end)
  end

  defp execute_exit_command("y", _game), do: output "Bye!"
  defp execute_exit_command("n", game), do: receive_command(game)
  defp execute_exit_command(any, game), do: execute_command(any, game)
end
