class Board < ActiveRecord::Base
  has_many :guesses, dependent: :destroy

  belongs_to :game

  validates :round_number, :serialized, :game, presence: true

  def width
    4
  end

  def height
    4
  end

  def round_length
    3.minutes
  end

  def cells
    serialized.split("|").map{ |row| row.split(",") }
  end

  def cell_at(x,y)
    cells[y][x]
  end
end
