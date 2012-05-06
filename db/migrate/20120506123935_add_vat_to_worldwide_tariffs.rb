class AddVatToWorldwideTariffs < ActiveRecord::Migration
  def change
    add_column :worldwide_tariffs, :vat, :decimal, :precision => 15, :scale => 2, :default => 10
  end
end
