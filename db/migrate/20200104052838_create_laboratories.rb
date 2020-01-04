class CreateLaboratories < ActiveRecord::Migration[5.1]
  def change
    create_table :laboratories do |t|
      t.string :name
      t.text :content
      t.references :school, foreign_key: true

      t.timestamps
    end
  end
end
