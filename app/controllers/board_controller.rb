class BoardController < ApplicationController
  def show
    @game = find_game
    @board = find_board
    @guesses = find_guesses
  end

  def submit
    guesses = params[:guesses]

    SubmitGuesses.new(player: find_player, board: find_board, guesses: guesses).call

    redirect_to game_path(find_game)
  end

  private

  def find_game
    Game.find(params[:game_id])
  end

  def find_board
    find_game.boards.find(params[:board_id] || params[:id])
  end

  def find_player
    find_game.players.where(user: current_user).first!
  end

  def find_guesses
    find_board.guesses.where(player: find_player)
  end

end
