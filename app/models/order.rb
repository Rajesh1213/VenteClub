class Order < ActiveRecord::Base

  belongs_to :user
  has_many :product_orders, :dependent => :destroy
  has_many :products, :through => :product_orders, :order => "name DESC"
  has_one :shipping_address, :foreign_key => :shipping_order_id, :dependent => :destroy
  has_one :billing_address, :class_name => "ShippingAddress", :foreign_key => :billing_order_id, :dependent => :destroy

  def items_price
    self.products.collect { |product| (product.price if product.amount > 0) || 0 }.inject(:+) || 0
  end

  def items_price_human
    number_to_currency(items_price)
  end

  def shipping_and_handling_price
    0
  end

  def shipping_and_handling_price_human
    number_to_currency(shipping_and_handling_price)
  end

  def tax_price
    0
  end

  def tax_price_human
    number_to_currency(tax_price)
  end

  def items_human
    items_to_view(self.products.size)
  end

  def total_price
    items_price + shipping_and_handling_price + tax_price
  end

  def total_price_human
    number_to_currency(total_price)
  end

  private

  def items_to_view(number)
    Helper.instance.pluralize(number, "item")
  end

  def number_to_currency(number)
    Helper.instance.number_to_currency(number, :unit => "")
  end

  class Helper
    include Singleton
    include ActionView::Helpers::NumberHelper
    include ActionView::Helpers::TextHelper
  end

end
