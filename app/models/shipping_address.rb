class ShippingAddress < ActiveRecord::Base

  belongs_to :user
  belongs_to :country, :class_name => 'WorldwideTariff'
  belongs_to :order

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :address_line_1, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :postal_code, :presence => true
  validates :phone, :presence => true
  validates :country_id, :presence => true

  def full_name
    self.first_name + " " + self.last_name
  end

  def address_line_3
    self.city + ", " + self.state + " " + self.postal_code
  end

end
