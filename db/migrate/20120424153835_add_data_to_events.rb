class AddDataToEvents < ActiveRecord::Migration
  def change
    add_column :events, :description, :text
    add_column :images, :event_id, :integer
  end
end
