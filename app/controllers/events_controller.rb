class EventsController < ApplicationController

  require "file_manipulation"

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

  def from_myhabit
    @page_title = "New event from MyHabit URL"
    @top_category = TopCategory.find(params[:id])
    @top_categories = TopCategory.all
    if request.post?
      if FileManipulation.from_file("#{Rails.root}/tmp/background_task") == ""
        #top_category = TopCategory.find(params[:top_category_id])
        #event = MyHabit.new().event_from_url(params[:url], top_category)

        call_rake :process_event, :url => params[:url], :top_category_id => params[:top_category_id].to_i, :user_id => @current_user.id

        flash[:warning] = "Event processing started in background. You will be noticed via email when done or if error happens. Please DO NOT use auto products/events processing till that time."
        redirect_to :action => :list, :state => "current"
      else
        flash.now[:error] = "You have active background task!"
      end
    else
      flash.now[:warning] = "Background processing active" if FileManipulation.from_file("#{Rails.root}/tmp/background_task") != ""
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
    state = event.state
    if request.post? && event.destroy
      flash[:warning] = "Event: #{ec.name} deleted"
      redirect_to :action => :list, :state => state
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
