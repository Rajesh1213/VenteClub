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
    @shipping_address = ShippingAddress.new
    @countries = WorldwideTariff.all
    redirect_to :action => :payment_method if request.post? && @current_user.shipping_addresses.create(params[:shipping_address])
  end

  def edit_address
    @shipping_address = @current_user.shipping_addresses.find(params[:id])
    @countries = WorldwideTariff.all
    redirect_to :action => :payment_method if request.post? && @shipping_address.update_attributes(params[:shipping_address])
  end

  def payment_method
    @credit_card = @current_user.credit_cards.new(params[:credit_card])
    if request.post?
      exist_card = @current_user.credit_cards.find_by_card_type_and_card_number_and_expiration_month_and_expiration_year(@credit_card.card_type, @credit_card.card_number, @credit_card.expiration_month, @credit_card.expiration_year)
      if exist_card
        @credit_card = exist_card
        flash.now[:success] = "Credit card exist"
      else
        if @credit_card.save
          flash.now[:success] = "Credit card saved"
        end
      end
    end
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
