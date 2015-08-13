class AddUniqueIndexToDictionaryWord < ActiveRecord::Migration
  def change
    remove_index :dictionaries, :word
    add_index :dictionaries, :word, unique: true
  end
end
