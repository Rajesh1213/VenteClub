class CreditCard < ActiveRecord::Base

  belongs_to :user

  default_scope :order => "card_type ASC"

  validates :user_id, :presence => true, :on => :create
  validates :card_type, :presence => true
  validates :card_number, :presence => true, :length => {:minimum => 12, :maximum => 20}
  validates :cardholder_name, :presence => true
  validates_numericality_of :expiration_month, :only_integer => true
  validates_inclusion_of :expiration_month, :in => 1..12
  validates_numericality_of :expiration_year, :only_integer => true
  validates_inclusion_of :expiration_year, :in => Date.today.year..Date.today.year + 10
  validates :cvv, :presence => true

  validate :check_credit_card

  attr_accessible :card_type, :card_number, :cardholder_name, :expiration_month, :expiration_year, :cvv
  attr_accessor :cvv

  after_validation :add_customer_payment_profile_id

  private

  def add_customer_payment_profile_id
    if self.user.customer_profile_id.blank?
      response = GATEWAY_CIM.create_customer_profile(
          :profile => {
              :merchant_customer_id => self.user.id.to_s
          }
      ).params
      if response["customer_profile_id"]
        self.user.update_attribute("customer_profile_id", response["customer_profile_id"])
      end

    end
    credit_card = card_from_params
    response = GATEWAY_CIM.create_customer_payment_profile(
        :customer_profile_id => self.user.customer_profile_id,
        :payment_profile => {
            :payment => {
                :credit_card => credit_card
            }
        }
    ).params
    if response["customer_payment_profile_id"]
      self.customer_payment_profile_id = response["customer_payment_profile_id"]
      self.card_number = credit_card.display_number
    end
  end

  def check_credit_card
    credit_card = card_from_params
    unless credit_card.valid?
      self.errors.add(:cardholder_name, " - First name " + credit_card.errors["first_name"].join(", ")) if credit_card.errors["first_name"].size > 0
      self.errors.add(:cardholder_name, " - Last name " + credit_card.errors["last_name"].join(", ")) if credit_card.errors["last_name"].size > 0
      self.errors.add(:card_number, credit_card.errors["number"].join(", ")) if credit_card.errors["number"].size > 0
      self.errors.add(:expiration_month, credit_card.errors["year"].join(", ")) if credit_card.errors["year"].size > 0
      self.errors.add(:card_type, credit_card.errors["brand"].join(", ")) if credit_card.errors["brand"].size > 0
    end
  end

  def card_from_params
    splitted_name = self.cardholder_name.split(" ")
    ActiveMerchant::Billing::CreditCard.new(
        :first_name => splitted_name[0],
        :last_name => splitted_name[1..splitted_name.size].join(" "),
        :number => self.card_number,
        :month => self.expiration_month,
        :year => self.expiration_year,
        :verification_value => self.cvv,
        :brand => self.card_type
    )
  end

end
