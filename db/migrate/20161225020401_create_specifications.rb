class CreateSpecifications < ActiveRecord::Migration[5.0]
  def change
    create_table :specifications do |t|
      t.references :book, foreign_key: true
      t.string :feature_type
      t.string :feature_value

      t.timestamps
    end
    add_index :specifications, [:id, :book_id], unique: true
  end
end
