class GameController < ApplicationController
  def create
    game = find_or_create_game(current_user)

    redirect_to game_path(game)
  end

  def show
    @game = find_game
    @player = find_player
  end

  def ready
    find_player.update! ready: true

    redirect_to game_path(find_game)
  end

  def not_ready
    find_player.update! ready: false

    redirect_to game_path(find_game)
  end

  private

  def find_game
    Game.find(params[:id] || params[:game_id])
  end

  def find_player
    find_game.players.where(user: current_user).first
  end

  def find_or_create_game(user)
    FindOrCreateGame.new(user: user).call
  end

  def find_or_create_player(game)
    FindOrCreatePlayer.new(game: game).call
  end
end
