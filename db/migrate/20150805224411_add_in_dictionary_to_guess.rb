class AddInDictionaryToGuess < ActiveRecord::Migration
  def change
    add_column :guesses, :in_dictionary, :boolean
  end
end
