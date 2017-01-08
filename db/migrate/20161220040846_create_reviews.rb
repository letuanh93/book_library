class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :rate
      t.references :user, index: true, foreign_key: true
      t.references :book, index: true, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
