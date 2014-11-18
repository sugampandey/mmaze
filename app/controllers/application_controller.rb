require 'facebook_client'

class ApplicationController < ActionController::Base
  include FacebookClient
  
  protect_from_forgery

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ::AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  helper_method :facebook_session?
  helper_method :facebook_logged_in?
  helper_method :set_facebook_session
 
  before_filter :load_quiz_categories
  before_filter :setup_site_meta
  
  private
  
  def setup_site_meta
    @meta_keywords = "Test your popular music knowledge by playing our free interactive quizzes."
    @meta_description = "Online Music Trivia Quizzes, Online Music Trivia Games, Music Trivia Games Online, Free Music Trivia Games Online, Free Online Music Trivia Quizzes, Free Online Music Trivia Games, Free Interactive Music Trivia Quizzes, Free Interactive Music Trivia Games, Fun Musiq Games, Free Online Games Website, Play Free Online Website, Free Fun Music Trivia Quizzes, Free Fun Musiq Trivia Games Online, Play Free Music Quiz Online Website, Play Free Fun Music Games Online Website, Play Free Fun Music Quiz Online, Play Free Interactive Fun Music Trivia Quiz, Play Free Fun Music Trivia Quiz Online"
  end
  
  def load_quiz_categories
  	@categories = Category.published.find(:all, :include => [:quizzes], :limit => 15)  
  end

  def admin_required
    unless current_user and current_user.admin?
      redirect_to root_path
    end
  end
  
  def render_404(exception)
    logger.info "Not Found: '#{request.fullpath}'.\n#{exception.class} error was raised for path .\n#{exception.message}"
    @error = exception
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/errors', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
   
  end
  
  def render_500(exception)
    logger.info "System Error: Tried to access '#{request.fullpath}'.\n#{exception.class} error was raised for path .\n#{exception.message}"
    @error = exception
    respond_to do |format|
      format.html { render template: 'errors/error_500', layout: 'layouts/errors', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end
end
