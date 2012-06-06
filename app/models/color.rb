class Color < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  default_scope :order => "name ASC"

  after_update :update_products

  validates :name, :presence => true
  validates :html_val, :length => {:within => 7..7}, :uniqueness => true

  def as_json(options = {})
    {
        :id => self.id,
        :name => self.name,
        :html_val => self.html_val
    }
  end

  private

  def update_products
    self.products.each { |product| product.touch }
  end

end
