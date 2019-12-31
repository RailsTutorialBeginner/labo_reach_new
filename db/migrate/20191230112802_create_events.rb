class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.text :content
      t.references :school, foreign_key: true

      t.timestamps
    end
    add_index :events, [:school_id, :created_at]
  end
end
