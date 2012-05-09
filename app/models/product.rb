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

  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :properties, :allow_destroy => true

  after_initialize :set_init

  def colors
    similar_products.collect { |product| product.color }
  end

  def sizes
    similar_products.collect { |product| product.size }
  end

  def similar_products
    Product.includes(:color, :size).find_all_by_name(self.name)
  end

  private

  def set_init
    self.size_id = Size.first.id unless self.size_id
    self.color_id = Color.first.id unless self.color_id
  end

end
