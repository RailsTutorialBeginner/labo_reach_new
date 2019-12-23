class AddResetToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :reset_digest, :string
    add_column :schools, :reset_sent_at, :datetime
  end
end
