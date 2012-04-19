class ColorsController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Colors list"
    @colors = Color.all
  end

  def new
    @page_title = "New color"
    @javascript = true
    unless request.post?
      @color = Color.new
    else
      @color = Color.new(params[:color])
      if @color.save
        flash[:success] = "Color: #{@color.name} added"
        redirect_to :action => :list
      end
    end
  end

  def edit
    @page_title = "Edit color"
    @javascript = true
    @color = Color.find(params[:id])
    if request.post? && @color.update_attributes(params[:color])
      flash[:success] = "Color: #{@color.name} updated"
      redirect_to :action => :list
    end
  end

  def delete
    color = Color.find(params[:id])
    cc = color.clone
    if request.post? && color.destroy
      flash[:warning] = "Color: #{cc.name} was deleted"
      redirect_to :action => :list
    end
  end

end
