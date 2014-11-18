class Admin::QuestionsController < Admin::BaseController
  before_filter :load_quiz, :only => [:index, :create, :new]
  
  def index
    @per_page = 30
    @page = params[:page].blank? ? 1 : params[:page].to_i
    @questions = @quiz.questions.paginate(:page => @page, :per_page => @per_page)
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = @quiz.questions.build
  end

  def create
    @question = @quiz.questions.build(params[:question])
    if @question.save
      redirect_to [:admin, @question], :notice => "Successfully created question."
    else
      render :action => 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      redirect_to [:admin, @quiz, @question], :notice  => "Successfully updated question."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to admin_quiz_questions_url(@question.quiz), :notice => "Successfully destroyed question."
  end
  
  private 
  def load_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
