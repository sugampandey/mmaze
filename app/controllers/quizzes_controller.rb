class QuizzesController < ApplicationController

  def search
    @quizzes = []
    unless params[:q].blank?
      @quizzes = Quiz.includes(:category).where("quizzes.name like ? or categories.name like ? or quizzes.content like ?", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%").paginate(:per_page => 20, :page => params[:page])
    end
  end
  
  def show
    @quiz = Quiz.find(params[:id])
    
    @questions = []
    @quiz.questions.each do |question|
      @questions << { :question_id => question.id, :answers => question.answers.order("`PRIMARY` DESC").map { |a| { :content => a.content, :column_id => a.column_id, :points => a.points, :correct => false, :primary => a.primary } } }
    end
    @totalPoints = 0
    @quiz.questions.each do |question|
      question.answers.select("distinct(column_id), points").each do |answer|
      	@totalPoints += answer.points
      end
    end
     
    @ct = Category.find_by_name("TOP 10 SONGS BY BAND/ARTIST")
    if @ct.name == @quiz.category.name
      @max_content_length = 50
    elsif Category.find_by_name("SONG LYRICS").name == @quiz.category.name
      @max_content_length = 35 
    else
      @max_content_length = 50
    end
    
    
    respond_to do |format|
      format.html { render :layout => "quiz" }
    end
  end
end
