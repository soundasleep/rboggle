class GamePresenter < JSONPresenter
  def initialize(game)
    super(game)
  end

  def game
    object
  end

  def json_attributes
    [ :id, :started, :finished ]
  end

  def extra_json_attributes
    {
      players: players_count,
      players_ready: players_ready_count,
      last_board: game.boards.any? ? format_board(game.boards.order(round_number: :desc).first) : nil,
      url: Rails.application.routes.url_helpers.game_path(game),
    }
  end

  def to_data_set
    {
      "data-game" => game.id,
      "data-players" => players_count,
      "data-players-ready" => players_ready_count,
      "data-check-url" => Rails.application.routes.url_helpers.game_path(game, format: :json),
    }
  end

  private

  def format_board(board)
    BoardPresenter.new(board).to_json
  end

  def players_count
    game.players.count
  end

  def players_ready_count
    game.players.ready.count
  end

end
