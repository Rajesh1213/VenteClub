class ProductTypesController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Product types list"
    @product_types = ProductType.all
  end

  def new
    @page_title = "New product type"
    unless request.post?
      @product_type = ProductType.new
    else
      @product_type = ProductType.new(params[:product_type])
      if @product_type.save
        flash[:success] = "Product type: #{@product_type.name} created"
        redirect_to :action => :list
      end
    end
  end

  def edit
    @page_title = "Edit product type"
    @product_type = ProductType.find(params[:id])
    if request.post? && @product_type.update_attributes(params[:product_type])
      flash[:success] = "Product type: #{@product_type.name} updated"
      redirect_to :action => :list
    end
  end

  def delete
    product_type = ProductType.find(params[:id])
    sc = product_type.clone
    if request.post? && product_type.destroy
      flash[:warning] = "Product type: #{sc.name} was deleted"
      redirect_to :action => :list
    end
  end

end
