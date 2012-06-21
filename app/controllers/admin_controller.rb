class AdminController < ApplicationController

  before_filter :authorize_admin

  layout 'admin'

  def dashboard
    @page_title = "Dashboard"
    @products_amount = Product.count
    @events_amount = Event.count
    @orders_amount = Order.count
  end

  def account
    @page_title = "My account"
    @user = User.find @current_user.id
    if request.post? && @user.update_attributes(params[:user])
      flash[:success] = 'Account successfully updated'
      @current_user = User.find @current_user.id
    end
  end

  def list
    @page_title = "Admins list"
    @admins = User.where(:role_id => 2)
  end

  def new
    @page_title = "New admin"
    if request.post?
      @user = User.new(params[:user])
      @user.role_id = 2
      if @user.save
        flash[:success] = "Admin #{@user.mail} successfully created"
        redirect_to :action => :list
        return
      end
    end
    render :action => :account
  end

  def delete
    if request.post? && User.where(:role_id => 2).size > 1
      user = User.find(params[:id])
      fl_u = user.clone
      if user.destroy
        flash[:success] = "Admin #{fl_u.mail} successfully deleted"
        redirect_to :action => :list
      end
    else
      flash[:error] = "You can't delete last admin"
      redirect_to :action => :list
    end
  end

end
