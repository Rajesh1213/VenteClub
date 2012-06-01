class MainController < ApplicationController

  before_filter :current_user
  before_filter :read_cart
  before_filter :menu_data

  def index
    @javascript = true
    unless params[:id]
      @latest_event = Event.current.first
    else
      @latest_event = TopCategory.find(params[:id]).events.current.first || Event.first
    end
    @events = @latest_event.top_category.events.current.all
    @upcoming_events = @latest_event.top_category.events.upcoming.all
  end

  def product
    @javascript = true
    if params[:id]
      @product = Product.find(params[:id])
    else
      @product = Product.last
    end
    @event = @product.event
    @top_category = @event.top_category
  end

  def event
    @javascript = true
    if params[:id]
      @event = Event.find(params[:id])
    else
      @event = Event.current.first
    end
  end

end
