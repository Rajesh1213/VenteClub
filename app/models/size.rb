class Size < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  default_scope :order => "name ASC"

  validates :name, :presence => true, :uniqueness => true

end
