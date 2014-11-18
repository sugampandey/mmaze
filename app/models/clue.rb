class Clue < ActiveRecord::Base
  belongs_to :question
  belongs_to :column
  validates :content, :presence => true
  validates :question_id, :presence => true
  
  attr_accessible :content, :question_id, :column_id
end
