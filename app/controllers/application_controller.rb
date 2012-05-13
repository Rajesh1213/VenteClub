class ApplicationController < ActionController::Base

  protect_from_forgery

  private

  def menu_data
    @top_categories = TopCategory.all
  end

  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end

  def authorize_user
    current_user
    if @current_user.nil?
      redirect_to :controller => :login, :action => :unauthorized
    end
    update_cart
  end

  def authorize_admin
    current_user
    if @current_user.nil? || @current_user.role != "admin"
      redirect_to :controller => :login, :action => :unauthorized
    end
  end

  def update_ip
    new_ip = request.env["HTTP_X_FORWARDED_FOR"].to_s
    new_ip = request.remote_ip.to_s if new_ip == ""
    if current_user && @current_user.ip != new_ip
      geocoder = Geocoder.search(new_ip)[0]
      country = geocoder.data["country_name"]
      city = geocoder.data["city"]
      @current_user.update_attributes(:ip => new_ip, :country => country, :city => city)
    end
  end

  def update_cart
    unless session[:order]
      session[:order] = @current_user.orders.new
    else
      products = Product.find(session[:order].products.collect { |product| product.id })
      session[:order] = @current_user.orders.new(:products => products)
    end
  end

  def generate_pass(size = 6)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K L M N P Q R T V W X Y Z}
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end

end
