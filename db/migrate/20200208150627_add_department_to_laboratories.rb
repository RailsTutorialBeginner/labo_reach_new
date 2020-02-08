class AddDepartmentToLaboratories < ActiveRecord::Migration[5.1]
  def change
    add_column :laboratories, :department, :integer
  end
end
