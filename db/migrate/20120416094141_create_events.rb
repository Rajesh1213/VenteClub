class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :top_category_id
      t.string :name, :default => ""
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
