class ShippingCalculatorController < ApplicationController

  before_filter :authorize_user
  before_filter :menu_data

  layout "main"

  def index
    @javascript = true
  end

  def flat_rate_products
    if request.post?
      product_type = ProductType.find(params[:product_type_id])
      render :json => {:product_type => product_type}
    end
  end

end
