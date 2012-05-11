class TopCategory < ActiveRecord::Base

  has_many :events, :dependent => :destroy

  default_scope :order => "sorting DESC"

  #scope :today_events, joins(:events) & Event.today

  validates :name, :presence => true, :uniqueness => true
  validates :sorting, :numericality => true

end
