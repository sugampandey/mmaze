class Quiz < ActiveRecord::Base
  belongs_to :category
  has_many :questions, :dependent => :destroy
  has_many :answers, :through => :questions
  has_many :columns, :dependent => :destroy
  has_many :instructions, :dependent => :destroy
  validates :name, :presence => true
  validates :category_id, :presence => true
  validates :name, :uniqueness => true

  accepts_nested_attributes_for :columns, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :instructions, :allow_destroy => true, :reject_if => proc { |attributes| attributes['content'].blank? }

  attr_accessible :name, :content, :category_id, :columns_attributes, :instructions_attributes

  default_scope order("quizzes.name ASC")

  def update_with_seed(quiz_params, questions_params, seeder_id)
    Quiz.transaction do
      begin
        if Seeder.find_by_id(seeder_id)
          self.columns.destroy_all
          self.questions.destroy_all
          self.instructions.destroy_all
        end
        update_attributes(quiz_params)

        unless questions_params.nil?
          questions_params.each do |question_key, question_hash|
            question = self.questions.build
            question.save

            question_hash.each do |columns_key, columns_hash|
              columns_hash.each do |column_key, column_hash|
                qc = self.columns[columns_key.to_i]
                if qc
                  if qc.is_answer
                    question.answers.build(:content => column_hash[:content], :points => 5.0, :column_id => qc.id)
                  else
                    question.clues.build(:content => column_hash[:content], :column_id => qc.id)
                  end
                  question.save
                end
              end
            end
          end
        end

        self.clue_columns_count = self.columns.where("is_answer = 0").size
        self.answer_columns_count = self.columns.where("is_answer = 1").size
        self.save
      rescue ActiveRecord::StatementInvalid
        false
      end
    end
  end

  def self.seed(params)
    @quiz = Quiz.new(params[:quiz])
    @seeder = Seeder.find_by_id(params[:seeder_id])

    Quiz.transaction do
      @doc = DocumentParser.parse_quiz_doc(@seeder.doc.path)
      @doc = @doc.first if @doc.is_a?(Array)
      @quiz.save

      unless params[:questions].nil?
        params[:questions].each do |question_key, question_hash|
          question = @quiz.questions.build
          question.save

          question_hash.each do |columns_key, columns_hash|
            columns_hash.each do |column_key, column_hash|
              qc = @quiz.columns[columns_key.to_i]
              if qc
                if qc.is_answer
                  question.answers.build(:content => column_hash[:content], :points => 5.0, :column_id => qc.id)
                else
                  question.clues.build(:content => column_hash[:content], :column_id => qc.id)
                end
                question.save
              end
            end
          end
        end
      end

      @quiz.clue_columns_count = @quiz.columns.where("is_answer = 0").size
      @quiz.answer_columns_count = @quiz.columns.where("is_answer = 1").size

      @quiz.save
    end
    return @quiz
  end
end
