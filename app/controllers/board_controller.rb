class BoardController < ApplicationController
  before_filter :authenticate

  def show
    @game = find_game
    @board = find_board
    @guesses = find_guesses
    @player = find_player
  end

  def submit
    guesses = params[:guesses]

    SubmitGuesses.new(player: find_player, board: find_board, guesses: guesses).call

    redirect_to game_board_path(find_game, find_board)
  end

  private

  def find_game
    @find_game ||= Game.find(params[:game_id])
  end

  def find_board
    @find_board ||= find_game.boards.find(params[:id] || params[:board_id])
  end

  def find_player
    @find_player ||= find_game.players.where(user: current_user).first!
  end

  def find_guesses
    @find_guesses ||= find_board.guesses.where(player: find_player)
  end

end
