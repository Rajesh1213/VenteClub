class StaticController < ApplicationController

  before_filter :authorize_user
  before_filter :read_cart
  before_filter :menu_data

  layout "main"

  def how_it_works
  end

  def terms_of_service
  end

  def privacy_notice
  end

  def security_notice
  end

  def terms_of_use
  end

end
