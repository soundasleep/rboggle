class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  validates :user, :score, :game, presence: true

end
