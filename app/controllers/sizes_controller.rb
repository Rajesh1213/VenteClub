class SizesController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Sizes list"
    @sizes = Size.all
  end

  def new
    @page_title = "New size"
    unless request.post?
      @size = Size.new
    else
      @size = Size.new(params[:size])
      if @size.save
        flash[:success] = "Size: #{@size.name} created"
        redirect_to :action => :list
      end
    end
  end

  def edit
    @page_title = "Edit size"
    @size = Size.find(params[:id])
    if request.post? && @size.update_attributes(params[:size])
      flash[:success] = "Size: #{@size.name} updated"
      redirect_to :action => :list
    end
  end

  def delete
    size = Size.find(params[:id])
    sc = size.clone
    if request.post? && size.destroy
      flash[:warning] = "Size: #{sc.name} was deleted"
      redirect_to :action => :list
    end
  end

end
