class GameController < ApplicationController
  def create
    game = find_or_create_game(current_user)

    redirect_to game_path(game)
  end

  def show
    @game = find_game
  end

  private

  def find_game
    Game.find(params[:id])
  end

  def find_or_create_game
    FindOrCreateGame.new.call
  end

  def find_or_create_player(game)
    FindOrCreatePlayer.new(game: game).call
  end
end
