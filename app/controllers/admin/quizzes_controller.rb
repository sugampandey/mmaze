require 'document_parser'

class Admin::QuizzesController < Admin::BaseController
  before_filter :load_quiz, :only => [:show, :edit, :update, :destroy]
  before_filter :setup_quiz, :only => [:new, :edit]

  def index
    @quizzes = Quiz.paginate(:page => params[:page], :per_page => 30, :order => "name ASC")
  end

  def show
  end

  def new
  end

  def create
    @quiz = Quiz.seed(params)

    if @quiz.errors.empty?
      redirect_to [:admin, @quiz], :notice => "Successfully created quiz."
    else
      setup_quiz
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @quiz.update_with_seed(params[:quiz], params[:questions], params[:seeder_id])
      redirect_to [:admin, @quiz], :notice  => "Successfully updated quiz."
    else
      setup_quiz
      render :action => 'edit'
    end
  end

  def destroy
    @quiz.destroy
    redirect_to admin_quizzes_url, :notice => "Successfully destroyed quiz."
  end
  
  private

  def load_quiz
    @quiz = Quiz.find(params[:id])
  end

  def parse_seed_document
    @doc = DocumentParser.parse_quiz_doc(@seeder.doc.path)
    @doc = @doc.first if @doc.is_a?(Array)
    
    @quiz.category = Category.find_by_name(@doc[:quiz_category_name])
    @quiz.name = @doc[:quiz_name] 
    @quiz.content = @doc[:quiz_content]

    @doc[:instructions].each do |inst|
      @quiz.instructions.build(:content => inst)
      @quiz.instructions.reject!{|q|!q.new_record?}
    end

    @doc[:columns].each do |column|
      @quiz.columns.build(:name => column[:name], :is_answer => column[:is_answer])
      @quiz.columns.reject!{|q|!q.new_record?}
    end

    @questions = @doc[:questions]
  end

  def setup_quiz
    @quiz ||= Quiz.new
    @seeder = Seeder.find_by_id(params[:seeder_id])
    if @seeder.nil?
      @seeder = Seeder.new
      if @quiz.columns.empty?
        2.times { @quiz.columns.build } 
        @quiz.columns.build(:name => "Answer")
      end
      3.times { @quiz.instructions.build } if @quiz.instructions.empty? 
    else
      parse_seed_document
    end
  end
end
