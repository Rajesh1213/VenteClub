class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :event_id
      t.integer :color_id
      t.integer :size_id
      t.string :name
      t.text :description
      t.integer :amount, :default => 0
      t.decimal :price, :precision => 15, :scale => 2, :default => 0
      t.timestamps
    end
  end
end
