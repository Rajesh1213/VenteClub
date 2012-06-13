class WorldwideTariffsController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Worldwide tariffs"
    @tariffs = WorldwideTariff.all
  end

  def new
    @page_title = "New Country"
    unless request.post?
      @tariff = WorldwideTariff.new
    else
      @tariff = WorldwideTariff.new(params[:tariff])
      if @tariff.save
        flash[:success] = "Country: #{@tariff.country} created"
        redirect_to :action => :list
      end
    end
  end

  def edit
    @tariff = WorldwideTariff.find(params[:id])
    @page_title = "Edit worldwide tariff for: #{@tariff.country}"
    if request.post? && @tariff.update_attributes(params[:tariff])
      flash[:success] = "Worldwide tariff for: #{@tariff.country} updated"
      redirect_to :action => :list
    end
  end

  def delete
    tariff = WorldwideTariff.find(params[:id])
    tc = tariff.clone
    if request.post? && tariff.destroy
      flash[:warning] = "Country: #{tc.country} was deleted"
      redirect_to :action => :list
    end
  end

end
