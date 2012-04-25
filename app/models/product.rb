class Product < ActiveRecord::Base

  belongs_to :event
  belongs_to :color
  belongs_to :size
  has_many :properties, :dependent => :destroy
  has_many :images, :dependent => :destroy

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

  private

  def set_init
    self.size_id = Size.first.id unless self.size_id
    self.color_id = Color.first.id unless self.color_id
  end

end
