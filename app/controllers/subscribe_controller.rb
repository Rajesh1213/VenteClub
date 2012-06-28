class SubscribeController < ApplicationController

  before_filter :authorize_admin, :except => [:index, :logo]
  layout :set_layout

  def index
    @javascript = true
    @subscriber = Subscriber.new(params[:subscriber])
    if request.post?
      if @subscriber.save
        #flash.now[:success] = "You'd be surprised how much you will save by joining our club. Thank you!"
        #render :json => [["subscriber_mail", true, " You'd be surprised how much you will save by joining our club.<br/>Thank you!<br/>Don't forget to like us on <a href='http://www.facebook.com/pages/Vente-Club/245746568846324'>our Facebook page!</a>"]]
        render :json => [["subscriber_mail", false, " Thank you for joining VenteClub"]]
      else
        render :json => [["subscriber_mail", false, @subscriber.errors.full_messages.first]]
      end
    end
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

  def delete
    if Subscriber.find(params[:id]).destroy
      flash[:warning] = "Subscriber deleted"
      redirect_to :action => :list
    end
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
