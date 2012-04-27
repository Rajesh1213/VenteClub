class User < ActiveRecord::Base

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :mail, :presence => true, :uniqueness => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :pass, :presence => true, :length => {:minimum => 6}, :confirmation => true

  default_scope :order => "created_at ASC"

  attr_accessor :pass_confirmation

  attr_protected :role_id

  before_create :send_mail, :update_pass
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

  def send_mail
    Mailer.welcome_email(self).deliver
  end

  def update_pass
    if self.pass_changed?
      self.pass = Password::update(self.pass)
    end
  end

end
