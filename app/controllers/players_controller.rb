class PlayersController < ApplicationController
  def kick
    game = find_game
    player = find_player

    KickPlayer.new(game: game, player: player).call

    redirect_to game_path(game)
  end

  def find_game
    Game.find(params[:game_id])
  end

  def find_player
    find_game.players.where(id: params[:player_id]).first!
  end

end
