class Size < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  default_scope :order => "name ASC"

  validates :name, :presence => true, :uniqueness => true

  def as_json(options = {})
    {
        :id => self.id,
        :name => self.name
    }
  end

end
