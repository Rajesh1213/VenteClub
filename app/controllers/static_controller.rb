class StaticController < ApplicationController

  before_filter :current_user
  before_filter :read_cart
  before_filter :menu_data

  layout "main", :except => "size_chart"

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

  def return_and_refund_policy
  end

  def size_chart
  end

end
