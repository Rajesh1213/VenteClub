class Event < ActiveRecord::Base

  belongs_to :top_category
  has_many :products, :dependent => :destroy
  has_one :small_image, :class_name => 'Image', :foreign_key => :event_id, :dependent => :destroy
  has_one :big_image, :class_name => 'Image', :foreign_key => :event_big_id, :dependent => :destroy

  default_scope :order => "end_at ASC"

  scope :past, where("end_at < ?", Date.today)

  #find(:all, :conditions => ["published_at <= ?", Time.now], :include => :comments)
  #scope :today, find(:all, :conditions => ["start_at <= ? AND end_at > ?", Date.today, Date.today + 2.days])
  #scope :ending_soon, where("start_at <= ? AND end_at <= ?", [Date.today, Date.today + 2.days])
  scope :upcoming, where("start_at > ?", Date.today)

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


  private

  def set_dates
    self.start_at = DateTime.now unless self.start_at
    self.end_at = start_at + 1.week unless self.end_at
    self.build_small_image unless self.small_image
    self.build_big_image unless self.big_image
  end

end
