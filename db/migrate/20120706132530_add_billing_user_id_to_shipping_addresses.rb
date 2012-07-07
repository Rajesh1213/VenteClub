class AddBillingUserIdToShippingAddresses < ActiveRecord::Migration
  def change
    add_column :shipping_addresses, :billing_user_id, :integer
  end
end
