class Size < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  default_scope :order => "name ASC"

  after_update :update_products

  validates :name, :presence => true, :uniqueness => true

  def as_json(options = {})
    {
        :id => self.id,
        :name => self.name
    }
  end

  private

  def update_products
    self.products.each { |product| product.touch }
  end

end
