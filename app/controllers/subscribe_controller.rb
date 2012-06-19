class SubscribeController < ApplicationController

  before_filter :authorize_admin, :except => [:index, :logo]
  layout :set_layout

  def index
    @subscriber = Subscriber.new(params[:subscriber])
    flash.now[:success] = "You'd be surprised how much you will save by joining our club. Thank you!" if request.post? && @subscriber.save
  end

  def logo
    subscriber = Subscriber.find_all_by_id(params[:id])
    if subscriber.size > 0
      subscriber[0].update_attribute(:opened, true)
    end
    send_file "#{Rails.root}/app/assets/images/img/logo.png", :type => "image/jpeg", :disposition => "inline"
  end

  def list
    @page_title = "Subscribers"
    @subscribers = Subscriber.all
  end

  private

  def set_layout
    case action_name
      when "logo"
        nil
      when "index"
        "login"
      else
        "admin"
    end
  end

end
