class Contact < ActiveRecord::Base
  validates :name, :presence => true
  validates :content, :presence => true
  validates :email, :presence => true
  validates_format_of     :email,
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'email must be valid'
  attr_accessible :content, :email, :name, :subject

  after_create :deliver_new_contact_email

  private
  def deliver_new_contact_email
  	ContactMailer.new_contact_email(self).deliver
  end
end
