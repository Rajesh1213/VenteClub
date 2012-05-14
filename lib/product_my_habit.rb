class ProductMyHabit

  require "open-uri"
  require "process_image"
  require "file_manipulation"

  def initialize
    @browser = Watir::Browser.new :firefox
  end

  def product_from_url(url)
    js = initial_js(url)
    js_product_url = js_product_url(js, url)
    if js_product_url
      FileManipulation.to_file("#{Rails.root}/public/tmp/mh_data", js)
    else
      js = FileManipulation.from_file("#{Rails.root}/public/tmp/mh_data")
      js_product_url = js_product_url(js, url)
    end
    product_hash = product_hash_from_url(js_product_url)
    params = params_from_hash(product_hash, product_cAsin(url))
    Product.new(params)
  end

  private

  def params_from_hash(product_hash, cAsin)
    result = Hash.new
    result["name"] = product_hash["detailJSON"]["short_title"]
    result["description"] = product_hash["productDescription"]["shortProdDesc"]
    result["price"] = product_hash["detailJSON"]["ourPrice"]["amount"]
    result["old_price"] = product_hash["detailJSON"]["listPrice"]["amount"]
    result["properties"] = process_properties(product_hash)
    result["images"] = process_images(product_hash, cAsin)
    result["color_id"] = process_color(product_hash, cAsin)
    result
  end

  def process_properties(product_hash)
    result = []
    properties = product_hash["productDescription"]["bullets"][0]["bulletsList"]
    properties = properties[1..properties.length-1]
    properties.each { |mh_property|
      mh_property.gsub!("&quot;", '"')
      mh_property.gsub!("&#39;", "'")
      splitted = mh_property.split(": ")
      property_name = splitted[0]
      property_value = splitted[1..splitted.size-1]
      result << Property.new(:name => property_name, :value => property_value)
    }
    result
  end

  def process_images(product_hash, cAsin)
    images = []
    required_asin = {}
    product_hash["detailJSON"]["asins"].each { |asin|
      required_asin = asin if asin["asin"] == cAsin
    }
    images_arr = required_asin["altviews"]
    images_arr.each { |img_hash|
      img = get_file(img_hash["zoomImage"])
      filename = ProcessImage.new.do_it(img, "product") + ".jpg"
      images << Image.new(:file_name => filename)
    }
    images
  end

  def process_color(product_hash, cAsin)
    required_asin = {}
    product_hash["detailJSON"]["asins"].each { |asin|
      required_asin = asin if asin["asin"] == cAsin
    }
    color_id = 1
    html_val = html_color(product_hash, required_asin)
    color = Color.find_by_html_val(html_val)
    if color
      color_id = color.id
    else
      color_name = "unknown"
      product_hash["detailJSON"]["variationMatrix"]["dimensionMatrix"][0]["values"].each { |color_data|
        color_name = color_data["displayText"] if color_data["imageURL"] == required_asin["swatchImage"]
      }
      new_color = Color.create(:name => color_name, :html_val => html_val)
      color_id = new_color.id
    end
    color_id
  end

  def html_color(product_hash, required_asin)
    color_image_url = required_asin["swatchImage"]
    color_image = get_file(color_image_url)
    color = ProcessImage.new.get_color(color_image).to_s
    color
  end

  def product_hash_from_url(url)
    file = get_file(url)
    js_start = file.index('{"detailJSON":{"')
    js_end = file.length - 3
    ActiveSupport::JSON.decode(file[js_start..js_end])
  end

  def get_file(url)
    open(url).read
  end

  def js_product_url(js, url)
    product_id = product_id(url)
    sale_id = sale_id(url)
    sale = Hash.new
    decoded_js = ActiveSupport::JSON.decode(js)
    decoded_js["sales"].each { |sale_i|
      sale = sale_i if sale_i["id"] == sale_id
    }
    sale["asins"][product_id]["url"] if sale["asins"]
  end

  def initial_js(url)
    @browser.goto(url)
    @browser.text_field(:name => 'email').set 'vova4kin@list.ru'
    @browser.text_field(:name => 'password').set '111111'
    @browser.button(:id => "signInSubmit").click
    #@browser.div(:id => "altImage0").click
    js_start = @browser.html.index("var payload = {") + 14
    js_end = @browser.html.index('QueryLogUtils.recordTime("gw_ld");') - 3
    js = @browser.html[js_start..js_end]
    @browser.close
    js
  end

  def product_cAsin(url)
    p_start = url.index("&cAsin=") + 7
    p_end = url.index("&ref=") - 1
    url[p_start..p_end]
  end

  def product_id(url)
    p_start = url.index("&asin=") + 6
    p_end = url.index("&cAsin=") - 1
    url[p_start..p_end]
  end

  def sale_id(url)
    p_start = url.index("&sale=") + 6
    p_end = url.index("&asin=") - 1
    url[p_start..p_end]
  end

end