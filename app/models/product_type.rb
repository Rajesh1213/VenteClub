class ProductType < ActiveRecord::Base

  has_many :flat_rate_products, :dependent => :destroy

  default_scope :order => "name ASC"

  validates :name, :presence => true, :uniqueness => true

  def as_json(options = {})
    {
        :id => self.id,
        :name => self.name,
        :flat_rate_products => self.flat_rate_products
    }
  end

end
