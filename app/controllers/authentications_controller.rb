class AuthenticationsController < Devise::OmniauthCallbacksController
  def facebook 
    auth = request.env["omniauth.auth"]
   
    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
   
    if authentication
      session[:fb_token] = auth["credentials"]["token"]
      # Authentication found, sign the user in.
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    else
      # Authentication not found, thus a new user.
      
      #user = User.new
      #user.apply_omniauth(auth)
      #if user.save(:validate => false)
        # session[:fb_token] = auth["credentials"]["token"]
      #  flash[:notice] = "Account created and signed in successfully."
      #  sign_in_and_redirect(:user, user)
      #else
        # flash[:error] = "Error while creating a user account. Please try again."
        redirect_to root_url
      #end
    end
  end
  
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
