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

  private

  def set_init
    self.size_id = Size.first.id unless self.size_id
    self.color_id = Color.first.id unless self.color_id
  end

  private

  def number_to_currency(number)
    Helper.instance.number_to_currency(number, :unit => "")
  end

  class Helper
    include Singleton
    include ActionView::Helpers::NumberHelper
  end

end
