class Size < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

end
