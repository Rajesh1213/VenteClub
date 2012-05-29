class ShippingCalculatorController < ApplicationController

  before_filter :current_user
  before_filter :read_cart
  before_filter :menu_data

  layout "main"

  def index
    @javascript = true
  end

end
