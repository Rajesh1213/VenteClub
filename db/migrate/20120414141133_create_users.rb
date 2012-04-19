class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mail
      t.string :pass
      t.integer :role_id, :default => 1
      t.string :ip, :default => ""
      t.string :country
      t.string :city
      t.text :serialized_fb_graph
      t.integer :fb_id, :limit => 8
      t.timestamps
    end
  end
end
