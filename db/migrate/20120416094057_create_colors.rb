class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :name
      t.string :html_val, :default => "#ffffff"
      t.timestamps
    end
  end
end
