class AddActivationToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :activation_digest, :string
    add_column :schools, :activated, :boolean, default: false
    add_column :schools, :activated_at, :datetime
  end
end
