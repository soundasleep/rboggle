class Dictionary < ActiveRecord::Base
  # TODO add a unique constraint on the schema
  # t.index unique something
  validates :word, presence: true, uniqueness: true
end
