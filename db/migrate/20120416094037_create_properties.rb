class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :product_id
      t.string :name
      t.string :value
      t.timestamps
    end
  end
end
