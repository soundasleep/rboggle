class Board < ActiveRecord::Base
  has_many :guesses, dependent: :destroy

  belongs_to :game

  validates :round_number, :serialized_cells, :game, presence: true

  def width
    4
  end

  def height
    4
  end

  def round_length
    3.minutes
  end

  def expires_at
    created_at + round_length
  end

  def cells
    @cells ||= serialized_cells.split("|").map { |row| row.split(",") }
  end

  def cells=(rows)
    update(serialized_cells: rows.map { |row| row.join(",") }.join("|"))
  end

  def cell_at(x,y)
    cells[y][x]
  end
end
