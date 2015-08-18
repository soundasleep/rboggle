class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  has_many :guesses, dependent: :destroy

  scope :ready, -> { where(ready: true) }

  validates :user, :score, :game, presence: true
end
