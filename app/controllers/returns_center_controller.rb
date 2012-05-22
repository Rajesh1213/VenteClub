class ReturnsCenterController < ApplicationController

  before_filter :authorize_user
  before_filter :read_cart
  before_filter :menu_data

  layout "main"

  def index

  end

end
