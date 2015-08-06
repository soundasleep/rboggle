class BoardPresenter < JSONPresenter
  def initialize(board)
    super(board)
  end

  def board
    object
  end

  def json_attributes
    [ :id, :started, :finished ]
  end

  def extra_json_attributes(context = nil)
    {
      url: Rails.application.routes.url_helpers.game_board_path(board.game, board),
    }
  end

end
