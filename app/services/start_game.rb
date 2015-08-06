class StartGame
  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def call
    create_board

    @game.update! started: true

    @game.players.each{ |player| player.update! ready: false, guessed: false }

    true
  end

  private

  def create_board
    @game.boards.create! round_number: game.rounds + 1, serialized: create_serialized
  end

  def create_serialized
    random_cubes = cubes.shuffle.map do |cube|
      cube.shuffle.first
    end

    rows = []
    (0..3).each do |row|
      rows << random_cubes.slice!(0, 4)
    end

    rows.map { |row| row.join(",") }.join("|")
  end

  private

  def cubes
    # from http://www.boardgamegeek.com/thread/300565/review-boggle-veteran-and-beware-different-version
    # "Old version"
    ["aaciot", "ahmors", "egkluy", "abilty",
        "acdemp", "egintv", "gilruw", "elpstu",
        "denosw", "acelrs", "abjmoq", "eefhiy",
        "ehinps", "dknotu", "adevnz", "biforx"].map do |cube|
      cube.chars.map { |c| c == "q" ? "qu" : c }
    end
  end

end
