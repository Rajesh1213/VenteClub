class LoginController < ApplicationController

  before_filter :current_user
  before_filter :authorize_user, :only => ["customize"]

  layout "login"

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
    original_uri = session[:original_uri]
    reset_session
    session[:original_uri] = original_uri
    flash[:error] = "Only authorized users can access this page"
    redirect_to :controller => :login, :action => :log_in
  end

  def forgot_pass
    if request.post?
      user = User.find_by_mail(params[:mail])
      if user
        Mailer.forgot_pass(user).deliver
        flash[:success] = "Mail with instructions sent"
        redirect_to :action => :log_in
      else
        flash.now[:error] = "Email not found"
      end
    end
  end

  def reset_pass
    unless request.post?
      user = User.find_by_mail(params[:mail])
      if user && params[:id] == user.pass[140..160]
        @user = user
        @user.pass = ""
      else
        flash[:error] = "Incorrect reset url"
        redirect_to :action => :log_in
      end
    else
      @user = User.find_by_mail(params[:user][:mail])
      @user.pass = params[:user][:pass]
      @user.pass_confirmation = params[:user][:pass_confirmation]
      if @user.save
        flash[:success] = "Password updated"
        redirect_to :action => :log_in
      end
    end
  end

  def registration
    @action_style = "padding-top: 20px;height:462px;"
    @user = User.new(params[:user])
    if request.post? && @user.save
      session[:user_id] = @user.id
      redirect_to :action => :customize
    end
  end

  def customize
    @action_style = "padding-top: 50px;height:432px;"
    @top_categories = TopCategory.all
    redirect_user(@current_user) if request.post? && @current_user.update_attributes(params[:user])
  end

  private

  def redirect_user(user)
    update_ip
    if user.role == "admin"
      redirect_to :controller => :admin, :action => :dashboard
    else
      original_uri = session[:original_uri]
      session.delete("original_uri")
      redirect_to(original_uri || {:controller => :main, :action => :index, :id => TopCategory.first})
    end
  end

end
