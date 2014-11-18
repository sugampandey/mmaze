class Admin::AnswersController < Admin::BaseController
  before_filter :load_question, :only => [:index, :new, :create]

  def index
  end
  
  def show
    @answer = Answer.find(params[:id])
  end

  def new
    @answer = @question.answers.build(params[:answer])
  end

  def create
    @answer = @question.answers.build(params[:answer])
    if @answer.save
      redirect_to admin_question_answers_url(@question), :notice => "Successfully created answer."
    else
      render :action => 'new'
    end
  end

  def edit
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      redirect_to admin_question_answers_url(@answer.question), :notice  => "Successfully updated answer."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    redirect_to admin_question_answers_url(@answer.question), :notice => "Successfully destroyed answer."
  end
  
  private 
  def load_question
    @question = Question.find(params[:question_id])
    @answers = @question.answers.paginate(:per_page => 20, :page => params[:page])
  end
end
