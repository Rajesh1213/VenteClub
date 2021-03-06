class VictoriasSecret

  require "open-uri"
  require "process_image"
  require "file_manipulation"

  def initialize
    @browser = Watir::Browser.new :firefox
  end

  def event_from_url(url, top_category)

    @browser.close
    event
  end

  def product_from_url(url, event, close_browser=true)
    @browser.goto(url)
    name = @browser.h1(:class => 'x-large m-b-10 cufon-replaced').text
    description = @browser.p(:class => 'm-b-10').text
    product_matrix = get_product_matrix
    color_data = color_data_divs(product_matrix)
    sizes = process_sizes(product_matrix)
    colors = process_colors(product_matrix, color_data)
    product = Product.new
    i = 0
    colors.each { |color|
      if i == 0
        images = process_first_product_images
        images = process_other_product_images(color_data[color[:color_code]]) if images.size == 0
        if images.size == 0
          images = [image_from_url(@browser.image(:id => "vsImage").src)]
        end
      else
        images = process_other_product_images(color_data[color[:color_code]])
        images = product.duplicate.images if images.size == 0
      end
      j = 0
      sizes.each { |size|
        if j == 0
          product = new_product(name, description, color[:color], size, images, event, url)
          product.save
          p product.errors
        else
          new_product = product.duplicate
          new_product.size = size
          new_product.save
          p new_product.errors
        end
        j+= 1
      }
      i+= 1
    }
    @browser.close if close_browser
    product
  end

  private

  def new_product(name, description, color, size, images, event, url)
    params = Hash.new
    params["name"] = name
    params["description"] = description
    prices = process_prices
    params["price"] = prices[:price]
    params["old_price"] = prices[:old_price]
    params["properties"] = process_properties
    params["images"] = images
    params["color"] = color
    params["size"] = size
    params["original_url"] = url
    event.products.new(params)
  end

  def process_colors(product_matrix, color_data)
    colors = []
    product_matrix.each { |product|
      color_code = product["COLOR_CDE"].to_s
      if color_data.has_key?(color_code)
        html_val = html_color(color_img_url(color_data[color_code]))
        color = Color.find_by_html_val(html_val)
        if color
          colors << {:color => color, :color_code => color_code}
        else
          color_name = product["COLOR_NAME"][color_code.size + 1..product["COLOR_NAME"].size].capitalize
          new_color = Color.create(:name => color_name, :html_val => html_val)
          colors << {:color => new_color, :color_code => color_code}
        end
      end
    }
    colors.uniq
  end

  def color_img_url(color_div)
    color_div.links.collect { |link| link.img.src }[0]
  end

  def html_color(img_url)
    color_image = get_file(img_url)
    color = ProcessImage.new.get_color(color_image).to_s
    color
  end

  def color_data_divs(product_matrix)
    color_data = {}
    @browser.divs(:class => 'swatch').each { |color_div|
      div_html = color_div.html
      str = div_html.split("', '")[2]
      if str
        color_code = str[0..str.index("');") - 1].to_s
      else
        str = div_html.split("this,'")[1]
        color_code = str[0..str.index("-") - 1].to_s if str
      end
      if color_code
        product_matrix.each { |product|
          color_data[color_code] = color_div if product["COLOR_CDE"].to_s == color_code && !color_data.has_key?(color_code)
        }
      end
    }
    color_data
  end

  def process_other_product_images(color_div)
    str = color_div.html.split("http://")[1]
    if str.index("', '")
      url = "http://" + str[0..str.index("', '") - 1]
      [image_from_url(url)]
    else
      []
    end
  end

  def process_first_product_images
    images = []
    if @browser.div(:id => 'altImages').exists?
      @browser.div(:id => 'altImages').links.each { |link|
        images << image_from_url(link.href)
      }
    end
    images.reverse!
  end

  def image_from_url(url)
    img = get_file(url)
    filename = ProcessImage.new.do_it(img, "product") + ".jpg"
    Image.new(:file_name => filename)
  end

  def process_properties
    properties = []
    @browser.div(:class => 'details').ul.text.split("\n").each { |property|
      splitted = property.split(": ")
      property_name = splitted[0]
      property_value = splitted[1..splitted.size-1].join(": ")
      properties << Property.new(:name => property_name, :value => property_value)
    }
    properties
  end

  def process_prices
    result = {}
    text = @browser.p(:class => 'm-t-10').text
    text_arr = text.split(" ")
    if text_arr.size == 2
      result = {:price => BigDecimal.new(text_arr[0].gsub("$", "")), :old_price => 0}
    else
      if text.index("Special")
        result = {:price => BigDecimal.new(text_arr[0].gsub("$", "")), :old_price => 0}
      else
        if text_arr.size > 5
          result = {:price => BigDecimal.new(text_arr[text_arr.size - 2].gsub("$", "")), :old_price => 0}
        else
          result = {:price => BigDecimal.new(text_arr[3].gsub("$", "")), :old_price => BigDecimal.new(text_arr[1].gsub("$", ""))}
        end
      end
    end
    result
  end

  def process_sizes(product_matrix)
    sizes = []
    size_names = @browser.select_list(:id => 'sizeselectorlabel.size_0').options.map(&:text)
    size_names[1..size_names.size].each { |size_name|
      size = Size.find_by_name(size_name)
      unless size
        size = Size.create(:name => size_name)
      end
      sizes << size
    }
    sizes << Size.find_by_name("-no size-") if sizes.size == 0
    sizes
  end

  def get_file(url)
    open(url).read
  end

  def get_product_matrix
    js_id = @browser.input(:name => 'PRODUCTID').value
    matrix_js = get_file("http://www.victoriassecret.com/atp/#{js_id}.json")
    ActiveSupport::JSON.decode(matrix_js)["SKUS"]
  end

end