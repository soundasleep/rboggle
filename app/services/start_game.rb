class StartGame
  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def call
    create_board

    @game.update! started: true

    @game.players.each{ |player| player.update! ready: false }

    true
  end

  private

  def create_board
    @game.boards.create! round_number: game.rounds + 1, serialized: create_serialized
  end

  def create_serialized
    "a,b,c,d|a,b,c,d|a,b,c,d|a,b,c,d"
  end

end
