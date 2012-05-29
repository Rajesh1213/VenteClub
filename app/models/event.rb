class Event < ActiveRecord::Base

  belongs_to :top_category
  has_many :products, :dependent => :destroy, :include => [:size, :color]
  has_one :small_image, :class_name => 'Image', :foreign_key => :event_id, :dependent => :destroy
  has_one :big_image, :class_name => 'Image', :foreign_key => :event_big_id, :dependent => :destroy
  has_many :sizes, :through => :products, :uniq => true
  has_many :colors, :through => :products, :uniq => true

  default_scope :order => "end_at ASC"

  scope :upcoming, where("start_at > ?", DateTime.now)
  scope :current, where("start_at <= ? AND end_at >= ?", DateTime.now, DateTime.now)
  scope :past, where("end_at < ?", DateTime.now)

  validates :top_category_id, :numericality => true
  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true

  accepts_nested_attributes_for :small_image
  accepts_nested_attributes_for :big_image

  after_initialize :set_dates

  def self.today
    find(:all, :conditions => ["start_at <= ? AND end_at > ?", Date.today, Date.today + 2.days])
  end

  def self.ending_soon
    find(:all, :conditions => ["end_at >= ? AND end_at <= ?", Date.today, Date.today + 2.days])
  end

  def products_for_page
    result = self.products
    helper = result
    result.each { |product1|
      helper.each { |product2|
        if product1.name == product2.name && product1.color.id == product2.color.id && product1.size.id != product2.size.id
          result = result - [product1]
          helper = helper - [product1]
        end
      }
    }
    result
  end

  def product_sold_out?(product)
    result = true
    product.event_similar_products.each { |similar_product|
      result = false if !similar_product.sold_out?
    }
    result
  end

  def state
    state = "upcoming" if Event.upcoming.include?(self)
    state = "current" if Event.current.include?(self)
    state = "past" if Event.past.include?(self)
    state
  end

  private

  def set_dates
    self.start_at = DateTime.now unless self.start_at
    self.end_at = start_at + 1.week unless self.end_at
    self.build_small_image unless self.small_image
    self.build_big_image unless self.big_image
  end

end
