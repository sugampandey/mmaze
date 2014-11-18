class Admin::CategoriesController < Admin::BaseController
  before_filter :load_category, :only => [:show, :edit, :update, :destroy]
  
  def index
    @categories = Category.paginate(:page => params[:page], :per_page => 30)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to [:admin, @category], :notice => "Successfully created category."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to [:admin, @category], :notice  => "Successfully updated category."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_url, :notice => "Successfully destroyed category."
  end
  
  private
  def load_category
    @category = Category.find(params[:id])
  end
end
