class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.references :room, foreign_key: true
      t.boolean :is_student
      t.text :content

      t.timestamps
    end
  end
end
