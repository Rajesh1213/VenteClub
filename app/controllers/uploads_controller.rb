class UploadsController < ApplicationController

  before_filter :authorize_admin

  require 'RMagick'

  def image_upload
    if request.post?
      filename = params[:qqfile]
      new_filename = generate_file_name(20)
      if check_img_ext(filename)
        tmp_file = "#{Rails.root}/public/tmp/#{new_filename}"
        File.open(tmp_file, 'wb') do |f|
          f.write request.body.read
          f.close
          begin
            resize_image(new_filename)
          rescue => e
            del_tmp_image(new_filename)
          end
        end
        render :json => {:success => true, :new_filename => new_filename + ".jpg"}
      else
        render :json => {:success => false}
      end
      del_tmp_image(new_filename)
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

  def generate_file_name(size = 10)
    charset = %w{0 1 2 3 4 5 6 7 8 9 A B C D E F G H i J K L M N P S Q R T V W X Y Z q w e r t y u i o p a s d f g h j k l z x c v b n m}
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end

  def resize_image(filename)
    width = height = 0
    sizes.each { |size|
      image = Magick::ImageList.new("#{Rails.root}/public/tmp/#{filename}")
      case size
        when 's'
          width = 128
          height = 128
        when 'm'
          width = 480
          height = 640
        when 'l'
          width = 960
          height = 1440
      end
      image.resize_to_fit!(width, height)
      image.new_image(image.first.columns, image.first.rows) { self.background_color = "white" }
      image = image.reverse.flatten_images
      image.strip!
      url = "#{Rails.root}/public/tmp/#{size + "/" + filename}" + ".jpg"
      image.write(url) { self.quality = 90 }
      File.chmod(0664, url)
    }
  end

  def del_tmp_image(filename)
    File.delete("#{Rails.root}/public/tmp/#{filename}") if File.exist?("#{Rails.root}/public/tmp/#{filename}")
    sizes.each { |size|
      File.delete("#{Rails.root}/public/tmp/#{size + "/" + filename}") if File.exist?("#{Rails.root}/public/tmp/#{size + "/" + filename}")
    }
  end

  def sizes
    Image.new.sizes
  end

end
