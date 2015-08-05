class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :started, null: false, default: false
      t.boolean :finished, null: false, default: false

      t.timestamps null: false
    end

    add_index :games, :started
    add_index :games, :finished
  end
end
