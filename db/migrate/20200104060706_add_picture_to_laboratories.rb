class AddPictureToLaboratories < ActiveRecord::Migration[5.1]
  def change
    add_column :laboratories, :picture, :string
  end
end
