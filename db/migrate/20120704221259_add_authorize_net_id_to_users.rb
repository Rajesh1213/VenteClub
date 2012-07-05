class AddAuthorizeNetIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer_profile_id, :string, :default => ""
  end
end
