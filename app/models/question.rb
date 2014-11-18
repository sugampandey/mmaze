class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers, :dependent => :destroy
  has_many :clues, :dependent => :destroy
  
  validates :quiz_id, :presence => true
  
  attr_accessible :points, :number_of_clues, :number_of_answers
end
