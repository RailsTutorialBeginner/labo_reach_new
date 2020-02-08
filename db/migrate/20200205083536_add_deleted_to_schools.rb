class AddDeletedToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :deleted, :integer, default: 0
  end
end
