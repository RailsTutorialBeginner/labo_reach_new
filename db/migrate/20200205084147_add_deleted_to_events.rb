class AddDeletedToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :deleted, :integer, default: 0
  end
end
