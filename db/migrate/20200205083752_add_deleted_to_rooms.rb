class AddDeletedToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :deleted, :integer, default: 0
  end
end
