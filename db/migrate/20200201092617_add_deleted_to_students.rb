class AddDeletedToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :deleted, :integer, default: 0
  end
end
