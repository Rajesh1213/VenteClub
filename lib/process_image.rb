class ProcessImage

  require 'RMagick'

  def get_color(image)
    img = Magick::Image::read_inline(Base64.b64encode(image || self.data)).first
    one_pix_img = img.scale(1, 1)
    pix = one_pix_img.pixel_color(0, 0)
    one_pix_img.to_color(pix)
  end

  def do_it(image, model_name)
    new_filename = generate_file_name(20)
    tmp_file = "#{Rails.root}/public/tmp/#{new_filename}"
    File.open(tmp_file, 'wb') do |f|
      f.write image
      f.close
      begin
        if model_name == "product"
          resize_product_image(new_filename)
        elsif model_name == "event_small"
          resize_event_small_image(new_filename)
        elsif model_name == "event_big"
          resize_event_big_image(new_filename)
        end
        del_tmp_image(new_filename)
      rescue => e
        del_tmp_image(new_filename)
        del_tmp_images(new_filename)
        new_filename = nil
      end
    end
    new_filename
  end

  private

  def resize_event_small_image(filename)
    image = Magick::ImageList.new("#{Rails.root}/public/tmp/#{filename}")
    width = 235
    height = 257
    image = resize_image_manipulations(image, width, height)
    url = "#{Rails.root}/public/tmp/e/#{filename}" + ".jpg"
    image.write(url) { self.quality = 90 }
    File.chmod(0664, url)
  end

  def resize_event_big_image(filename)
    image = Magick::ImageList.new("#{Rails.root}/public/tmp/#{filename}")
    width = 972
    height = 507
    image = resize_image_manipulations(image, width, height)
    url = "#{Rails.root}/public/tmp/e_b/#{filename}" + ".jpg"
    image.write(url) { self.quality = 90 }
    File.chmod(0664, url)
  end

  def resize_product_image(filename)
    width = height = 0
    Image.new.product_sizes.each { |size|
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
      image = resize_image_manipulations(image, width, height)
      url = "#{Rails.root}/public/tmp/#{size + "/" + filename}" + ".jpg"
      image.write(url) { self.quality = 90 }
      File.chmod(0664, url)
    }
  end

  def del_tmp_image(filename)
    File.delete("#{Rails.root}/public/tmp/#{filename}") if File.exist?("#{Rails.root}/public/tmp/#{filename}")
  end

  def del_tmp_images(filename)
    Image.new.all_sizes.each { |dir|
      File.delete("#{Rails.root}/public/tmp/#{dir + "/" + filename}") if File.exist?("#{Rails.root}/public/tmp/#{dir + "/" + filename}")
    }
  end

  def generate_file_name(size = 10)
    charset = %w{0 1 2 3 4 5 6 7 8 9 A B C D E F G H i J K L M N P S Q R T V W X Y Z q w e r t y u i o p a s d f g h j k l z x c v b n m}
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end

  def resize_image_manipulations(image, width, height)
    image = image
    image.resize_to_fit!(width, height)
    image.new_image(image.first.columns, image.first.rows) { self.background_color = "white" }
    image = image.reverse.flatten_images
    image.strip!
    image
  end

end