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

  def orders

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
