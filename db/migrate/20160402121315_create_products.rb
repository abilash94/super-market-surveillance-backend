class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :count
      t.integer :row
      t.integer :col

      t.timestamps null: false
    end
  end
end
