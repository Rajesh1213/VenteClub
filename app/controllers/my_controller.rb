class MyController < ApplicationController

  before_filter :authorize_user
  before_filter :menu_data

  layout "main"

  def suite
  end

  def account
    @user = @current_user.clone
    flash.now[:success] = "Account updated" if request.post? && @user.update_attributes(params[:user])
  end

  def shipping_cart

  end

  def addresses

  end

end
