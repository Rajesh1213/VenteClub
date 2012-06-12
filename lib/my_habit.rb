class MyHabit

  require "open-uri"
  require "process_image"
  require "file_manipulation"

  def initialize
    @browser = Watir::Browser.new :firefox
  end

  def event_from_url(url, top_category)
    log_in(url)
    @browser.execute_script('PrivateSaleData.Sales.fetch({affectPage:true, success:function (m) {$("#customerName").text(JSON.stringify(m));}});')
    sleep 3
    sales_text = @browser.execute_script('return $("#customerName").text();')
    sales = ActiveSupport::JSON.decode(sales_text)
    mh_sale = interested_sale(sales, url)
    event = Event.create(sale_params_from_hash(mh_sale, top_category))
    sale_id = sale_id(url)
    sale_dept = sale_dept(url)
    asins = asins_for_event(mh_sale, sale_id)
    urls_for_products = []
    i = 0
    asins.each { |asin|
      urls_for_products << product_url_from_asin(asin, i, sale_id, sale_dept)
      i+=1
    }
    urls_for_products.each { |product_url|
      product_from_url(product_url, event, close_browser=false)
    }
    @browser.close
    event
  end

  def product_from_url(url, event, close_browser=true)
    js_url = ""
    if close_browser
      log_in(url)
      js_url = product_initial_js_url(url)
      @browser.close
    else
      @browser.goto(url)
      js_url = product_initial_js_url(url)
    end
    #js_product_url = js_product_url(js, url)
    #if js_product_url
    #  FileManipulation.to_file("#{Rails.root}/public/tmp/mh_data", js)
    #else
    #  js = FileManipulation.from_file("#{Rails.root}/public/tmp/mh_data")
    #  js_product_url = js_product_url(js, url)
    #end
    product_hash = product_hash_from_url(js_url)
    sizes = process_sizes(product_hash)
    params = product_params_from_hash(product_hash, product_cAsin(url), event)
    product = Product.new(params)
    i = 0
    sizes.each { |size|
      if i == 0
        product.size = size
        product.save
        p product.errors.inspect
      else
        new_product = product.duplicate
        new_product.size = size
        new_product.save
        p new_product.errors.inspect
      end
      i+= 1
    }
    product
  end

  private

  # event processing

  def product_url_from_asin(asin, i, sale_id, sale_dept)
    "http://www.myhabit.com/homepage#page=d&dept=#{sale_dept}&sale=#{sale_id}&asin=#{asin["asin"]}&cAsin=#{asin["cAsin"]}&ref=qd_b_img_d_#{i.to_s}"
  end

  def asins_for_event(mh_sale, sale_id)
    event_js = get_file(mh_sale["dataURL"])
    js_start = event_js.index("parse_sale_") + 11 + sale_id.size + 1
    js_end = event_js.index("]});") + 1
    json_data = event_js[js_start..js_end]
    ActiveSupport::JSON.decode(json_data)["asins"]
  end

  def sale_params_from_hash(mh_sale, top_category)
    result = Hash.new
    result["top_category"] = top_category
    result["name"] = mh_sale["saleProps"]["primary"]["title"]
    result["description"] = mh_sale["saleProps"]["primary"]["desc"]
    result["original_url"] = mh_sale["saleProps"]["primary"]["brandUrl"]
    start_time = mh_sale["start"]["time"]
    start_offset = mh_sale["start"]["offset"]
    end_time = mh_sale["end"]["time"]
    end_offset = mh_sale["end"]["offset"]
    result["start_at"] = DateTime.strptime(start_time, '%Y-%m-%dT%H:%M:%S.000Z') + start_offset.to_i.minutes
    result["end_at"] = DateTime.strptime(end_time, '%Y-%m-%dT%H:%M:%S.000Z') + end_offset.to_i.minutes
    images = process_event_images(mh_sale)
    result["big_image"] = images[:big_image]
    result["small_image"] = images[:small_image]
    result
  end

  def process_event_images(mh_sale)
    big_img_url = mh_sale["saleProps"]["primary"]["imgs"]["hero"]
    small_img_url = mh_sale["saleProps"]["primary"]["imgs"]["sale"]
    big_img_orig = get_file(big_img_url)
    small_img_orig = get_file(small_img_url)
    big_filename = ProcessImage.new.do_it(big_img_orig, "event_big") + ".jpg"
    small_filename = ProcessImage.new.do_it(small_img_orig, "event_small") + ".jpg"
    {:big_image => Image.new(:file_name => big_filename), :small_image => Image.new(:file_name => small_filename)}
  end

  def interested_sale(sales, url)
    dept_sales = sales[sale_dept(url)]
    sale = sale_from_dept_hash(dept_sales["current"], url)
    return sale unless sale.empty?
    sale = sale_from_dept_hash(dept_sales["endingSoon"], url)
    return sale unless sale.empty?
    sale = sale_from_dept_hash(dept_sales["upcoming"], url)
    return sale unless sale.empty?
  end

  def sale_from_dept_hash(sales, url)
    res_sale = {}
    sale_id = sale_id(url)
    sales.each { |sale|
      if sale.class.to_s == "Hash"
        res_sale = sale if sale["id"] == sale_id
      else
        sale.each { |sale_in|
          res_sale = sale_in if sale_in["id"] == sale_id
        }
      end
    }
    res_sale
  end

  # product processing

  def product_params_from_hash(product_hash, cAsin, event)
    result = Hash.new
    result["name"] = product_hash["detailJSON"]["short_title"]
    result["description"] = product_hash["productDescription"]["shortProdDesc"]
    result["price"] = product_hash["detailJSON"]["ourPrice"]["amount"] || product_hash["detailJSON"]["ourPrice"]["amountHigh"]
    result["old_price"] = product_hash["detailJSON"]["listPrice"]["amount"] || product_hash["detailJSON"]["listPrice"]["amountHigh"]
    result["properties"] = process_properties(product_hash)
    result["images"] = process_product_images(product_hash, cAsin)
    result["color_id"] = process_color(product_hash, cAsin)
    result["event_id"] = event.id
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
      property_value = splitted[1..splitted.size-1].join(": ")
      result << Property.new(:name => property_name, :value => property_value)
    }
    result
  end

  def process_product_images(product_hash, cAsin)
    images = []
    required_asin = {}
    if product_hash["detailJSON"]["asins"].size > 0
      product_hash["detailJSON"]["asins"].each { |asin|
        required_asin = asin if asin["asin"] == cAsin
      }
    else
      required_asin = product_hash["detailJSON"]["main"]
    end
    images_arr = required_asin["altviews"]
    images_arr.each { |img_hash|
      img = get_file(img_hash["zoomImage"])
      filename = ProcessImage.new.do_it(img, "product") + ".jpg"
      images << Image.new(:file_name => filename)
    }
    images.reverse!
  end

  def process_color(product_hash, cAsin)
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

  def process_sizes(product_hash)
    sizes = []
    product_hash["detailJSON"]["variationMatrix"]["dimensionMatrix"].each { |property|
      if property["name"] == "size_name"
        property["values"].each { |size_data|
          size_name = size_data["displayText"]
          size = Size.find_by_name(size_name)
          unless size
            size = Size.create(:name => size_name)
          end
          sizes << size
        }
      end
    }
    sizes << Size.find_by_name("-no size-") if sizes.size == 0
    sizes
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

  def product_initial_js_url(url)
    sleep 3
    done = false
    i = 0
    until done
      begin
        @browser.div(:id => "altImage0").click
        @browser.execute_script('$.ajax({url:"/request/getPrivateSale", dataType:"json", data:{sale:"' + sale_id(url) + '", preview:"0"}, success:function (m) {$("#pdHeader").text(JSON.stringify(m));}, beforeSend:authorizeRequest});')
        #js_start = @browser.html.index("var payload = {") + 14
        sleep 3
        sale_text = @browser.execute_script('return $("#pdHeader").text();')
        #js_end = @browser.html.index('QueryLogUtils.recordTime("gw_ld");') - 3
        #js = @browser.html[js_start..js_end]
        sale = ActiveSupport::JSON.decode(sale_text)
        done = true
      rescue
        @browser.refresh
        done = true if i > 10
      end
      i += 1
    end
    sale["sales"][0]["prefix"] + sale["sales"][0]["asins"][product_id(url)]["url"]
  end

  def log_in(url)
    @browser.goto(url)
    @browser.text_field(:name => 'email').set 'vova4kin@list.ru'
    @browser.text_field(:name => 'password').set '111111'
    @browser.button(:id => "signInSubmit").click
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
    p_end = url.index("&", p_start) - 1
    url[p_start..p_end]
  end

  def sale_dept(url)
    p_start = url.index("&dept=") + 6
    p_end = url.index("&", p_start) - 1
    url[p_start..p_end].downcase
  end

end