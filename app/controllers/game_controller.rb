class GameController < ApplicationController
  def create
    game = find_or_create_game(current_user)

    redirect_to game_path(game)
  end

  def show
    @game = find_game
    @player = find_player

    respond_to do |format|
      format.html do
        if @game.started?
          board = @game.boards.last

          if !board.finished?
            redirect_to game_board_path(@game, board)
          end
        end
      end
      format.json { render :json => GamePresenter.new(@game).to_json }
    end
  end

  def ready
    game = find_game

    find_player.update! ready: true

    if game.ready_to_start?
      StartGame.new(game: game).call
    end

    redirect_to game_path(game)
  end

  def not_ready
    game = find_game

    find_player.update! ready: false

    redirect_to game_path(game)
  end

  private

  def find_game
    Game.find(params[:id] || params[:game_id])
  end

  def find_player
    find_game.players.where(user: current_user).first!
  end

  def find_or_create_game(user)
    FindOrCreateGame.new(user: user).call
  end

  def find_or_create_player(game)
    FindOrCreatePlayer.new(game: game).call
  end
end
