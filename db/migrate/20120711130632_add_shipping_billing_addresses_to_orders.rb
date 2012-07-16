class AddShippingBillingAddressesToOrders < ActiveRecord::Migration
  def change
    add_column :shipping_addresses, :shipping_order_id, :integer
    add_column :shipping_addresses, :billing_order_id, :integer
  end
end
