class TopCategoriesController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Top categories"
    @top_categories = TopCategory.all
  end

  def new
    @page_title = "New top category"
    unless request.post?
      @top_category = TopCategory.new
    else
      @top_category = TopCategory.new(params[:top_category])
      if @top_category.save
        flash[:success] = "Top category #{@top_category.name} created"
        redirect_to :action => :list
      end
    end
  end

  def edit
    @page_title = "Edit top category"
    @top_category = TopCategory.find(params[:id])
    if request.post? && @top_category.update_attributes(params[:top_category])
      flash[:success] = "Top category #{@top_category.name} updated"
      redirect_to :action => :list
    end
  end

  def delete
    top_category = TopCategory.find(params[:id])
    tc = top_category.clone
    if request.post? && top_category.destroy
      flash[:warning] = "Top category #{tc.name} deleted"
      redirect_to :action => :list
    end
  end

end
