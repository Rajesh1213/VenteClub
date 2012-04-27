class Event < ActiveRecord::Base

  belongs_to :top_category
  has_many :products, :dependent => :destroy
  has_one :small_image, :class_name => 'Image', :foreign_key => :event_id, :dependent => :destroy
  has_one :big_image, :class_name => 'Image', :foreign_key => :event_big_id, :dependent => :destroy

  default_scope :order => "end_at ASC"

  validates :top_category_id, :numericality => true
  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true

  accepts_nested_attributes_for :small_image
  accepts_nested_attributes_for :big_image

  after_initialize :set_dates

  private

  def set_dates
    self.start_at = DateTime.now unless self.start_at
    self.end_at = start_at + 1.week unless self.end_at
    self.build_small_image unless self.small_image
    self.build_big_image unless self.big_image
  end

end
