class CreateTopCategories < ActiveRecord::Migration
  def change
    create_table :top_categories do |t|
      t.string :name, :default => ""
      t.integer :sorting, :default => 1
      t.timestamps
    end
  end
end
