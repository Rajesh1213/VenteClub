class ProductsController < ApplicationController

  require "product_my_habit"

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Products list"
    @top_categories = TopCategory.all
  end

  def new
    @page_title = "New product"
    @javascript = true
    unless request.post?
      @event = Event.find(params[:id])
      if session[:product]
        @product = session[:product]
        session.delete("product")
      else
        @product = @event.products.new
      end
    else
      @product = Product.new(params[:product])
      @event = @product.event
      if @product.save
        flash[:success] = "Product: #{@product.name} created"
        redirect_to :action => :list
      end
    end
  end

  def from_myhabit
    @page_title = "New product from MyHabit link"
    @event = Event.find(params[:id])

    if request.post?
      @event = Event.find(params[:event_id])
      @product = Product.new
      Headless.ly do
        @product = ProductMyHabit.new().product_from_url(params[:url])
      end
      @product.event_id = @event.id
      session[:product] = @product
      redirect_to :action => :new, :id => @event
    end
  end

  def edit
    @page_title = "Edit product"
    @javascript = true
    @product = Product.find(params[:id])
    @event = @product.event
    if request.post? && @product.update_attributes(params[:product])
      flash[:success] = "Product: #{@product.name} updated"
      redirect_to :action => :list
    end
  end

  def copy
    @page_title = "New product"
    product = Product.find(params[:id])
    @product = product.clone
    @event = @product.event
    render :action => :new
  end

  def delete
    product = Product.find(params[:id])
    pc = product.clone
    if request.post? && product.destroy
      flash[:warning] = "Product: #{pc.name} was deleted"
      redirect_to :action => :list
    end
  end

end
