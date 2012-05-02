class Property < ActiveRecord::Base

  belongs_to :product

  default_scope :order => "name ASC"

  validates :name, :presence => true

end
