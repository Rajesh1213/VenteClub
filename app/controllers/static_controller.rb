class StaticController < ApplicationController

  before_filter :current_user
  before_filter :read_cart
  before_filter :menu_data

  layout "main", :except => "size_chart"

  def how_it_works


    amount = 1000 # $10.00
    amount_to_charge = 11

    credit_card = ActiveMerchant::Billing::CreditCard.new(
        #:first_name => 'Bobik',
        #:last_name => 'Bobsen',
        :number => '424242424243422',
        :month => '8',
        :year => '2012',
        :verification_value => '123'
    )

    #
    #p GATEWAY_CIM.create_customer_profile(
    #      :profile => {
    #          :merchant_customer_id => "333334"
    #      }
    #  ).params["customer_profile_id"]
    #

    #p GATEWAY_CIM.create_customer_payment_profile(
    #      :customer_profile_id => "39644510",
    #      :payment_profile => {
    #          :payment => {
    #              :credit_card => credit_card
    #          }
    #      }
    #  ).inspect

    #if credit_card.valid?
    #  response = GATEWAY.purchase(amount, credit_card, {:order_id => "1234"})
    #  if response.success?
    #    puts "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"
    #  else
    #    raise StandardError, response.message
    #  end
    #else
    #
    #end


    #if credit_card.valid?
    #  response = GATEWAY.authorize(amount_to_charge*100, credit_card, :billing_address =>
    #      {:name => 'Mark McBride',
    #       :address1 => '33 New Montgomery St.',
    #       :city => 'San Francisco',
    #       :state => 'CA',
    #       :country => 'US',
    #       :zip => '760001',
    #       :phone => '(555)555-5555'})
    #
    #  if response.success?
    #    GATEWAY.capture(amount_to_charge, response.authorization)
    #    render :text => 'Success:' + response.message.to_s and return
    #  else
    #    render :text => 'Fail:' + response.message.to_s and return
    #  end
    #else
    #  render :text => 'Credit card not valid: ' + credit_card.validate.to_s and return
    #end


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
