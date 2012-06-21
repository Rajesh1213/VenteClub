class AddOriginalUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :original_url, :text, :default => ""
  end
end
