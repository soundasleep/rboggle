class WelcomeController < ApplicationController
  def index
  end

  helper_method :waiting_games, :your_games, :active_games, :finished_games

  private

  def waiting_games
    Game.not_started
  end

  def your_games
    current_user.players.order(created_at: :desc)
  end

  def active_games
    your_games.select{ |p| !p.game.finished? }
        .map(&:game)
  end

  def finished_games
    your_games.select{ |p| p.game.finished? }
        .map(&:game)
  end
end
