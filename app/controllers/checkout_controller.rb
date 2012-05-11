class CheckoutController < ApplicationController

  before_filter :authorize_user
  before_filter :menu_data

  layout :set_layout

  def login_confirmation


  end

  private

  def set_layout
    case action_name
      when "login_confirmation"
        "login"
      else
        "main"
    end

  end

end
