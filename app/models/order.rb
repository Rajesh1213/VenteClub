class Order < ActiveRecord::Base

  belongs_to :user
  has_many :product_orders, :dependent => :destroy
  has_many :products, :through => :product_orders

  def total_price
    self.products.collect { |product| product.price }.inject(:+) || 0
  end

  def total_price_human
    number_to_currency(total_price)
  end

  private

  def number_to_currency(number)
    Helper.instance.number_to_currency(number, :unit => "")
  end

  class Helper
    include Singleton
    include ActionView::Helpers::NumberHelper
  end

end
