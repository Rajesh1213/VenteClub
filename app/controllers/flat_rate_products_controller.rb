class FlatRateProductsController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def new
    @page_title = "New flat rate product"
    @javascript = true
    @product_type = ProductType.find(params[:id])
    unless request.post?
      @flat_rate_product = @product_type.flat_rate_products.new
    else
      @flat_rate_product = FlatRateProduct.new(params[:flat_rate_product])
      if @flat_rate_product.save
        flash[:success] = "Flat rate product: #{@flat_rate_product.name} created"
        redirect_to :controller => :product_types, :action => :list
      end
    end
  end

  def edit
    @page_title = "Edit flat rate product"
    @javascript = true
    @flat_rate_product = FlatRateProduct.find(params[:id])
    if request.post? && @flat_rate_product.update_attributes(params[:flat_rate_product])
      flash[:success] = "Flat rate product: #{@flat_rate_product.name} updated"
      redirect_to :controller => :product_types, :action => :list
    end
  end

  def delete
    flat_rate_product = FlatRateProduct.find(params[:id])
    pc = flat_rate_product.clone
    if request.post? && flat_rate_product.destroy
      flash[:warning] = "Flat rate product: #{pc.name} was deleted"
      redirect_to :controller => :product_types, :action => :list
    end
  end

end
