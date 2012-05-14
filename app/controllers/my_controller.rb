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

end
