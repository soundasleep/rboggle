class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :round_number, null: false
      t.boolean :finished, null: false, default: false
      t.string :cells, null: false

      t.timestamps null: false
    end

    add_index :boards, :round_number
    add_index :boards, :finished
  end
end
