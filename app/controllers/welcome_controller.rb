class WelcomeController < ApplicationController
  # TODO replace with @waiting_games for ps
  helper_method :waiting_games, :your_games, :active_games, :finished_games

  def index
  end

  private

  def waiting_games
    Game.not_started
  end

  def your_games
    current_user.players.order(created_at: :desc)
  end

  def active_games
    # TODO could/should be scopes one day
    your_games.reject { |p| p.game.finished? }.map(&:game)
  end

  def finished_games
    your_games.select { |p| p.game.finished? }.map(&:game)
  end
end
