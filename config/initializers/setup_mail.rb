ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "musiquemaze.com",
  :user_name            => "editor@musiquemaze.com",
  :password             => "TheGreat123",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = APP_CONFIG[:host]
