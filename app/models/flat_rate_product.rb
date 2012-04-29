class FlatRateProduct < ActiveRecord::Base

  belongs_to :product_type

  has_one :image, :dependent => :destroy

  default_scope :order => "name ASC"

  validates :name, :presence => true, :uniqueness => true
  validates :weight, :numericality => true
  validates :volume, :numericality => true

  accepts_nested_attributes_for :image

  after_initialize :build_dependent

  def as_json(options = {})
    {
        :id => self.id,
        :name => self.name,
        :url => "/pictures/frp/" + self.image.file_name
    }
  end

  private

  def build_dependent
    self.build_image unless self.image
  end

end
