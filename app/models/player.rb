class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  scope :ready, -> { where(ready: true) }

  validates :user, :score, :game, presence: true
end
