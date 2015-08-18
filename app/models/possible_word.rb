class PossibleWord < ActiveRecord::Base
  belongs_to :board
  belongs_to :dictionary
end
