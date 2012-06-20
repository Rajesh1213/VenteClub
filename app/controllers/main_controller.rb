class MainController < ApplicationController

  before_filter :current_user
  before_filter :read_cart
  before_filter :menu_data

  def index
    @javascript = true
    unless params[:id]
      @latest_event = Event.current.first || Event.first
    else
      top_category = TopCategory.find(params[:id])
      @latest_event = top_category.events.current.first || top_category.events.first || Event.first
    end
    @top_category = @latest_event.top_category
  end

  def event
    @javascript = true
    if params[:id]
      @event = Event.find(params[:id])
    else
      @event = Event.current.first
    end
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

end
