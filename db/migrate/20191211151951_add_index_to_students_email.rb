class AddIndexToStudentsEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :students, :email, unique: true
  end
end
