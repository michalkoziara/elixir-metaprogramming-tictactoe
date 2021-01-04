defmodule TicTacToe.CLI do

  alias TicTacToe.Game

  def main(_args) do
    IO.puts("Welcome to the Tic-Tac-Toe game!")
    print_help_message()

    IO.puts("\nNew game started!")
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

  defp receive_command(%Game{} = game) do
    IO.gets("\n> ")
    |> String.trim()
    |> String.downcase()
    |> String.split(" ")
    |> execute_command(game)
  end

  defp execute_command(["quit"], %Game{} = game) do
    IO.puts("\nAre you sure? Y/N")

    IO.gets("\n> ")
    |> String.trim()
    |> String.downcase()
    |> execute_exit_command(game)
  end

  defp execute_command(["place" | params], %Game{} = game) when params != nil do
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
        IO.puts(message)
        receive_command(game)
    end
  end

  defp execute_command(_unknown, %Game{} = game) do
    IO.puts("\nInvalid command. I don't know what to do.")
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

  defp print_player_turn(%Game{} = game) do
    IO.puts("Player #{game.next} turn.")
  end

  defp print_board(%Game{} = game) when not is_list(game) do
    IO.puts("| - - - |")
    print_board(game.board)
  end

  defp print_board(board) when is_list(board) and board != [] do
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

    IO.puts("| #{printed_board} |")

    print_board(remaining_board)
  end

  defp print_board(_board) do
    IO.puts("| - - - |")
  end

  defp print_winner(game) do
    IO.puts("Player #{game.winner} won!!")
  end

  defp print_help_message do
    IO.puts("\nThe game supports following commands:\n")

    @commands
    |> Enum.map(fn {command, description} -> IO.puts("  #{command} - #{description}") end)
  end

  defp execute_exit_command("y", _game), do: IO.puts("Bye!")
  defp execute_exit_command("n", %Game{} = game), do: receive_command(game)
  defp execute_exit_command(any, %Game{} = game), do: execute_command(any, game)
end
