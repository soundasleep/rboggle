class GameController < ApplicationController
  def create
    @game = find_or_create_game
  end

  private

  def find_or_create_game

  end
end
