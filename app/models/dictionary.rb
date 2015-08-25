# TODO rename to Word or DictionaryWord
# TODO add prime number boggle
class Dictionary < ActiveRecord::Base
  validates :word, presence: true, uniqueness: true
end
