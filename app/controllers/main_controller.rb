class MainController < ApplicationController

  before_filter :authorize_user
  before_filter :common_data

  def index
    unless params[:id]
      @latest_event = Event.last
      @events = @latest_event.top_category.events.all
    else
      @latest_event = TopCategory.find(params[:id]).events.last || Event.last
      @events = @latest_event.top_category.events.all
    end
  end

  private

  def common_data
    @top_categories = TopCategory.all
  end

end
