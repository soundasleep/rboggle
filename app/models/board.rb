class Board < ActiveRecord::Base
  has_many :guesses, dependent: :destroy
  has_many :possible_words, dependent: :destroy

  belongs_to :game

  validates :round_number, :serialized_cells, :game, presence: true
  # TODO validation of uniqueness round_number on game
  # -> then round_number can be count(boards) rather than max(round_number) + 1
  # TODO checks that round_number increments

  # TODO make a 5x5 board OR make these constants on Board (WIDTH, HEIGHT)
  def width
    4
  end

  def height
    4
  end

  # TODO check that this is used in the JS
  def round_length
    3.minutes
  end

  # TODO use a time diff instead, time1.diff(time2).in_seconds > 3*60
  # (considering daylight savings)
  def expires_at
    created_at + round_length
  end

  def cells
    # TODO does board.update! cells: [[..]] work? add spec for custom serializer
    @cells ||= serialized_cells.split("|").map { |row| row.split(",") }
  end

  def cells=(rows)
    update(serialized_cells: rows.map { |row| row.join(",") }.join("|"))
  end

  def cell_at(x,y)
    cells[y][x]
  end
end
