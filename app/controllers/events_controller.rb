class EventsController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Events"
    @top_categories = TopCategory.all
  end

  def new
    @page_title = "New Event"
    @javascript = true
    @top_category = TopCategory.find(params[:id])
    convert_to_datetime
    unless request.post?
      @event = @top_category.events.new
    else
      @event = @top_category.events.new(params[:event])
      if @event.save
        flash[:success] = "Event: #{@event.name} created"
        redirect_to :action => :list, :state => @event.state
      end
    end
  end

  def edit
    @page_title = "Edit event"
    @javascript = true
    @event = Event.find(params[:id])
    convert_to_datetime
    if request.post? && @event.update_attributes(params[:event])
      flash[:success] = "Event #{@event.name} updated"
      redirect_to :action => :list, :state => @event.state
    end
  end

  def delete
    event = Event.find(params[:id])
    ec = event.clone
    if request.post? && event.destroy
      flash[:warning] = "Event: #{ec.name} deleted"
      redirect_to :action => :list, :state => ec.state
    end
  end

  private

  def convert_to_datetime
    if request.post?
      params[:event][:start_at] = DateTime.strptime(params[:event][:start_at], '%m-%d-%Y %H:%M')
      params[:event][:end_at] = DateTime.strptime(params[:event][:end_at], '%m-%d-%Y %H:%M')
    end
  end

end
