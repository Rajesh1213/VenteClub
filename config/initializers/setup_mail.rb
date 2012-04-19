ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => 'dev.joinkingpin.com',
    :user_name => 'kingpin@magukr.com',
    :password => 'mailpass1',
    :authentication => 'plain',
    :enable_starttls_auto => true
}