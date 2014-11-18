class PostsController < ApplicationController
  layout 'blog'
  
  def index
    @posts = Post.published.limit(10).order("created_at DESC")
  end

  def show
    @post = Post.published.find(params[:id])
  end
end
