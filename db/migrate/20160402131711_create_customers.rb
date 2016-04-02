class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :custID
      t.string :interested
      t.string :bought

      t.timestamps null: false
    end
  end
end
