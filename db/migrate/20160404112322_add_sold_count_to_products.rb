class AddSoldCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :soldCount, :integer
  end
end
