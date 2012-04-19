class Mailer < ActionMailer::Base

  default :from => "kingpin@magukr.com"

  def welcome_email(user)
    @user = user
    @url = "https://venteclub.com/"
    mail(:to => user.mail, :subject => "Welcome to VenteClub")
  end

  def forgot_pass(user)
    @user = user
    if user.class.to_s == "Admin"
      @url = "https://joinkingpin.com/admin_login/reset_pass/" + user.pass[140..160] + '?mail=' + user.mail
    else
      @url = "https://joinkingpin.com/login/reset_pass/" + user.pass[140..160] + '?mail=' + user.mail
    end
    mail(:to => user.mail, :subject => "Kingpin - Password recovery instructions")
  end

  def new_pass(user, new_pass)
    @user = user
    @pass = new_pass
    mail(:to => user.mail, :subject => "Kingpin - New Password")
  end

  def admin_welcome_email(admin)
    @admin = admin
    @url = "https://joinkingpin.com/admin"
    mail(:to => admin.mail, :subject => "Kingpin administration details")
  end

end
