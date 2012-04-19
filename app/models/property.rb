class Property < ActiveRecord::Base

  belongs_to :product

  validates :name, :presence => true
  validates :value, :presence => true

end
