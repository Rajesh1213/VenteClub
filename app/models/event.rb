class Event < ActiveRecord::Base

  belongs_to :top_category
  has_many :products, :dependent => :destroy
  has_one :image

  default_scope :order => "end_at ASC"

  validates :top_category_id, :numericality => true
  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true

  accepts_nested_attributes_for :image

  after_initialize :set_dates

  private

  def set_dates
    self.start_at = DateTime.now unless self.start_at
    self.end_at = start_at + 1.week unless self.end_at
    self.build_image unless self.image
  end

end
