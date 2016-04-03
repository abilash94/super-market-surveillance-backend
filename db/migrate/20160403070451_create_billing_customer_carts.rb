class CreateBillingCustomerCarts < ActiveRecord::Migration
  def change
    create_table :billing_customer_carts do |t|
      t.string :cart

      t.timestamps null: false
    end
  end
end
