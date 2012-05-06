class FlatRateProduct < ActiveRecord::Base

  belongs_to :product_type

  has_one :image, :dependent => :destroy

  default_scope :order => "name ASC"

  validates :name, :presence => true, :uniqueness => true
  validates :weight, :numericality => {:greater_than => 0}
  validates :volume, :numericality => {:greater_than => 0}

  accepts_nested_attributes_for :image

  attr :user_data, true

  after_initialize :build_dependent

  def as_json(options = {})
    {
        :id => self.id,
        :name => self.name,
        :url => "/pictures/frp/" + self.image.file_name
    }
  end

  def total_cost
    total = self.user_data[:product_value] + self.shipping_cost + self.customs_duty + self.vat
    {
        :value => number_to_currency(self.user_data[:product_value]),
        :shipping_cost => number_to_currency(self.shipping_cost),
        :customs_duty => number_to_currency(self.customs_duty),
        :vat => number_to_currency(self.vat),
        :total => number_to_currency(total),
        :country => user_data[:worldwide_tariff].country.upcase,
        :name => self.name.upcase
    }
  end

  def shipping_cost
    user_data[:worldwide_tariff].price_for_weight(self.weight)
  end

  def customs_duty
    user_data[:product_value] * 0.2
  end

  def vat
    user_data[:worldwide_tariff].vat / 100 * user_data[:product_value]
  end

  private

  def build_dependent
    self.build_image unless self.image
  end

  def number_to_currency(number)
    Helper.instance.number_to_currency(number, :unit => "")
  end

  class Helper
    include Singleton
    include ActionView::Helpers::NumberHelper
  end

end
