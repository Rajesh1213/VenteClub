class Color < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  default_scope :order => "name ASC"

  validates :name, :presence => true
  validates :html_val, :length => {:within => 7..7}, :uniqueness => true

end
