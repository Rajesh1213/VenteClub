class User < ActiveRecord::Base

  has_many :shipping_addresses, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  has_many :credit_cards, :dependent => :destroy

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :mail, :presence => true, :uniqueness => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :pass, :presence => true, :length => {:minimum => 6}, :confirmation => true
  validates :customer_profile_id, :presence => true, :on => :update

  default_scope :order => "created_at ASC"

  accepts_nested_attributes_for :shipping_addresses, :allow_destroy => true
  accepts_nested_attributes_for :credit_cards, :allow_destroy => true

  attr_accessor :pass_confirmation

  attr_protected :role_id, :customer_profile_id

  before_create :update_pass, :send_mail
  after_create :create_customer_profile
  before_update :update_pass

  def full_name
    self.first_name + " " + self.last_name || self.mail
  end

  def suite
    "1234-" + (self.id + 1000).to_s
  end

  def role
    case self.role_id
      when 1
        return "user"
      when 2
        return "admin"
    end
  end

  def self.authenticate(mail, pass)
    user = User.find_by_mail(mail)
    if user && Password::check(pass, user.pass)
      user
    else
      return false
    end
  end

  def as_json(options = {})
    {
        :name => self.full_name,
        :country => self.shipment_address.country.name,
        :city => self.shipment_address.city,
        :address => self.shipment_address.street_address
    }
  end

  private

  def create_customer_profile
    response = GATEWAY_CIM.create_customer_profile(
        :profile => {
            :merchant_customer_id => self.id.to_s
        }
    ).params
    if response["customer_profile_id"]
      self.update_attribute("customer_profile_id", response["customer_profile_id"])
    end
  end

  def send_mail
    Mailer.welcome_email(self).deliver
  end

  def update_pass
    if self.pass_changed?
      self.pass = Password::update(self.pass)
    end
  end

end
