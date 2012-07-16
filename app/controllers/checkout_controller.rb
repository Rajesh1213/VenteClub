class CheckoutController < ApplicationController

  before_filter :authorize_user
  before_filter :read_cart
  before_filter :menu_data
  before_filter :check_login_confirmed, :except => :login_confirmation

  layout :set_layout

  def login_confirmation
    session.delete("login_confirmed")
    if request.post?
      user = User.authenticate(params[:mail], params[:pass])
      if user
        session[:login_confirmed] = true
        redirect_to :action => :ship_to
      else
        sleep 2
        flash.now[:error] = "Incorrect Email/Password combination"
      end
    end
  end

  def ship_to
    @shipping_address = @current_user.shipping_addresses.new
    @countries = WorldwideTariff.all
    if request.post?
      if params[:shipping_address]
        shipping_address = @current_user.shipping_addresses.new(params[:shipping_address])
        if shipping_address.save
          session[:shipping_address] = shipping_address.id
          redirect_to :action => :payment_method
        end
      else
        shipping_address = @current_user.shipping_addresses.find(params[:id])
        session[:shipping_address] = shipping_address.id
        redirect_to :action => :payment_method
      end
    end
  end

  def edit_shipping_address
    @shipping_address = @current_user.shipping_addresses.find(params[:id])
    @countries = WorldwideTariff.all
    if request.post? && @shipping_address.update_attributes(params[:shipping_address])
      session[:shipping_address] = @shipping_address.id
      redirect_to :action => :payment_method
    end
  end

  def payment_method
    @credit_card = @current_user.credit_cards.new
    if request.post?
      if params[:credit_card]
        @credit_card = @current_user.credit_cards.new(params[:credit_card])
        if @credit_card.save
          session[:credit_card] = @credit_card.id
          redirect_to :action => :bill_to
        end
      else
        credit_card = @current_user.credit_cards.find(params[:id])
        session[:credit_card] = credit_card.id
        redirect_to :action => :bill_to
      end
    end
  end

  def edit_card
    @credit_card = @current_user.credit_cards.find(params[:id])
    if request.post? && @credit_card.update_attributes(params[:credit_card])
      session[:credit_card] = @credit_card.id
      redirect_to :action => :bill_to
    end
  end

  def bill_to
    @billing_address = @current_user.billing_addresses.new
    @countries = WorldwideTariff.all
    if request.post?
      if params[:billing_address]
        billing_address = @current_user.billing_addresses.new(params[:billing_address])
        if billing_address.save
          session[:billing_address] = billing_address.id
          redirect_to :action => :order
        end
      else
        billing_address = @current_user.billing_addresses.find(params[:id])
        session[:billing_address] = billing_address.id
        redirect_to :action => :order
      end
    end
  end

  def edit_billing_address
    @billing_address = @current_user.billing_addresses.find(params[:id])
    @countries = WorldwideTariff.all
    if request.post? && @billing_address.update_attributes(params[:billing_address])
      session[:billing_address] = @billing_address.id
      redirect_to :action => :order
    end
  end

  def order
    @shipping_address = @current_user.shipping_addresses.find(session[:shipping_address])
    @billing_address = @current_user.billing_addresses.find(session[:billing_address])
    @credit_card = @current_user.credit_cards.find(session[:credit_card])
    @order = @cart_order
  end

  def change_quantities

  end

  private

  def check_login_confirmed
    redirect_to :action => :login_confirmation unless session[:login_confirmed]
  end

  def set_layout
    case action_name
      when "login_confirmation"
        "login"
      else
        "checkout"
    end
  end

end
