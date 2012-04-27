class AddImagesToEvents < ActiveRecord::Migration
  def change
    add_column :images, :event_big_id, :integer
  end
end
