class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_required
  skip_before_filter :load_quiz_categories
  layout 'admin' 
end
