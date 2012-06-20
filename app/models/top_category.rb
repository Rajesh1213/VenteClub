class TopCategory < ActiveRecord::Base

  has_many :events, :dependent => :destroy

  default_scope :order => "sorting DESC"

  validates :name, :presence => true, :uniqueness => true
  validates :sorting, :numericality => true

end
