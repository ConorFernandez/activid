class AddStripeCustomerIdToOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.string :stripe_customer_id
    end
  end
end
