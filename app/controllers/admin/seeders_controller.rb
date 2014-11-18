class Admin::SeedersController < Admin::BaseController
  def index
    @seeders = Seeder.all
  end

  def show
    @seeder = Seeder.find(params[:id])
  end

  def new
    @seeder = Seeder.new
  end

  def create
    @seeder = Seeder.new(params[:seeder])
    if @seeder.save
      if params[:quiz_id].blank?
        redirect_to new_admin_quiz_url(:seeder_id => @seeder.id)
      else
        redirect_to edit_admin_quiz_url(params[:quiz_id], :seeder_id => @seeder.id)
      end
    else
      @quiz_id = params[:quiz_id]
      render :action => 'new'
    end
  end

  def edit
    @seeder = Seeder.find(params[:id])
  end

  def update
    @seeder = Seeder.find(params[:id])
    if @seeder.update_attributes(params[:seeder])
      if params[:quiz_id].blank?
        redirect_to new_admin_quiz_url(:seeder_id => @seeder.id)
      else
        redirect_to edit_admin_quiz_url(params[:quiz_id], :seeder_id => @seeder.id)
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @seeder = Seeder.find(params[:id])
    @seeder.destroy
    redirect_to admin_seeders_url, :notice => "Successfully destroyed seeder."
  end
end
