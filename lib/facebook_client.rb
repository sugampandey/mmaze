module FacebookClient
  def facebook_logged_in?
    facebook_session? and current_user
  end
  
  def facebook_session?
    session[:fb_token].present?
  end
  
  def set_facebook_session(token)
    session[:fb_token] = token
  end
end
