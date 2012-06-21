class ProductsController < ApplicationController

  #require "my_habit"

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Products list"
    @javascript = true
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
        if params[:commit] == "Save"
          redirect_to :action => :list, :state => @event.state
        elsif params[:commit] == "Save and Continue"
          @product = @event.products.new
        elsif params[:commit] == "Save and Duplicate"
          @product = @product.duplicate
        end
      end
    end
  end

  def from_myhabit
    @javascript = true
    @page_title = "New product from MyHabit URL"
    @event = Event.find(params[:id])
    if request.post?
      if FileManipulation.from_file("#{Rails.root}/tmp/background_task") == ""
        @event = Event.find(params[:event_id])
        product = Product.new
        Headless.ly do
          FileManipulation.to_file("#{Rails.root}/tmp/background_task", "true")
          begin
            product = MyHabit.new().product_from_url(params[:url], @event)
          rescue
            flash.now[:error] = "Incorrect URL"
          end
          FileManipulation.to_file("#{Rails.root}/tmp/background_task", "")
        end
        unless flash[:error]
          redirect_to :action => :edit, :id => product
        end
      else
        flash.now[:error] = "You have active background task!"
      end
    else
      flash.now[:warning] = "Background processing active" if FileManipulation.from_file("#{Rails.root}/tmp/background_task") != ""
    end
  end

  def from_victorias_secret
    @javascript = true
    @page_title = "New product from VictoriasSecret URL"
    @event = Event.find(params[:id])
    if request.post?
      if FileManipulation.from_file("#{Rails.root}/tmp/background_task") == ""
        @event = Event.find(params[:event_id])
        product = Product.new
        Headless.ly do
          FileManipulation.to_file("#{Rails.root}/tmp/background_task", "true")
          begin
            product = VictoriasSecret.new().product_from_url(params[:url], @event)
          rescue
            flash.now[:error] = "Incorrect URL"
          end
          FileManipulation.to_file("#{Rails.root}/tmp/background_task", "")
        end
      else
        flash.now[:error] = "You have active background task!"
      end
      unless flash[:error]
        redirect_to :action => :edit, :id => product
      else
        render :action => :from_myhabit
      end
    else
      flash.now[:warning] = "Background processing active" if FileManipulation.from_file("#{Rails.root}/tmp/background_task") != ""
      render :action => :from_myhabit
    end
  end

  def edit
    @page_title = "Edit product"
    @javascript = true
    @product = Product.find(params[:id])
    @event = @product.event
    if request.post? && @product.update_attributes(params[:product])
      flash[:success] = "Product: #{@product.name} updated"
      redirect_to :action => :list, :state => @event.state
    end
  end

  def delete
    product = Product.find(params[:id])
    pc = product.clone
    if request.post? && product.destroy
      flash[:warning] = "Product: #{pc.name} was deleted"
      redirect_to :action => :list, :state => pc.event.state
    end
  end

  def del_selected_products
    if request.post? && params[:products]
      Product.find(params[:products]).each { |product| product.destroy }
      render :text => "ok"
    else
      render :text => "No products selected"
    end
  end

end
