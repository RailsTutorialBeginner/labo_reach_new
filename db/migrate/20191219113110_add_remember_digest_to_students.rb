class AddRememberDigestToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :remember_digest, :string
  end
end
