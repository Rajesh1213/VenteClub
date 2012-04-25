class UploadsController < ApplicationController

  require "process_image"

  before_filter :authorize_admin

  def image_upload
    if request.post?
      filename = params[:qqfile]
      if check_img_ext(filename)
        img_data = request.body.read
        new_filename = ProcessImage.new.do_it(img_data, params[:type])
        if new_filename
          render :json => {:success => true, :new_filename => new_filename + ".jpg"}
        else
          render :json => {:success => false}
        end
      else
        render :json => {:success => false}
      end
    end
  end

  private

  def check_img_ext(filename)
    result = false
    required = ['jpg', 'jpeg', 'png', 'gif', 'bmp']
    ext = filename.split(".").last
    required.each { |item|
      result = true if item.upcase == ext.upcase
    }
    result
  end

end
