class MainController < ApplicationController

  before_filter :current_user
  before_filter :read_cart
  before_filter :menu_data

  caches_action :index, :event, :layout => false

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
    expire_action :action => :event, :id => 29
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
  end

end
