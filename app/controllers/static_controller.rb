class StaticController < ApplicationController

  before_filter :current_user
  before_filter :read_cart
  before_filter :menu_data

  layout "main", :except => "size_chart"

  def how_it_works


    # Use the TrustCommerce test servers
    ActiveMerchant::Billing::Base.mode = :test

    gateway = ActiveMerchant::Billing::OrbitalGateway.new(
        :merchant_id => '1111',
        :login => 'TestMerchant',
        :password => 'password')

    # ActiveMerchant accepts all amounts as Integer values in cents
    amount = 1000 # $10.00

    # The card verification value is also known as CVV2, CVC2, or CID
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name => 'Bob',
        :last_name => 'Bobsen',
        :number => '4242424242424242',
        :month => '8',
        :year => '2012',
        :verification_value => '123')

    # Validating the card automatically detects the card type
    if credit_card.valid?
      # Capture $10 from the credit card
      response = gateway.purchase(amount, credit_card, {:order_id => "1234"})

      if response.success?
        puts "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"
      else
        raise StandardError, response.message
      end
    end


  end

  def terms_of_service
  end

  def privacy_notice
  end

  def security_notice
  end

  def terms_of_use
  end

  def return_and_refund_policy
  end

  def size_chart
  end

end
