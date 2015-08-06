class AddFinishedAtToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :finished_at, :timestamp
  end
end
