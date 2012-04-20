ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => 'dev.venteclub.com',
    :user_name => 'venteclub@magukr.com',
    :password => 'vente_pass',
    :authentication => 'plain',
    :enable_starttls_auto => true
}