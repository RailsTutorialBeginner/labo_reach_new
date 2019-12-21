class AddRememberDigestToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :remember_digest, :string
  end
end
