class AjaxController < ApplicationController

  before_filter :authorize_user, :only => [:shopping_cart_add, :shopping_cart_del, :change_quantity]
  before_filter :read_cart, :only => [:shopping_cart_add, :shopping_cart_del, :change_quantity]

  def update_data
    if request.post?
      color = Color.find(params[:color_id])
      size = Size.find(params[:size_id]) if params[:size_id] != "-1"
      product = Product.find(params[:product_id])
      similar_products = product.event_similar_products
      similar_products.each { |similar_product|
        if size
          product = similar_product if similar_product.size == size && similar_product.color == color
        else
          product = similar_product if similar_product.color == color
        end
      }
      render :json => {:product => product}
    end
  end

  def shopping_cart_add
    if request.post?
      product = Product.find(params[:id])
      unless @cart_order.products.include?(product)
        @cart_order.products << product
        session[:quantity][product.id] = 1
      end
      render :partial => "layouts/shopping_cart"
    end
  end

  def shopping_cart_del
    if request.post?
      product = Product.find(params[:id])
      @cart_order.products.delete(product)
      session[:quantity][product.id] = nil
      render :json => {:success => true, :total => @cart_order.items_price_human, :cart_items => @cart_order.items_human, :items_count => @cart_order.products.size}
    end
  end

  def change_quantity
    if request.post?
      product = Product.find(params[:id])
      session[:quantity][product.id] = request[:quantity].to_i
      read_cart
      #render :json => {:success => true}
      render :partial => "layouts/shopping_cart"
    end
  end

  def check_sold_out
    if request.post?
      size = Size.find(params[:size_id])
      products = Product.find(params[:products])
      result = []
      products.each { |product|
        result << Product.where(:event_id => product.event_id).where(:size_id => size.id).where(:color_id => product.color_id).find_by_name(product.name).sold_out?
      }
      render :json => result
    end
  end

  def flat_rate_products
    if request.post?
      product_type = ProductType.find(params[:product_type_id])
      render :json => {:product_type => product_type}
    end
  end

  def flat_rate_price
    if request.post?
      product_value = params[:product_value].gsub(",", ".").to_f
      if product_value > 0
        frp = FlatRateProduct.find(params[:id])
        frp.user_data = {:product_value => product_value, :worldwide_tariff => WorldwideTariff.find(params[:destination_id])}
        render :json => frp.total_cost
      else
        render :json => {:error => "Incorrect Value"}
      end
    end
  end

end
