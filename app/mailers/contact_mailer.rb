class ContactMailer < ActionMailer::Base
  default from: APP_CONFIG[:default_mail]

  def new_contact_email(contact)
    @contact = contact
    mail(:to => APP_CONFIG[:admin_mail], :subject => "Contact from User")
  end
end
