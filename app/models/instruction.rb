class Instruction < ActiveRecord::Base
  validates :content, :presence => true
  attr_accessible :content, :quiz_id
end
