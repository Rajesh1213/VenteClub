class Order < ActiveRecord::Base

  belongs_to :user
  has_many :product_orders, :dependent => :destroy
  has_many :products, :through => :product_orders

  def total_price
    self.products.collect { |product| (product.price if product.amount > 0) || 0 }.inject(:+) || 0
  end

  def total_price_human
    number_to_currency(total_price)
  end

  def items_human
    items_to_view(self.products.size)
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
