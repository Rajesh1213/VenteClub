class AddCustomerPaymentProfileIdToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :customer_payment_profile_id, :string, :default => ""
  end
end
