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

  attr_accessible :card_type, :card_number, :cardholder_name, :expiration_month, :expiration_year


end
