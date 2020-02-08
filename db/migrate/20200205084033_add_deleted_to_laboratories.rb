class AddDeletedToLaboratories < ActiveRecord::Migration[5.1]
  def change
    add_column :laboratories, :deleted, :integer, default: 0
  end
end
