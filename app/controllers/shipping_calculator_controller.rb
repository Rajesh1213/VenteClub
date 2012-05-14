class ShippingCalculatorController < ApplicationController

  before_filter :authorize_user
  before_filter :read_cart
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

  def flat_rate_price
    if request.post?
      product_value = params[:product_value].gsub(",", ".").to_f
      if product_value > 0
        frp = FlatRateProduct.find(params[:id])
        frp.user_data = {:product_value => product_value, :worldwide_tariff => WorldwideTariff.find(params[:destination_id])}
        render :json => frp.total_cost
      else
        render :json => {:error => "Incorrect Value"}
      end
    end
  end

end
