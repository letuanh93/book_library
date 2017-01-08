class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :action_type
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
