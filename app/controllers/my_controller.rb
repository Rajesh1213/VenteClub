class MyController < ApplicationController

  before_filter :authorize_user
  before_filter :read_cart
  before_filter :menu_data

  layout "main"

  def suite
  end

  def account
    @user = @current_user.clone
    flash.now[:success] = "Account updated" if request.post? && @user.update_attributes(params[:user])
  end

  def addresses
    @user = @current_user.clone
    @javascript = true
    @countries = WorldwideTariff.all
    if request.post? && @user.update_attributes(params[:user])
      flash.now[:success] = "Shipping addresses updated"
    else
      @user.shipping_addresses.new if @user.shipping_addresses.size == 0
    end
  end

  def email_settings

  end

  def shipment_history
    @javascript = true
  end

  # ajax

  def update_data
    if request.post?
      color = Color.find(params[:color_id])
      size = Size.find(params[:size_id]) if params[:size_id] != "-1"
      product = Product.find(params[:product_id])
      similar_products = product.similar_products
      if product.color == color
        #p "size clicked"
        similar_products.each { |similar_product|
          product = similar_product if similar_product.size == size
        }
      else
        #p "color clicked"
        similar_products.each { |similar_product|
          product = similar_product if similar_product.color == color
        }
      end
      render :json => {:product => product}
    end
  end

  def shopping_cart_add
    if request.post?
      product = Product.find(params[:id])
      @cart_order.products << product unless @cart_order.products.include?(product)
      render :partial => "layouts/shopping_cart"
    end
  end

  def shopping_cart_del
    if request.post?
      product = Product.find(params[:id])
      @cart_order.products.delete(product)
      render :json => {:success => true, :total => @cart_order.total_price_human, :cart_items => @cart_order.items_human}
    end
  end

end
