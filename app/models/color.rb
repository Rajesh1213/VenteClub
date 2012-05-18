class Color < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  default_scope :order => "name ASC"

  validates :name, :presence => true
  validates :html_val, :length => {:within => 7..7}, :uniqueness => true

  def as_json(options = {})
    {
        :id => self.id,
        :name => self.name,
        :html_val => self.html_val
    }
  end

end
