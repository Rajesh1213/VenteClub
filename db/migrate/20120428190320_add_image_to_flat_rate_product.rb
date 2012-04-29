class AddImageToFlatRateProduct < ActiveRecord::Migration
  def change
    add_column :images, :flat_rate_product_id, :integer
  end
end
