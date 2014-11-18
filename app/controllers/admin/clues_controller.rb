class Admin::CluesController < Admin::BaseController
  before_filter :load_question, :only => [:index, :create, :new]
  before_filter :load_clue, :only => [:show, :edit, :update, :destroy]
  
  def index
    @clues = @question.clues.all
  end

  def show
  end

  def new
    @clue = @question.clues.build
  end

  def create
    @clue = @question.clues.build(params[:clue])
    if @clue.save
      redirect_to [:admin, @clue], :notice => "Successfully created clue."
    else
      render :action => 'new'
    end
  end

  def edit
    @clue = Clue.find(params[:id])
  end

  def update
    @clue = Clue.find(params[:id])
    if @clue.update_attributes(params[:clue])
      redirect_to [:admin, @question, @clue], :notice  => "Successfully updated clue."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @clue = Clue.find(params[:id])
    @clue.destroy
    redirect_to admin_question_url(@question), :notice => "Successfully destroyed clue."
  end
  
  private 
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def load_clue
    @clue = Clue.find(params[:id])
  end
end
