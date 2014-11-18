class Admin::PostsController < Admin::BaseController
  include ActionView::Helpers::TextHelper
  
  def index
    @posts = Post.paginate(:per_page => 20, :page => params[:page]).order("created_at DESC")
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    if @post.save    
      redirect_to [:admin, @post], :notice => "Successfully created post."
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to [:admin, @post], :notice  => "Successfully updated post."
    else
      render :action => 'edit'
    end
  end
  
  def publish
    @post = Post.find(params[:id])
    @post.publish!
    
    if facebook_logged_in?
      flash[:fb_page_feed] = {}
      flash[:fb_page_feed][:name] = @post.title
      flash[:fb_page_feed][:link] = post_url(@post)
      flash[:fb_page_feed][:picture] = "http://#{APP_CONFIG[:host]}/images/musiquemaze-logo.png"
      flash[:fb_page_feed][:caption] = @post.title
      flash[:fb_page_feed][:description] = Sanitize.clean(truncate(@post.body, :length => 100))
      flash[:fb_page_feed][:message] = ""
    end
    
    redirect_to admin_posts_url, :notice => "Successfully published post."
  end

  def unpublish
    @post = Post.find(params[:id])
    @post.unpublish!
    koala_user = Koala::Facebook::API.new(session[:fb_token])
    redirect_to admin_posts_url, :notice => "Successfully unpublished post."
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_url, :notice => "Successfully destroyed post."
  end
end
