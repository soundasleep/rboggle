class Guess < ActiveRecord::Base
  belongs_to :player
  belongs_to :board

  validates :player, :board, :word, presence: true

end
