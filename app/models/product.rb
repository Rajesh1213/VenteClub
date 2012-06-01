class Product < ActiveRecord::Base

  belongs_to :event
  belongs_to :color
  belongs_to :size
  has_many :properties, :dependent => :destroy
  has_many :images, :dependent => :destroy, :order => "id DESC"
  has_many :product_orders, :dependent => :destroy
  has_many :orders, :through => :product_orders

  default_scope :order => "name ASC"

  validates :event_id, :numericality => true
  validates :color_id, :numericality => true
  validates :size_id, :numericality => true
  validates :name, :presence => true
  validates :description, :presence => true
  validates :amount, :numericality => true
  validates :price, :numericality => true
  validates :old_price, :numericality => true
  validate :check_images, :if => "self.images.size == 0"

  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :properties, :allow_destroy => true

  after_initialize :set_init


  def event_similar_products
    Product.includes(:color, :size).where(:event_id => self.event_id).find_all_by_name(self.name)
  end

  def colors
    event_similar_products.collect { |product| product.color }.uniq.sort { |x, y| x.name <=> y.name }
  end

  def available_colors
    event_similar_products.collect { |product| product.color if product.size == self.size }.compact.uniq.sort { |x, y| x.name <=> y.name }
  end

  def sizes
    event_similar_products.collect { |product| product.size }.uniq.sort { |x, y| x.name <=> y.name }
  end

  def available_sizes
    event_similar_products.collect { |product| product.size if product.color == self.color }.compact.uniq.sort { |x, y| x.name <=> y.name }
  end

  def sold_out?
    self.amount <= 0
  end

  def has_size?
    !(self.sizes.size == 1 && self.sizes[0].name == "-no size-")
  end

  def has_color?
    !(self.colors.size == 1 && self.colors[0].name == "-no color-")
  end

  def as_json(options = {})
    {
        :id => self.id,
        :name => self.name,
        :price => number_to_currency(self.price),
        :old_price => number_to_currency(self.old_price),
        :sold_out => self.sold_out?,
        :images => self.images,
        :sizes => self.sizes,
        :available_sizes => self.available_sizes,
        :colors => self.colors,
        :available_colors => self.available_colors
    }
  end

  def duplicate
    properties = []
    self.properties.each { |property|
      properties << Property.new(:name => property.name, :value => property.value)
    }
    images = []
    self.images.each { |image|
      new_filename = generate_file_name
      image.product_sizes.each { |size|
        if File.exist?("#{Rails.root}/public/pictures/#{size + "/" + image.file_name}")
          File.copy("#{Rails.root}/public/pictures/#{size + "/" + image.file_name}", "#{Rails.root}/public/tmp/#{size + "/" + new_filename}")
        end
      }
      images << Image.new(:file_name => new_filename)
    }
    Product.new(
        :event => self.event, :color => self.color, :size => self.size, :name => self.name, :description => self.description,
        :price => self.price, :old_price => self.old_price, :properties => properties, :images => images
    )
  end

  private

  def set_init
    self.size_id = Size.find_by_name("-no size-") unless self.size_id
    self.color_id = Color.find_by_name("-no color-") unless self.color_id
  end

  def check_images
    self.errors.add(:images, "product need to have atleast one image")
  end

  def number_to_currency(number)
    Helper.instance.number_to_currency(number, :unit => "")
  end

  class Helper
    include Singleton
    include ActionView::Helpers::NumberHelper
  end

  def generate_file_name(size = 20)
    charset = %w{0 1 2 3 4 5 6 7 8 9 A B C D E F G H i J K L M N P S Q R T V W X Y Z q w e r t y u i o p a s d f g h j k l z x c v b n m}
    (0...size).map { charset.to_a[rand(charset.size)] }.join + ".jpg"
  end

end
