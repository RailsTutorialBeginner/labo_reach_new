class AddAdminToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :admin, :boolean, default: false
  end
end
