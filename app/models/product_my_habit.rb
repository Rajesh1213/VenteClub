class ProductMyHabit

  require 'open-uri'

  #img =  Magick::Image.read(path).first
  #pix = img.scale(1, 1)
  #averageColor = pix.pixel_color(0,0)


  def initialize
    @browser = Watir::Browser.new :firefox
  end

  def product_from_url(url)
    js = initial_js(url)
    js_product_url = js_product_url(js, url)
    product_hash = product_hash_from_url(js_product_url)
    params = params_from_hash(product_hash)
    Product.new(params)
  end

  private

  def params_from_hash(product_hash)
    result = Hash.new
    result["name"] = product_hash["detailJSON"]["title"]
    result["description"] = product_hash["productDescription"]["shortProdDesc"]
    result["price"] = product_hash["detailJSON"]["ourPrice"]["amount"]
    result["properties"] = process_properties(product_hash)
    result["images"] = process_images(product_hash)
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

  def process_images(product_hash)
    []
  end

  def html_color

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
    sale["asins"][product_id]["url"]
  end

  def initial_js(url)
    @browser.goto(url)
    @browser.text_field(:name => 'email').set 'vova4kin@list.ru'
    @browser.text_field(:name => 'password').set 'vova147258'
    @browser.button(:id => "signInSubmit").click
    js_start = @browser.html.index("var payload = {") + 14
    js_end = @browser.html.index('QueryLogUtils.recordTime("gw_ld");') - 3
    js = @browser.html[js_start..js_end]
    @browser.close
    #system("#{Rails.root}/lib/test.rb")
    js
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