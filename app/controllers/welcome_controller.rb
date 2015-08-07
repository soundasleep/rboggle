class WelcomeController < ApplicationController
  def index
  end

  helper_method :waiting_games
  helper_method :your_games

  private

  def waiting_games
    Game.where(started: false, finished: false)
  end

  def your_games
    current_user.players.order(created_at: :desc)
        .select{ |p| !p.game.finished? }
        .map(&:game)
  end
end
