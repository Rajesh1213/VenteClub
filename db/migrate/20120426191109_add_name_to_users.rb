class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :shop_category_id, :integer
    add_column :users, :us_ship, :boolean
  end
end
