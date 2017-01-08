class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.references :user, index: true, foreign_key: true
      t.references :book, index: true, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
