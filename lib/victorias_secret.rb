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
    if close_browser
      @browser.goto(url)
      @browser.close
    else
      @browser.goto(url)
    end
    sizes = process_sizes
    params = product_params(url, event)
    product = Product.new(params)
    i = 0
    sizes.each { |size|
      if i == 0
        product.size = size
        product.save
      else
        new_product = product.duplicate
        new_product.size = size
        new_product.save
      end
      i+= 1
    }
    product
  end

  private

  def product_params(url, event)
    result = Hash.new
    result["name"] = @browser.h1(:class => 'x-large m-b-10 cufon-replaced').text
    result["description"] = @browser.p(:class => 'm-b-10').text
    prices = process_prices
    result["price"] = prices[:price]
    result["old_price"] = prices[:old_price]
    result["properties"] = process_properties
    result["images"] = process_product_images
    result["color_id"] = process_color
    result["event_id"] = event.id
    result
  end

  def process_color
    required_asin = {}
    product_hash["detailJSON"]["asins"].each { |asin|
      required_asin = asin if asin["asin"] == cAsin
    }
    color_id = Color.find_by_name("-no color-").id
    if required_asin != {}
      html_val = html_color(product_hash, required_asin)
      color = Color.find_by_html_val(html_val)
      if color
        color_id = color.id
      else
        color_name = ""
        product_hash["detailJSON"]["variationMatrix"]["dimensionMatrix"].each { |property|
          if property["name"] == "color_name"
            property["values"].each { |color_data|
              color_name = color_data["displayText"] if color_data["imageURL"] == required_asin["swatchImage"]
            }
            new_color = Color.create(:name => color_name, :html_val => html_val)
            color_id = new_color.id
          end
        }
      end
    end
    color_id
  end

  def html_color(product_hash, required_asin)
    color_image_url = required_asin["swatchImage"]
    color_image = get_file(color_image_url)
    color = ProcessImage.new.get_color(color_image).to_s
    color
  end

  def process_product_images
    images = []
    browser.div(:id => 'altImages').links.each { |link|
      img = get_file(link.href)
      filename = ProcessImage.new.do_it(img, "product") + ".jpg"
      images << Image.new(:file_name => filename)
    }
    images.reverse!
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
    text_arr = @browser.p(:class => 'm-t-10').text.split(" ")
    {:price => text_arr[3], :old_price => text_arr[1]}
  end

  def process_sizes
    sizes = []
    size_names = @browser.select_list(:id => 'sizeselectorlabel.size_0').options.map(&:text)
    size_names.each { |size_name|
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

end