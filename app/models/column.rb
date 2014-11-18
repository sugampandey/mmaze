class Column < ActiveRecord::Base
  belongs_to :quiz
  validates :name, :presence => true
  attr_accessible :name, :quiz_id, :is_answer

  def answer?
  	return is_answer == true
  end
end
