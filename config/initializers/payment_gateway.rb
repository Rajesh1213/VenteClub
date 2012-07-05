#ActiveMerchant::Billing::Base.mode = :test

if ENV['RAILS_ENV'] != 'production'
  GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
      :login => '4Y7JmYk3ZG',
      :password => '4W6s4u886jAfG6z7',
      :test => true
  )
  GATEWAY_CIM = ActiveMerchant::Billing::AuthorizeNetCimGateway.new(
      :login => '4Y7JmYk3ZG',
      :password => '4W6s4u886jAfG6z7',
      :test => true
  )
else
  GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
      :login => '4Y7JmYk3ZG',
      :password => '4W6s4u886jAfG6z7',
      :test => true
  )
  GATEWAY_CIM = ActiveMerchant::Billing::AuthorizeNetCimGateway.new(
      :login => '4Y7JmYk3ZG',
      :password => '4W6s4u886jAfG6z7',
      :test => true
  )
end