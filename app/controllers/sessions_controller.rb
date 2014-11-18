class SessionsController < Devise::SessionsController
  layout 'admin'

  def facebook_logout
    split_token = session[:fb_token].split("|")
    fb_api_key = split_token[0]
    fb_session_key = split_token[1]
    redirect_to "https://www.facebook.com/logout.php?access_token=#{fb_api_key}&session_key=#{fb_session_key}&confirm=1&next=#{purge_user_session_url}"
  end
  
  def destroy
    super
    session[:fb_token] = nil
  end
  
  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def after_sign_in_path_for(resource_or_scope)
    if current_user.admin?
      admin_root_path
    else
      root_path
    end
  end
end
