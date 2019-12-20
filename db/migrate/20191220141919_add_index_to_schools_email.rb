class AddIndexToSchoolsEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :schools, :email, unique: true
  end
end
