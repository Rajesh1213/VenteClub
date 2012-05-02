class MainController < ApplicationController

  before_filter :authorize_user
  before_filter :menu_data

  def index
    @javascript = true
    unless params[:id]
      @latest_event = Event.last
      @events = @latest_event.top_category.events.all
    else
      @latest_event = TopCategory.find(params[:id]).events.last || Event.last
      @events = @latest_event.top_category.events.all
    end
  end

  def product
    if params[:id]
      @product = Product.find(params[:id])
    else
      @product = Product.last
    end
    @event = @product.event
    @top_category = @event.top_category
  end

  def event
    if params[:id]
      @event = Event.find(params[:id])
    else
      @event = Event.last
    end
  end

end
