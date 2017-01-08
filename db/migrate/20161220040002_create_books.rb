class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.references :author, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.references :publisher, index: true, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
