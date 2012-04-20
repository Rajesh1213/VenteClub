class WorldwideTariffsController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def list
    @page_title = "Worldwide tariffs"
    @tariffs = WorldwideTariff.all
  end

  def edit
    @tariff = WorldwideTariff.find(params[:id])

    @page_title = "Edit worldwide tariff for: #{@tariff.country}"
    if request.post? && @tariff.update_attributes(params[:tariff])
      flash[:success] = "Worldwide tariff for: #{@tariff.country} updated"
      redirect_to :action => :list
    end
  end

end
