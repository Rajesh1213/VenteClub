class CreateFlatRateProducts < ActiveRecord::Migration
  def change
    create_table :flat_rate_products do |t|
      t.integer :product_type_id
      t.string :name
      t.decimal :weight, :precision => 15, :scale => 2, :default => 0
      t.decimal :volume, :precision => 15, :scale => 2, :default => 0
      t.timestamps
    end
  end
end
