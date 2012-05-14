class AddOldPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :old_price, :decimal, :precision => 15, :scale => 2, :default => 0
  end
end
