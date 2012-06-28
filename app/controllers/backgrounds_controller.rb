class BackgroundsController < ApplicationController

  before_filter :authorize_admin

  layout "admin"

  def email
    @page_title = "Email background"
    @javascript = true
    if request.post?
      if params[:new_file_name]
        if File.exist?("#{Rails.root}/public/tmp/backgrounds/#{params[:new_file_name]}")
          File.copy("#{Rails.root}/public/tmp/backgrounds/#{params[:new_file_name]}", "#{Rails.root}/public/pictures/backgrounds/email_bg.jpg")
          File.delete("#{Rails.root}/public/tmp/backgrounds/#{params[:new_file_name]}")
        end
      else
        flash.now[:error] = "You need to upload new image before saving"
      end
    end
  end

  def login
    @page_title = "Login background"
    @javascript = true
    if request.post?
      if params[:new_file_name]
        if File.exist?("#{Rails.root}/public/tmp/backgrounds/#{params[:new_file_name]}")
          File.copy("#{Rails.root}/public/tmp/backgrounds/#{params[:new_file_name]}", "#{Rails.root}/public/pictures/backgrounds/login_bg.jpg")
          File.delete("#{Rails.root}/public/tmp/backgrounds/#{params[:new_file_name]}")
        end
      else
        flash.now[:error] = "You need to upload new image before saving"
      end
    end
  end

end
