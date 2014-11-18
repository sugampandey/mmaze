class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :column
  validates :content, :presence => true
  validates :points, :presence => true
  validates :points, :numericality => true
  validates :question_id, :presence => true
  validate :check_primary_answer
  
  attr_accessible :content, :question_id, :primary, :column_id, :points
  
  before_save :set_primary_answer
  
  private
  def check_primary_answer
    pa = self.question.answers.where(:primary => true, :column_id => self.column_id).first if self.question
    if self.primary and pa and pa.id != self.id 
      errors.add(:primary, "There can be only one")  
    end
  end
  
  def set_primary_answer
    unless self.question.answers.where(:primary => true, :column_id => self.column_id).first
      self.primary = true
    end
  end
end
