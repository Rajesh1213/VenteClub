class AddOriginalUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :original_url, :string, :default => ""
  end
end
