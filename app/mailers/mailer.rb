class Mailer < ActionMailer::Base

  default :from => "venteclub@magukr.com"

  def welcome_email(user)
    @user = user
    @url = "http://dev.venteclub.com/"
    mail(:to => user.mail, :subject => "Welcome to VenteClub")
  end

  def forgot_pass(user)
    @user = user
    @url = "http://dev.venteclub.com/login/reset_pass/" + user.pass[140..160] + "?mail=" + user.mail
    mail(:to => user.mail, :subject => "VenteClub - Password recovery instructions")
  end

  def new_pass(user, new_pass)
    @user = user
    @pass = new_pass
    mail(:to => user.mail, :subject => "VenteClub - New Password")
  end

  def event_ready(user, event, error=nil)
    @error = error
    @event = event
    if @event
      @event_result = "success"
      mail(:to => user.mail, :subject => "Event #{event.name} ready")
    else
      @event = Event.new
      @event_result = "fail"
      mail(:to => user.mail, :subject => "Unsuccessful Event processing")
    end
  end

  def welcome_subscriber(subscriber)
    @subscriber = subscriber
    mail(:to => @subscriber.mail, :subject => "Welcome to VenteClub")
  end

end
