class StaticController < ApplicationController

  before_filter :authorize_user
  before_filter :menu_data

  layout "main"

  def how_it_works

  end

end
