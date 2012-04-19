class Color < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true
  validates :html_val, :length => {:within => 7..7}, :uniqueness => true

end
