class Subscriber < ActiveRecord::Base

  validates :mail, :presence => true, :uniqueness => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  attr_accessible :mail, :opened

  after_create :send_mail

  private

  def send_mail
    Mailer.welcome_subscriber(self).deliver
  end

end
