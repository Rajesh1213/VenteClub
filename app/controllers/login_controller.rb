class LoginController < ApplicationController

  before_filter :current_user

  layout "admin"

  def log_in
    if @current_user
      redirect_user(@current_user)
      return
    else
      if request.post?
        user = User.authenticate(params[:mail], params[:pass])
        if user
          session[:user_id] = user.id
          redirect_user(user)
        else
          sleep 2
          flash.now[:error] = "Incorrect Email/Password combination"
        end
      end
    end
  end

  def log_out
    reset_session
    flash[:success] = "Successfully logged out"
    redirect_to :root
  end

  def unauthorized
    reset_session
    flash[:error] = "Only authorized users can access this page"
    redirect_to :root
  end

  private

  def redirect_user(user)
    update_ip
    redirect_to :controller => :admin, :action => :dashboard
  end

end
