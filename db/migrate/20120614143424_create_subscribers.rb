class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :mail
      t.boolean :opened, :default => false
      t.timestamps
    end
  end
end
